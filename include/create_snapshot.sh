#!/bin/bash

NAMESPACE=$1
VOLUME=$2

TMPFILE1=$(mktemp /tmp/tmp.XXXXXXXXXXXXX)
TMPFILE2=$(mktemp /tmp/tmp.XXXXXXXXXXXXX)

if [ -z "$NAMESPACE" -o "$NAMESPACE" = " " ]; then
    echo "A Namepace must be provided or select ALL"
    exit 2
fi
case "$NAMESPACE" in
        "ALL")
            oc get pv --no-headers | awk {'print $1'} > $TMPFILE1
            if [ ! $? -eq 0 ]; then
                echo "Error while getting EBS volumes information"
                exit 2
            else
                oc describe pv $(cat $TMPFILE1) | grep VolumeID | cut -d "/" -f 4 > $TMPFILE2
                NOVOL=$(grep "No resources found" $TMPFILE2 | wc -l)
                if [ $NOVOL -gt 0 ];then
                    echo "There are no presistent volumes configured"
                    exit 1
                else
                    while read vol
                    do
                        echo "Creating snapshot for EBS volume " $vol
                        echo 'aws ec2 create-snapshot --volume-id $vol --description "Automted Snapshot by aws-ocp-snap"'
                    done < $TMPFILE2
                fi
            fi
            ;;
        *)
            if [ -z "$VOLUME" -o "$VOLUME" = " " ]; then
                echo "A Volume must be provided or select ALL"
                exit 2
            fi
            case "$VOLUME" in
                    "ALL")
                        oc get pvc --no-headers -n $NAMESPACE | awk {'print $3'} > $TMPFILE1
                        if [ ! $? -eq 0 ]; then
                            echo "Error while getting EBS volumes information"
                            exit 2
                        else
                            oc describe pv $(cat $TMPFILE1) | grep VolumeID | cut -d "/" -f 4 > $TMPFILE2
                            NOVOL=$(grep "No resources found" $TMPFILE2 | wc -l)
                            if [ $NOVOL -gt 0 ];then
                                echo "There are no presistent volumes configured"
                                exit 1
                            else
                                while read vol
                                do
                                    echo "Creating snapshot for EBS volume " $vol
                                    echo 'aws ec2 create-snapshot --volume-id $vol --description "Automted Snapshot by aws-ocp-snap"'
                                done < $TMPFILE2
                            fi
                        fi
                        ;;
                    *)
                        oc get pvc --no-headers $VOLUME -n $NAMESPACE | awk {'print $3'} > $TMPFILE1
                        if [ ! $? -eq 0 ]; then
                            echo "Error while getting EBS volumes information"
                            exit 2
                        else
                            oc describe pv $(cat $TMPFILE1) | grep VolumeID | cut -d "/" -f 4 > $TMPFILE2
                            NOVOL=$(grep "No resources found" $TMPFILE2 | wc -l)
                            if [ $NOVOL -gt 0 ];then
                                echo "There are no presistent volumes configured"
                                exit 1
                            else
                                while read vol
                                do
                                    echo "Creating snapshot for EBS volume " $vol
                                    echo 'aws ec2 create-snapshot --volume-id $vol --description "Automted Snapshot by aws-ocp-snap"'
                                done < $TMPFILE2
                            fi
                        fi
                        ;;
            esac
            ;;
esac