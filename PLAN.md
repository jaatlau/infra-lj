# `ilj describe` — Terminal Architecture Visualiser

## Goal

A CLI tool that visually describes a solution's architecture in the terminal. Each solution lives under `stacks/<solution_name>/` and consists of a `main.tf` (Terraform) and optionally a `bootstrap.sh`.

Command: `python scripts/ilj describe <solution_name>`

## Core Design Principles

- **Fully auto-detected** — parses `main.tf` and `bootstrap.sh`; no per-solution metadata required.
- **Terminal-only output** — Unicode box-drawing characters, no external viewer needed.
- **Zero external dependencies** — pure Python 3 with `argparse` (stdlib only).
- **One level deep** — inspects modules called by `main.tf`, but not their children.

## Visualisation Concept

```
┌─────────────────────────────────────────────────────┐
│                   Data Platform                      │
│                                                      │
│  ┌──────────────────────────────────────────────┐   │
│  │          Hetzner Server (CX22)               │   │
│  │                                              │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐   │   │
│  │  │  Docker   │  │ Tailscale│  │Doppler CLI│   │   │
│  │  └──────────┘  └──────────┘  └──────────┘   │   │
│  └──────────────────────────────────────────────┘   │
│         ▲                          ▲                 │
│         │ attached                  │ protects       │
│         │                          │                 │
│  ┌──────┴──────┐        ┌──────────┴──────────┐    │
│  │  SSH Key    │        │     Firewall         │    │
│  │  (hcloud)   │        │  ├─ SSH(22)          │    │
│  └─────────────┘        │  ├─ FastAPI(8000)    │    │
│                         │  └─ Tailscale(41641) │    │
│                         └─────────────────────┘    │
└─────────────────────────────────────────────────────┘
```

The diagram always shows:
- **Title**: solution name derived from the directory name.
- **Server box**: the primary compute resource with services nested inside.
- **Attachments**: other resources (SSH keys, firewalls, etc.) connected with labelled edges.

## File Structure

```
scripts/ilj                # single executable entry point
```

One file initially. Can be split into modules if complexity grows.

## Auto-Detection Logic

### 1. Parse `main.tf` — HCL parsing (regex-based, no external lib)

- Extract `module "..." { ... }` blocks: name, `source` path, variable references.
- For local modules (`source = "../../modules/..."`), read the child `main.tf`.
- Extract `resource "type" "name" { ... }` from child modules.
  - `hcloud_server` → server resource.
  - `hcloud_firewall` → firewall resource; also extract rules (port, protocol, direction).
  - `hcloud_ssh_key` → SSH key resource.
- Detect inter-module dependencies: if one module's output (`module.X.Y`) is passed as input to another module → add an edge.
- Heuristic for primary resource: `hcloud_server` wins; if none, treat the first `resource` as primary. If no primary found, render all top-level modules as peers (services section is skipped).

### 2. Parse `bootstrap.sh` — pattern matching

Detect known installation patterns and map to service names:

| Pattern | Service |
|---|---|
| `get.docker.com` | Docker |
| `tailscale.com/install.sh` | Tailscale |
| `packages.doppler.com` | Doppler CLI |
| `apt-get install <pkg>` | listed Debian packages |

Services are rendered inside the server box.

### 3. Edge detection

- Module references (`module.X.attribute` passed as a variable to module Y) → directed edge from Y to X.
- SSH key modules referenced in server's `ssh_key_ids` → "attached" edge.
- Firewall modules referenced in server's `firewall_ids` → "protects" edge.

## CLI Interface

```
python scripts/ilj describe <solution_name>   # render diagram to terminal
python scripts/ilj list                        # list available solutions
```

### `describe` subcommand

1. Resolve `stacks/<solution_name>/main.tf` — error if not found.
2. Parse `main.tf` → modules + resources + edges.
3. Parse `stacks/<solution_name>/bootstrap.sh` (optional) → services.
4. Build internal model (Architecture with Nodes and Edges).
5. Render terminal diagram.

### `list` subcommand

1. Scan `stacks/` for subdirectories containing `main.tf`.
2. Print each solution name and a one-line summary (parsed from the `name` variable or first comment).

## Implementation Steps

1. Create `scripts/ilj` with `#!/usr/bin/env python3` shebang.
2. Implement HCL parser (`read_main_tf`, `read_module_main_tf`, extract resources + inter-module refs).
3. Implement bootstrap parser (`read_bootstrap`, detect services).
4. Implement model layer (Architecture, Node, Edge dataclasses).
5. Implement renderer (Unicode box-drawing, coloured sections).
6. Implement CLI (`argparse` with `describe` and `list` subcommands).
7. Test with `stacks/data-platform/`.
8. Make `scripts/ilj` executable with `chmod +x`.
9. Update `TODO.md`: mark visualisation task as done.

## Handling Different Architectures

Since each solution composes different modules, the tool handles variation by:

| Scenario | Behaviour |
|---|---|
| No `bootstrap.sh` | Skip services section; render infra only |
| No server resource | Render all modules as peer boxes, no nested services |
| Multiple server resources | Use first as primary, rest as peer attachments |
| No inter-module refs | Render all modules as peers with no edges |
| Unknown module source | Show module name + source path, generic type label |
| Remote modules (registry) | Show source URL, no deep inspection |

## Out of Scope (v1)

- Real-time state from Terraform Cloud / Doppler.
- Image/HTML/SVG output.
- Interactive diagrams.
- Deep recursion into nested modules.
- `architecture.yaml` metadata file (can be added later).
