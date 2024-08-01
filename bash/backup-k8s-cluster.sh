#!/usr/bin/bash

# 
backup_namespace(){
    ws="/home/i/tmp/backup/ns"
    namespace=$1
    for type in $(kubectl get -n $namespace -o=name pvc,configmap,serviceaccount,secret,ingress,service,deployment,statefulset,hpa,job,cronjob,cm)
    do
            mkdir -p $(dirname $ws/$ns/$type)
            kubectl get -n $namespace -o=yaml $type > $ws/$ns/$type.yaml
    done
}

backup_all_namespaces(){
    ws="/home/i/tmp/backup/multi-ns"
    namespace=$1
    for ns in $(kubectl get -o=name namespaces | cut -d '/' -f2)
    do
        for type in $(kubectl get -n $ns -o=name pvc,configmap,serviceaccount,secret,ingress,service,deployment,statefulset,hpa,job,cronjob)
        do
            mkdir -p $(dirname $ws/$ns/$type)
            kubectl get -n $ns -o=yaml $type > $ws/$ns/$type.yaml
        done
    done
}



# Main
# backup_namespace ns-example
# backup_all_namespaces ns-example
