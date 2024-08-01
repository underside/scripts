#!/bin/bash 

source ~/sens/env_vars.sh

mkdir -p ${dir_path}
base_url=$gitlab_dev_base_url

for repo in $(curl -s --header "PRIVATE-TOKEN: ${gitlab_mfms_full_token}" ${base_url}/${gitlab_group_id}/projects | jq -r ".[].ssh_url_to_repo"); do cd $dir_path; git clone $repo; done;


