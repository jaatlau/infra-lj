# Data Platform Stack

## Purpose
Hosts data platform in hetzner cloud environment

## Components
- 1x Hetzner server
    - Hetzner firewall rules "default"
    - Tailscale
    - MiniIO (raw data)
    - Postgres (database)
- 1x Hetzner SSH key


## Deployment

### Prerequisites
- Hetzner account

### Deployment flow
- Create Hetzner project (manual)
- Inside project create api token (manual)
- Save api token as Doppler secret (manual)
- Locally, create ssh key and save public key content as Doppler secret (manual)
- check required list of variables that are needed in Doppler

- Run provision.yml as explained in project root readme.md

