# Deploy in Kubernetes

## Deployment
**This setup need Kubernetes 1.8 !**  
The deployment use the hostPath type definition and the mount propagation features.  
More information in :  
https://kubernetes.io/docs/concepts/storage/volumes/#hostpath  
https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation

This setup include config files inside a secret but you can use a volume.  
https://kubernetes.io/docs/concepts/configuration/secret/

Just think to correctly named the _nodeSelector_ at the end of the definition of the deployment.
