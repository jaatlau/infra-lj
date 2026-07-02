# TODO

# v002
- [x] Check opencode 
- [x] Check all bootstrap stuff that is required for data platform (CONTINUE FROM creating data-platform bootstrap.sh and check chatgippity for automated tailscale script)
- [x]  Install SeaweedFS
- [] Test seaweedFS

A. Fix on the running server (execute via SSH now)
# 1. Stop SeaweedFS
sudo systemctl stop seaweedfs

# 2. Get the Tailscale IP
TAILSCALE_IP=$(tailscale ip -4)

# 3. Update the systemd unit: add -filer, fix -ip
sudo sed -i "s|-s3.config=/dev/null|-filer|" /etc/systemd/system/seaweedfs.service
sudo sed -i "s|-ip=0.0.0.0|-ip=${TAILSCALE_IP}|" /etc/systemd/system/seaweedfs.service

# 4. Reload & restart
sudo systemctl daemon-reload
sudo systemctl restart seaweedfs

# 5. Verify
sudo journalctl -u seaweedfs -n 20 --no-pager
What happens: The filer creates its LevelDB store automatically at /data/seaweedfs/filerldb2/ â no manual steps needed.
B. Fix bootstrap.sh for future boots
Two changes needed:
1. Fetch Tailscale IP after bringing up Tailscale (insert after line 88 tailscale ip -4):
TAILSCALE_IP=$(tailscale ip -4 | head -1)
2. Update the systemd unit block (lines 138-144) â replace -s3.config=/dev/null and -ip=0.0.0.0 with the filer and Tailscale IP:
ExecStart=/usr/local/bin/weed server \
  -dir=\${SEAWEEDFS_DATA_DIR} \
  -s3 \
  -s3.port=8333 \
  -filer \
  -ip=${TAILSCALE_IP}
Note: use ${TAILSCALE_IP} (bash variable, not escaped) since it will be resolved at unit-creation time.
3. Fix bash syntax bug on line 59:
Change:
if [ -z "$TAILSCALE_AUTHKEY" || -z "$SEAWEEDFS_AWS_ACCESS_KEY_ID" || -z "$SEAWEEDFS_AWS_SECRET_ACCESS_KEY"  ]; then
To:
if [ -z "$TAILSCALE_AUTHKEY" ] || [ -z "$SEAWEEDFS_AWS_ACCESS_KEY_ID" ] || [ -z "$SEAWEEDFS_AWS_SECRET_ACCESS_KEY" ]; then
C. Test from your local machine
# Check master & filer are alive
curl http://<TAILSCALE_IP>:9333/cluster/status
curl http://<TAILSCALE_IP>:8888/    # filer HTTP endpoint

# S3 with hierarchy
aws s3 --endpoint-url http://<TAILSCALE_IP>:8333 mb s3://raw-files
aws s3 --endpoint-url http://<TAILSCALE_IP>:8333 cp somefile.txt s3://raw-files/some/deep/path/
aws s3 --endpoint-url http://<TAILSCALE_IP>:8333 ls s3://raw-files/some/deep/



# v001
- [x] destroy solution file, make it work!
- [x] fix the relative path problem for main.tf for stacks!!
- [x] stackable requires that workflow files should take the input of name of the stack that you want to deploy or destroy
- [x] add Destroy yml
- [x] Make repository stackable, meaning that each solution (like this data platform) is in its own subfolder. check chatgpt discussion terraform hetzner setup issues as solution


# init work
- [x] GITHUB repo settings, doppler settings, terraform cloud settings
- [x] THINK OF PLAN TO REPLACE AWS SERVICES!! (account deleted, would need to upgrade to paid plan) mini IO perhaps
- [x] Add rest of the resources required for debp project (hetzner variables to doppler) CONTINUE HERE!! VARIABLES ARE ADDED BUT DEPENDENCIES BETWEEN MODULES WILL FAIL THE RUN. CHECK CHATGPT DISCUSSION TERRAFORM HETZNER SETUP ISSUES THERE IS A SOLUTION!



