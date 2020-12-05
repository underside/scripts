#!/bin/bash 

# login to needed cluster using oc login command 
ns_arr=()
count_tiller=0
IFS=$'\n' read -r -d '' -a ns_arr  < <(oc get projects | awk '{if( NR > 1 ) { print } }' | awk '{print $1}') 
count_ns=$(echo ${#ns_arr[@]})
for i in "${ns_arr[@]}"
do	
oc project $i 
tiller=$( oc get deployments | awk '{print $1}' | awk '{if( NR > 1 ) { print } }' ) 
if echo $tiller | grep 'tiller'; then
   echo "tiller was found in $i project"  >> log
   count_tiller=$[count_tiller + 1]
fi
# oc get deployments | awk '{print $1}' | awk '{if( NR > 1 ) { print } }' > $i
echo "$i project scanned" >> scanned
done	
echo "$count_ns projects was scanned and ${RED}$count_tiller${NC} tiller deployments was found. For more info check log file in this folder."
# if [ -f tiller ]; then 
#    echo "tiller found"
# else
#    echo "tiller NOT found"
# fi

