# TODO

- [x] GITHUB repo settings, doppler settings, terraform cloud settings
- [x] THINK OF PLAN TO REPLACE AWS SERVICES!! (account deleted, would need to upgrade to paid plan) mini IO perhaps
- [ ] Add rest of the resources required for debp project (hetzner variables to doppler)


- setup steps:
--doppler account + project
--hetzner account + create project + api token
--github add doppler token as repo secret
--terraform create organization + api token + workspaces for dev and prod 

Its important to name doppler secrets properly:
-- for instance TF_VAR prefix -> automatically picked as terraform variables
-- for instance TERRAFORM_CLOUD_ORGANIZATION -> automatically picked as terraform provider organization (required)
-- for instance TERRAFORM_CLOUD_WORKSPACE -> automatically picked as terraform provider workspace (required for choosing correct environment)

