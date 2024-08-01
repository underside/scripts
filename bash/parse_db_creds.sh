#!/usr/bin/bash
SECRET_FILE=/home/i/tmp/tg.database.yaml

### $1 - path to file datastore.yaml with creds
### get creds from yaml file and then connect to DB
### ! Script tested with yq version v4.34.1 (https://github.com/mikefarah/yq) 


function get_creds_from_yaml_connect_db() {
    if [[ -z ${1} ]]; then
        echo "Variable SECRET_FILE (path to datastore.yaml file) is NOT defined" 
        exit 1
    fi
    # get first key from yaml file, for core it's core.tenants, for tg it's gate.tenants
    if [[ ${2} -eq "cc" ]]; then
        echo "Variable SECRET_FILE (path to datastore.yaml file) is NOT defined" 
        exit 1
    fi

    export first_key=$(yq '. | keys | .[0]' $SECRET_FILE)
    # create array with tenants name
    readarray tenants < <(yq '.[env(first_key)].tenants | keys' $SECRET_FILE | yq '.[]')
    # process tenants using tenants from array
    for ten in "${tenants[@]}"; do
        # remove all special symbols, allowed symbols: english alphabet, numbers, "-","_"
        ten=$(echo ${ten} | sed 's/[^[:alnum:]_-]//g' | xargs)
        URL_RAW=$(yq '.[env(first_key)]'.${ten}.datasource.url ${SECRET_FILE})
        USER_RAW=$(yq '.[env(first_key)]'.${ten}.datasource.username ${SECRET_FILE})
        PASS_RAW=$(yq '.[env(first_key)]'.${ten}.datasource.password ${SECRET_FILE} | xargs)
        PORT_RAW=$(echo "$URL_RAW" | awk -F/ '{print $3 }' | awk -F: '{ print $2 }' | xargs)
        export PG_USER=$USER_RAW
        export POSTGRES_URL=${URL_RAW#*jdbc:}
        export PGPASSWORD=$PASS_RAW
        export PG_PORT=$PORT_RAW
        echo "====tenant: ${ten}===="
        echo "POSTGRES_URL: $POSTGRES_URL" 
        echo "PG_USER: $PG_USER" 
        echo "PG_PORT: $PG_PORT"
        echo "========"
        #connect to PG DB with creds
        if [[ "${ON_ERROR_STOP}" = 1 ]]; then
            echo "psql -v ON_ERROR_STOP=1 -U ${PG_USER} -d ${POSTGRES_URL} -p ${PG_PORT} -a -w -f $dump_file"
        else
            echo "psql -U ${PG_USER} -d ${POSTGRES_URL} -p ${PG_PORT} -a -w -f $dump_file"
        fi
    done
}




get_creds_from_yaml_connect_db $SECRET_FILE
