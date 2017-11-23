## Snapshots from OpenShift Persistent Volumes in AWS

This container is meant to be used as a Kubernetes CronJob to periodically create snapshots from EBS volumes used in OpenShift as Persistent Volumes.

The following parameters must be passed to the container:

    **AWS_ACCESS_KEY_ID**: AWS Key ID to be used
    **AWS_SECRET_ACCESS_KEY**: AWS Secret Key to be used
    **AWS_REGION**: AWS Region where EBS volumes reside
    **NSPACE**: OpenShift Namespace where Persistent Volumes are defined (can be ALL)
    **VOL**: Persistent Volume Claim name (can be ALL)
