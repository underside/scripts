#!/usr/bin/bash
. /home/i/sens/env_vars.sh
jira_api_url=https://<jira_fqdn>/rest/api/2
jira_pat_url=https://<jira_fqdn>/rest/pat/latests/tokens
jira_issue=TS-11111
status_id=211
json_template='{
    "update": {
        "comment": [
            {
                "add": {
                    "body": "test commment"
                }
            }
        ]
    },
    "transition": {
        "id": "%s"
    }
    
}'

json_pat='{"name": "gncPersonalToken","expirationDuration": "8000"}'
json_data=$(printf "$json_template" "$status_id")

get_personal_token(){
  echo $jira_pat_url
  curl -v \
    --data "${json_pat}" \
    -X POST \
    -u $JIRA_USER:$JIRA_PASS \
    -H "Content-Type: application/json" \
    $jira_pat_url

    
}

get_transition_ids(){
  jira_url=$jira_api_url/issue/$jira_issue/transitions?expand=transitions.fields
  curl -v \
  -u $JIRA_USER:$JIRA_PASS \
  -H "Content-Type: application/json" \
  $jira_url
}

change_issue_status(){
  jira_url=$jira_api_url/issue/$jira_issue/transitions
  echo $jira_url
  curl -v \
    --data "${json_data}" \
    -X POST \
    -u $JIRA_USER:$JIRA_PASS \
    -H "Content-Type: application/json" \
    $jira_url
    
}

get_status(){
  jira_url=$jira_api_url/issue/$jira_issue/?fields=status
  echo $jira_url
  resp=$(curl -v $jira_url \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${JIRA_TOKEN}")
  echo $resp | jq .fields.status.id
}

####MAIN
# change_issue_status
# get_transition_ids
# get_personal_token
# 
# get_status
