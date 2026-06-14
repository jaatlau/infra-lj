# Data Platform Stack

## Purpose
Hosts data platform in hetzner cloud environment

## Components
- 1x Hetzner server
    - Hetzner firewall rules "default"
    - Docker
    - Doppler CLI
    - Tailscale
    - Seaweedfs (raw data)
    - Postgres (database)
- 1x Hetzner SSH key


## Deployment

### Prerequisites
- Hetzner account, Hetzner project, Hetzner api token generated (server hosted here)
- Locally generated ssh key (to access initially to the server)
- Locally installed Tailscale, and authkey generated (bind your local dev machine to remote host to securely access only from your local machine)
- variables to add to Doppler:
  - variables.tf file variables (with prefix of TF_VAR_)
  - TAILSCALE_AUTHKEY
  - SEAWEEDFS_AWS_ACCESS_KEY_ID
  - SEAWEEDFS_AWS_SECRET_ACCESS_KEY

### Deployment flow
- Run provision.yml as explained in project root readme.md
- Copy the bootstrap.sh file to server:
```bash
# replace <SSH_KEY_NAME> and <REMOTE_SERVER_IP>, local ssh key file name that you created and remote server ip found from output of provision for instance, respectively.
scp -i ~/.ssh/<SSH_KEY_NAME> ./bootstrap.sh root@<REMOTE_SERVER_IP>:/root/ 
```

- Run the bootstrap.sh via SSH to install the following services:
-- Doppler CLI
-- Docker
-- Tailscale
-- SeaweedFS
```bash
# replace <SSH_KEY_NAME> and <REMOTE_SERVER_IP> and <DOPPLER_TOKEN>, local ssh key file name that you created and remote server ip found from output of provision for instance and doppler token defined in your solution doppler project, respectively.
ssh -i ~/.ssh/<SSH_KEY_NAME> root@<REMOTE_SERVER_IP> \
  chmod +x /root/bootstrap.sh && /root/bootstrap.sh <DOPPLER_TOKEN>
```



