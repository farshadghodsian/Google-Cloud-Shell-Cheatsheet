#Set default Region/Zone
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a

#### 1. Create the GKE Cluster (extra scopes enable Jenkins to access Cloud Source Repositories and Google Container Registry)
gcloud container clusters create gke-cluster \
--num-nodes 1 \
--machine-type n1-standard-2 \
--scopes "https://www.googleapis.com/auth/projecthosting,cloud-platform"

#### 2. Config Kubectl credentials for cluster
gcloud container clusters get-credentials gke-cluster

#### Check Cluster info
kubectl cluster-info

#### Install Helm
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz
tar zxfv helm-v2.9.1-linux-amd64.tar.gz
cp linux-amd64/helm .
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value account)
kubectl create serviceaccount tiller --namespace kube-system
kubectl create clusterrolebinding tiller-admin-binding --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

#### Downlaod Jenkins install from repo
git clone https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git

### Use Helm to install Jenkins
../helm/helm install -n cd stable/jenkins -f jenkins/values.yaml --version 0.16.6 --wait

#### Get Jenkins admin password
printf $(kubectl get secret --namespace default cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

#### Port Forward Jenkins 8080 to Cloud Shell 
export POD_NAME=$(kubectl get pods --namespace default -l "component=cd-jenkins-master" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080