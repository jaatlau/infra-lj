# TODO

# v002
- [x] Check opencode 
- [x] Check all bootstrap stuff that is required for data platform (CONTINUE FROM creating data-platform bootstrap.sh and check chatgippity for automated tailscale script)
- [] Build simple visualisation tool where you type command "ilj describe <solution_name>" and then it describes visually of what that solution lookslike. Should this be in some other repo?
- []  Install miniIO via Docker? So that we can start working on the data platform, and add it to bootstrap.sh
- [] Install Postgres via Docker? So that we can start working on the data platform, and add it to bootstrap.sh



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



