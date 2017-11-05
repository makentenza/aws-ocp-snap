#!/bin/bash

NAMESPACE=$1
VOLUME=$2

TMPFILE=$(mktemp /tmp/tmp.XXXXXXXXXXXXX)

if [ -z "$NAMESPACE" -o "$NAMESPACE" = " " ]; then
    echo "A Namepace must be provided or select ALL"
    exit 2
fi
case "$NAMESPACE" in
        "ALL")
            oc describe pv $(oc get pv --no-headers | awk {'print $1'}) | grep VolumeID | cut -d "/" -f 4 >> $TMPFILE
            if [ ! $? -eq 0 ]; then
                echo "Error while getting EBS volumes information"
                exit 2
            fi
            NOVOL=$(grep "No resources found" $TMPFILE | wc -l)
            if ( $NOVOL -gt 0 );then
                echo "There are no presistent volumes configured"
                exit 1
            fi
            while read vol
            do
                echo "Creating snapshot for EBS volume " $vol
                aws ec2 create-snapshot --volume-id $vol --description "Automted Snapshot by aws-ocp-snap"
            done < $TMPFILE
            ;;
        *)
            if [ -z "$VOLUME" -o "$VOLUME" = " " ]; then
                echo "A Volume must be provided or select ALL"
                exit 2
            fi
            case "$VOLUME" in
                    "ALL")
                        oc describe pv $(oc get pvc --no-headers -n $NAMESPACE | awk {'print $3'}) | grep VolumeID | cut -d "/" -f 4 >> $TMPFILE
                        if [ ! $? -eq 0 ]; then
                            echo "Error while getting EBS volumes information"
                            exit 2
                        fi
                        NOVOL=$(grep "No resources found" $TMPFILE | wc -l)
                        if ( $NOVOL -gt 0 );then
                            echo "There are no presistent volumes configured"
                            exit 1
                        fi
                        while read vol
                        do
                            echo "Creating snapshot for EBS volume " $vol
                            aws ec2 create-snapshot --volume-id $vol --description "Automted Snapshot by aws-ocp-snap"
                        done < $TMPFILE
                        ;;
                    *)
                        oc describe pv $(oc get pvc --no-headers $VOLUME -n $NAMESPACE | awk {'print $3'}) | grep VolumeID | cut -d "/" -f 4 >> $TMPFILE
                        if [ ! $? -eq 0 ]; then
                            echo "Error while getting EBS volumes information"
                            exit 2
                        fi
                        NOVOL=$(grep "No resources found" $TMPFILE | wc -l)
                        if ( $NOVOL -gt 0 );then
                            echo "There are no presistent volumes configured"
                            exit 1
                        fi
                        while read vol
                        do
                            echo "Creating snapshot for EBS volume " $vol
                            aws ec2 create-snapshot --volume-id $vol --description "Automted Snapshot by aws-ocp-snap"
                        done < $TMPFILE
                        ;;
            esac
esac