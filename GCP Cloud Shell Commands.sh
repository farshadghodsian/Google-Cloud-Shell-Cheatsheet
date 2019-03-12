###################################
### Google Cloud Shell Basics   ###
###################################

#Authenticate yourself in Cloud Shell (or change to another user)
gcloud auth loggin

##it will give you a URL to go to to authenticate (example shown below)
https://accounts.google.com/o/oauth2/auth?redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&prompt=select_account&response_type=code&client_id=32555940559.apps.googleusercontent.com&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloud-platform+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fappengine.admin+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcompute+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Faccounts.reauth&access_type=offline

#and then give you a token to put back in Cloud Shell prompt (example shown below)
4/8wBRLfFq4wcqpvHMwrfn2MBG9O9f64M7fSntCVyXoWdYtLwlpYBBLH8

#Set Default Project
gcloud config set project learningautomation-io-test

#Alternatively you could set Project ID using the built in DEVSHELL_PROJECT_ID environment variable to set to your current CloudShell project
gcloud config set project $DEVSHELL_PROJECT_ID

#Get current GCloud config
gcloud config list

#Get all GCloud Configs, even ones that arent set yet
gcloud config list --all

#Get Project ID of current project
gcloud config get-value project

#Display list of CE Machine Types
gcloud compute machine-types list

#Get current default Region/Zone
gcloud config get-value compute/region
gcloud config get-value compute/zone

#Set default Region/Zone
gcloud config set compute/region
gcloud config set computer/zone

#Get listing of current gcloud config settings like project ID
gcloud config list
gcloud config list | grep project  (for example to get just the current project ID)

#Set current Project ID as an Environment variable
export PROJECTID="$(gcloud config get-value project -q)"


#Adding your zone to MY_ZONE Environment variable for ease of use
export MY_ZONE=us-central1-a

## List GCP Compute Regions
gcloud compute regions list

asia-southeast1          0/24  0/4096    0/8        0/8                 UP
australia-southeast1     0/24  0/4096    0/8        0/8                 UP
europe-north1            0/24  0/4096    0/8        0/8                 UP
europe-west1             0/24  0/4096    0/8        0/8                 UP
europe-west2             0/24  0/4096    0/8        0/8                 UP
europe-west3             0/24  0/4096    0/8        0/8                 UP
europe-west4             0/24  0/4096    0/8        0/8                 UP
northamerica-northeast1  0/24  0/4096    0/8        0/8                 UP
southamerica-east1       0/24  0/4096    0/8        0/8                 UP
us-central1              0/24  0/4096    0/8        0/8                 UP
us-east1                 0/24  0/4096    0/8        0/8                 UP
us-east4                 0/24  0/4096    0/8        0/8                 UP
us-west1                 0/24  0/4096    0/8        0/8                 UP
us-west2                 0/24  0/4096    0/8        0/8                 UP

## Setting Env variables in Cloud Shell
INFRACLASS_REGION=us-central1
echo $INFRACLASS_REGION

INFRACLASS_PROJECT_ID=[YOUR_PROJECT_ID]


## Save this to a config file
mkdir infraclass
touch infraclass/config
echo INFRACLASS_REGION=$INFRACLASS_REGION >> ~/infraclass/config
echo INFRACLASS_PROJECT_ID=$INFRACLASS_PROJECT_ID >> ~/infraclass/config


## use the persistent config file to set ENV variables
source ~/infraclass/config
echo $INFRACLASS_PROJECT_ID


## Save source command to Cloud Shell .profile (acts like .bashrc file)
nano .profile
Add souce command to bottom of file, save and restart ur Cloud Shell

## Resetting Cloud Shell to default stat (Important: This will permanently delete all files in your home directory)
#To restore your Cloud Shell home directory to a clean state first check for personal files in the home directory:
#Remove all files from your home directory (save them somewhere else first if needed):

ls -a $HOME
sudo rm -rf $HOME

#In the Cloud Shell menu, click the three dots menu icon, then click Restart Cloud Shell. Click Restart Cloud Shell in the confirmation dialog. A new VM will be provisioned and the home directory will be restored to its default state.


## Referencing values in Cloud Shell commands
User Account = $(gcloud config get-value account)
Project ID   = $(gcloud config get-value project -q)



#############################
### Cloud Storage Buckets ###
#############################

#### Creating a Bucket
gsutil mb gs://[bucket-name]

#### Displaying the contents of a Storage Bucket
gsutil ls gs://[bucket-name]

#### Copying a file from Cloud Shell to Storage Bucket
gsutil cp my-file.txt gs://[bucket-name]

#### Copy a file from Storage Bucket to server/cloud shell
gsutil cp gs://[bucket-name]/sample.txt .

#### Displaying the contents of a Storage Bucket
gsutil ls gs://[bucket-name]

#### To get access control list for a file in Cloud Bucket
gsutil acl get gs://$BUCKET_NAME_1/setup.html  > acl.txt
cat acl.txt

#### Set ACL for file to private and print out the acl list again
gsutil acl set private gs://$BUCKET_NAME_1/setup.html
gsutil acl get gs://$BUCKET_NAME_1/setup.html  > acl2.txt
cat acl2.txt

#### To make a file publicly readable and check acl again to verify
gsutil acl ch -u AllUsers:R gs://$BUCKET_NAME_1/setup.html
gsutil acl get gs://$BUCKET_NAME_1/setup.html  > acl3.txt
cat acl3.txt

#### Generate a Customer Supplied Encryption Key (CSEK)
python -c 'import base64; import os; print(base64.encodestring(os.urandom(32)))'

#### Will generate a base64 encoded key like this
Y0EpmDNdr9o5EHg9KsaR4Y6WWytJKy0bQG5b7S9tmVE=

#### then put the above key in the .boto file like so
encryption_key=Y0EpmDNdr9o5EHg9KsaR4Y6WWytJKy0bQG5b7S9tmVE=

#### Now any files that are upload using gsutil will be encrypted bya CSEK you created instead of Google Provided keys

#### Generate a new .boto config file for gsutil
gsutil config -n

#### Get details of gsutil version and config including location of .boto file
gsutil version -l

#### To rotate Encryption keys generate a new one with the python command above and place old key in decription_key1 value in .boto file
#### Place new encryption key in the encryption_key value and then rewrite the required files in the Storage bucket
gsutil rewrite -k gs://$BUCKET_NAME_1/testfile.html

### Any file trying to be copyed over with out proper decryption keys will give this error
No decryption key matches object gs://really-cool-test-bucket/testfile.html.


#### View Current Lifecycle policy for Storage Bucket
gsutil lifecycle get gs://$BUCKET_NAME_1

#### Example Lifecyle policy JSON file
{
  "rule":
  [
    {
      "action": {"type": "Delete"},
      "condition": {"age": 61}
    }
  ]
}

#### Set new Lifecycle policy via a JSON file
gsutil lifecycle set lifecycle.json gs://$BUCKET_NAME_1

#### Get versioning policy for Storage Bucket (Suspended policy means that it is not enabled)
gsutil versioning get gs://$BUCKET_NAME_1

#### Enable versioning on Storage Bucket
gsutil versioning set on gs://$BUCKET_NAME_1

#### Copy a file to Storage Bucket with versioning option
gsutil cp -v testfile.html gs://$BUCKET_NAME_1

#### List all versions of a file
gsutil ls -a gs://$BUCKET_NAME_1/testfile.html

gs://really-cool-test-bucket/testfile.html#1551838445092743  <--- this is the oldest version
gs://really-cool-test-bucket/testfile.html#1551839990886092
gs://really-cool-test-bucket/testfile.html#1551840022565501  

#### To enable directory sync with folder on VM to Storage Bucket
gsutil rsync -r ./folder gs://$BUCKET_NAME_1/folder

#################################
###  VPC/Firewall Netwokring  ###
#################################

#List of forwarding rules
gcloud compute forwarding-rules list

# Creating Automode network and associated Firewall rules
gcloud compute --project=learning-automation-io-test networks create learnauto --description="Learn about auto-mode networks" --subnet-mode=auto

gcloud compute --project=learning-automation-io-test firewall-rules create learnauto-allow-ssh --description="Allows TCP connections from any source to any instance on the network using port 22." --direction=INGRESS --priority=65534 --network=learnauto --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0

gcloud compute --project=learning-automation-io-test firewall-rules create learnauto-allow-rdp --description="Allows RDP connections from any source to any instance on the network using port 3389." --direction=INGRESS --priority=65534 --network=learnauto --action=ALLOW --rules=tcp:3389 --source-ranges=0.0.0.0/0

gcloud compute --project=learning-automation-io-test firewall-rules create learnauto-allow-icmp --description="Allows ICMP connections from any source to any instance on the network." --direction=INGRESS --priority=65534 --network=learnauto --action=ALLOW --rules=icmp --source-ranges=0.0.0.0/0

gcloud compute --project=learning-automation-io-test firewall-rules create learnauto-allow-internal --description="Allows connections from any source in the network IP range to any instance on the network using all protocols." --direction=INGRESS --priority=65534 --network=learnauto --action=ALLOW --rules=all --source-ranges=10.128.0.0/9


# create a subnet and alias ip range

gcloud compute networks subnets create subnet-a \
    --network network-a \
    --range 10.128.0.0/16 \
    --secondary-range container-range=172.16.0.0/20

# Create VMs with alias
gcloud compute instances create vm1 [...] \
    --network-interface subnet=subnet-a,aliases=container-range:172.16.0.0/24
gcloud compute instances create vm2 [...] \
    --network-interface subnet=subnet-a,aliases=container-range:172.16.1.0/24

# Expand a subnet
gcloud compute networks subnets \
expand-ip-range new-useast  \
--prefix-length 23 \
--region us-east1

#### Create firewall rule to allow external traffic on port 80 and 443 (eg. for nginx)
gcloud compute firewall-rules create nginx-firewall \
 --allow tcp:80,tcp:443 \
 --target-tags nginxstack-tcp-80,nginxstack-tcp-443
 
 
###################################################
####     Create VPN for VPC Network Peering    ####
###################################################

#### Need to create a VPN gateway on each VPC network in order to peer networks together
gcloud compute target-vpn-gateways \
create vpn-1 \
--network vpn-network-1  \
--region us-east1

gcloud compute target-vpn-gateways \
create vpn-2 \
--network vpn-network-2  \
--region europe-west1

#### Reserve static IP address for VPN
gcloud compute addresses create --region us-east1 vpn-1-static-ip
gcloud compute addresses create --region europe-west1 vpn-2-static-ip

#### View static IP address for VPN
gcloud compute addresses list

NAME             ADDRESS/RANGE  TYPE  PURPOSE  NETWORK  REGION    SUBNET  STATUS
vpn-1-static-ip  34.73.244.192                          us-east1          RESERVED
vpn-2-static-ip  34.76.176.141                          europe-west1      RESERVED

#### Create ESP Firewall rule for VPN Gateway
gcloud compute \
forwarding-rules create vpn-1-esp \
--region us-east1  \
--ip-protocol ESP  \
--address $STATIC_IP_VPN_1 \
--target-vpn-gateway vpn-1

gcloud compute \
forwarding-rules create vpn-2-esp \
--region europe-west1  \
--ip-protocol ESP  \
--address $STATIC_IP_VPN_2 \
--target-vpn-gateway vpn-2

#### Create UDP500 Firewall rule for VPN Gateway
gcloud compute \
forwarding-rules create vpn-1-udp500  \
--region us-east1 \
--ip-protocol UDP \
--ports 500 \
--address $STATIC_IP_VPN_1 \
--target-vpn-gateway vpn-1

gcloud compute \
forwarding-rules create vpn-2-udp500  \
--region europe-west1 \
--ip-protocol UDP \
--ports 500 \
--address $STATIC_IP_VPN_2 \
--target-vpn-gateway vpn-2

#### Create UDP4500 Firewall Rule for VPN Gateway
gcloud compute \
forwarding-rules create vpn-1-udp4500  \
--region us-east1 \
--ip-protocol UDP --ports 4500 \
--address $STATIC_IP_VPN_1 \
--target-vpn-gateway vpn-1

gcloud compute \
forwarding-rules create vpn-2-udp4500  \
--region europe-west1 \
--ip-protocol UDP --ports 4500 \
--address $STATIC_IP_VPN_2 \
--target-vpn-gateway vpn-2

#### List VPN Gateways
gcloud compute target-vpn-gateways list

NAME   NETWORK        REGION
vpn-2  vpn-network-2  europe-west1
vpn-1  vpn-network-1  us-east1


#### Creat tunnels for VPN Gateway
#### Tunnel network1-to-network2
gcloud compute \
vpn-tunnels create tunnel1to2  \
--peer-address $STATIC_IP_VPN_2 \
--region us-east1 \
--ike-version 2 \
--shared-secret gcprocks \
--target-vpn-gateway vpn-1 \
--local-traffic-selector 0.0.0.0/0 \
--remote-traffic-selector 0.0.0.0/0

#### Tunnel network2-to-network1
gcloud compute \
vpn-tunnels create tunnel2to1 \
--peer-address $STATIC_IP_VPN_1 \
--region europe-west1 \
--ike-version 2 \
--shared-secret gcprocks \
--target-vpn-gateway vpn-2 \
--local-traffic-selector 0.0.0.0/0 \
--remote-traffic-selector 0.0.0.0/0

#### View VPN Tunnels
gcloud compute vpn-tunnels list

NAME        REGION        GATEWAY  PEER_ADDRESS
tunnel2to1  europe-west1  vpn-2    34.73.244.192
tunnel1to2  us-east1      vpn-1    34.76.176.141

#### Create Static Routes
gcloud compute  \
routes create route1to2  \
--network vpn-network-1 \
--next-hop-vpn-tunnel tunnel1to2 \
--next-hop-vpn-tunnel-region us-east1 \
--destination-range 10.1.3.0/24

gcloud compute  \
routes create route2to1  \
--network vpn-network-2 \
--next-hop-vpn-tunnel tunnel2to1 \
--next-hop-vpn-tunnel-region europe-west1 \
--destination-range 10.5.4.0/24

#### List all routes
gcloud compute routes list


###################################
### Google Compute Engine (GCE) ###
###################################

#### List all compute instances
gcloud compute instances list

#### Create a VM Instance using Cloud Shell
gcloud compute instances create testvm1 --zone us-central1-c

#### SSH into the new VM instance straight from Cloud Shell
gcloud compute ssh testvm1 --zone us-central1-c


# Using for loop to create multiple Compute VM Instances (eg. 3 nginx instances)
for i in {1..3}; \
do \
  gcloud compute instances create "nginx-$i" \
  --machine-type "f1-micro" \
  --tags nginx-tcp-443,nginx-tcp-80 \
  --zone us-central1-f \
  --image   "https://www.googleapis.com/compute/v1/projects/bitnami-launchpad/global/images/bitnami-nginx-1-14-0-4-linux-debian-9-x86-64" \
  --boot-disk-size "200" --boot-disk-type "pd-standard" \
  --boot-disk-device-name "nginx-$i"; \
done

#### Delete VM Instance
gcloud compute instances delete [vm-name] --keep-disks

# Authorize VM to use the Google Cloud API via Service Account
gcloud auth activate-service-account --key-file credentials.json

# To initialize the Google Cloud SDK if not already setup by deafault on your VM
https://cloud.google.com/sdk/downloads


# To add start-up script to VM add custom metadata to VM in edit screen with key name startup-script
# You can do the same for shutdown script by added a custom metadata with key name shutdown-script


#### Creating a persistant disk
gcloud compute instances attach-disk gcelab --disk mydisk --zone us-central1-c

#### Attaching a persistant disk
gcloud compute instances attach-disk gcelab --disk mydisk --device-name <YOUR_DEVICE_NAME> --zone us-central1-c

#### To mount and format a Persistent Disk
# Create a folder to act as a mount point 
sudo mkdir /mnt/mydisk

# Get disk ID
ls -l /dev/disk/by-id/

# Format the attached disk
sudo mkfs.ext4 -F -E lazy_itable_init=0,\
lazy_journal_init=0,discard \
/dev/disk/by-id/[disk name]
#example:
sudo mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1

# Mount the disk
sudo mount -o discard,defaults /dev/disk/by-id/[disk name] /mnt/[mount point]
#example:
sudo mount -o discard,defaults /dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1 /mnt/mydisk

#### Automatically mount the disk on restart
# Edit fstab file
sudo nano /etc/fstab

# Add following line at the end of the file and save
/dev/disk/by-id/[disk name] /mnt/[mount folder] ext4 defaults 1 1
# example:
/dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1 /mnt/mydisk ext4 defaults 1 1



#### For migrating data from a persistant disk to another region:
# 1. Unmount file system(s)
# 2. Create snapshot
# 3. Create disk in new region from snapshot
# 4. Create instance in new region
# 5. Attach disk

#### For documentation on using Local SSDs (best used as swap disk fro their fast performance, but lack of redundancy)
https://cloud.google.com/compute/docs/disks/local-ssd#create_a_local_ssd

##########################################
####    Other Useful Linux commands   ####
##########################################

# For snapshoting boot disk safest is to halt/shutdown the system
sudo shutdown -h now

# Unmounting disk to take a snapshot 
sudo unmount </mount/point>

# Freezing a partition to take a snapshot if you cant unmount
#1. Stop application from writing to disk
#2. Complete pending writes and flush cache
sudo sync
#3. Suspend/freeze writing to disk device
sudo fsfreeze -f </mount/point>

# Using screen to run a detached session
sudo apt-get install -y screen

sudo screen -S [name of screen] [command you want to run]
# To detach the screen terminal, press Ctrl+A, D. To reattach screen type
sudo screen -r [name of screen]
# Send a command to a screen
sudo screen -r -X [name of scree] '[command]\n'

# Setting up a crontab job
sudo crontab -e

# To see information about unused and used memory and swap space on your custom VM, run the following command:
free

# To see details about the RAM installed on your VM, run the following command:
sudo dmidecode -t 17

# To verify the number of processors, run the following command:
nproc

#To see details about the CPUs installed on your VM, run the following command:
lscpu

######################################
### Google Kubernetes Engine (GKE) ###
######################################

#Creating a cluster on GKE
gcloud container clusters create webfrontend --zone $MY_ZONE --num-nodes 2

#If zone is already set in gcloud config then it can be ommitted like so
gcloud container clusters create networklb --num-nodes 3  

#List all running clusters
gcloud container clusters list

#List running clusters in a specific region
gcloud container clusters list --region us-central1

NAME                 LOCATION     MASTER_VERSION  MASTER_IP       MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
my-regional-cluster  us-central1  1.11.6-gke.2    35.184.129.220  n1-standard-1  1.11.6-gke.2  3          RUNNING

#List node-pools in cluster
gcloud container node-pools list --cluster my-regional-cluster --region us-central1

NAME          MACHINE_TYPE   DISK_SIZE_GB  NODE_VERSION
default-pool  n1-standard-1  15            1.11.6-gke.2

#Add a node-pool to cluster
gcloud container node-pools create my-pool --num-nodes=2 \
> --cluster my-regional-cluster --region us-central1

#Resize node-pool
gcloud container clusters resize my-regional-cluster --region us-central1 --node-pool default-pool --size=4

#Resize Kubernetes Cluser
gcloud container clusters resize  webfrontend --size=2 --zone us-central1-a

#Delete Deployment/Workloads in GKE
kubectl describe deployment nginx-1
kubectl delete deployment nginx-1

#Delete cluster in GKE
gcloud container clusters delete webfrontend --zone us-central1-a
gcloud container clusters delete networklb

#Create Regional cluster in GKE (default runs in 3 zones in that Region)
gcloud container clusters create my-regional-cluster \
--num-nodes 1 \
--region us-central1 \
--disk-size=15GB \
--enable-autoscaling --min-nodes 1 --max-nodes 10 \
--enable-autorepair

#Create Zonal cluster in GKE
gcloud container clusters create my-zonal-cluster --zone us-central1-a \
--preemptible \
--machine-type n1-standard-1 \
--no-enable-cloud-monitoring \
--no-enable-cloud-logging

#Udating a Zonal cluster to multiple zones (multi-region)
gcloud container clusters update my-zonal-cluser --zone us-central1-a \
--node-locations us-central1-a,us-central1-b

#Get details of your cluster in GKE
gcloud container clusters describe my-zonal-cluster --zone us-central1-a

#Update config/settings of a GKE Cluster (eg. enable StackDriver logging)
gcloud container clusters update my-zonal-cluster --zone us-central1-a --logging-service="logging.googleapis.com"

### USING KUBECTL  ###

#Install or Check to see if you have most uptodate version of KubeCTL
gcloud components install kubectl

#switch current context for kubectl and update kubeconfig file which kubectl uses to store cluster authentication information
gcloud beta container clusters get-credentials my-regional-cluster \
--region us-central1 --project qwiklabs-gcp-08c3e58bd80f329e

#this can also be accessed via the Connect button in GKE Clusters console window
gcloud container clusters get-credentials test-cluster --zone us-central1-a --project qwiklabs-gcp-2de127a77da5556b


# Build docker container (requires a Dockerfile in current directory)
docker build -t gcr.io/PROJECT_ID/hello-node:v1 .

# Run docker image
docker run -d -p 8080:8080 gcr.io/PROJECT_ID/hello-node:v1

# Push to Google Docker Private Registry
gcloud docker -- push gcr.io/PROJECT_ID/hello-node:v1

#######################
### Using Kubectl   ###
#######################

#Get cluster information
kubectl cluster-info

#For troubleshooting 
kubectl get events
kubectl logs <pod-name>

#Get listing of pods
kubectl get pods
kubectl get pods -owide #to get all pods in cluster
kubectl get pod -l app=nginx #to select via label selector

#Get listing of nodes
kubectl get nodes

#Get list of exposed services
kubectl get services
kubectl get service nginx

#Get current context for your session (to determine which cluster etc. kubectl will use)
kubectl config current-context

#View details of your kubeconfig file
kubectl config view

#View your kubeconfig file
cat ~/.kube/config

#Deploy and run a container (by default it will run in the cluster you created if you only have one)
kubectl run nginx --image=nginx:1.10.0 --replicas=2
kubectl run php-apache --image=k8s.gcr.io/hpa-example --requests=cpu=200m --expose --port=80

#Delete Service (exposed IP)
kubectl delete service nginx-1

#Delete deployment/workload
kubectl delete deployment nginx-1

#Exposing Service using Kubectl
kubectl expose deployment nginx --port 80 --target-port 80 --type LoadBalancer
kubectl expose deployment test-website --type LoadBalancer --port 80 --target-port 80

#For reasons on when you would use ClusterIP, NodePort, or Loadbalancer see this link:
https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0

#Exposing Service on each Node's IP at a static port (the NodePort)
kubectl expose deployment nginx --target-port=80 --type=NodePort0

#To Use a Cloud Load Balancer to expose services using the NodePort first create an ingress.yaml file
nano ingress.yaml

#Example Ingress file
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: basic-ingress
spec:
  backend:
    serviceName: nginx
    servicePort: 80

#More Advanced Ingress file #You can define rules that direct traffic by host/path to multiple Kubernetes services.
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: example-ingress
spec:
  backend:
    serviceName: default-handler
    servicePort: 80
  rules:
  - host: my.app.com
    http:
      paths:
      - path: /tomcat
        backend:
          serviceName: tomcat
          servicePort: 8080
      - path: /nginx
        backend:
          serviceName: nginx
          servicePort: 80

#Now create the ingress service
kubectl create -f ingress.yaml

#Monitor the progress of the ingress service (ctrl+C to break out)
kubectl get ingress basic-ingress --watch

#Check status of ingress service
kubectl describe ingress basic-ingress

#Lastly to get external IP address of this httploadbalancer
kubectl get ingress basic-ingress

# Scale up a deployment
kubectl scale deployment hello-node --replicas=4

#Autoscale a deployment
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10

#### Edit a deployment file
kubectl edit deployment hello-node


#Delete the ingress object
kubectl delete -f basic-ingress.yaml

#Get status of Horizontal Pool Autoscaler
kubectl get hpa

NAME         REFERENCE               TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   <unknown>/50%   1         10        1          33s

#Generate load on cluster for testing
kubectl run -i --tty load-generator --image=busybox /bin/sh
\# while true; do wget -q -O- http://php-apache.default.svc.cluster.local;done

# Docker build in GKE (Dockerfile has to be present in directory)
docker build -t [to register with Google container registry use gcr.io/] [root directory of dockerfile]
docker build -t gcr.io/${PROJECTID}/test-website:v1 .

#Example Dockerfile:
FROM nginx:alpine
COPY default.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html

#View list of Docker images
docker images

REPOSITORY                                          TAG                 IMAGE ID            CREATED             SIZE
gcr.io/learning-automation-io-test-repo/test-website   v1                  b75227aae838        2 minutes ago       16.1MB
nginx                                               alpine              b411e34b4606        2 weeks ago         16.1MB

#Allow GCLOUD to setup credential help for all registries
gcloud  auth configure-docker

 {
  "credHelpers": {
    "gcr.io": "gcloud",
    "us.gcr.io": "gcloud",
    "eu.gcr.io": "gcloud",
    "asia.gcr.io": "gcloud",
    "staging-k8s.gcr.io": "gcloud",
    "marketplace.gcr.io": "gcloud"
  }
}

#Add newly built docker image into Google Container Registry
docker push gcr.io/${PROJECTID}/test-website:v1 

The push refers to repository [gcr.io/learning-automation-io-test-repo/test-website]
1bb84fde1fdc: Pushed
722b159e05a8: Pushed
979531bcfa2b: Layer already exists
8d36c62f099e: Layer already exists
4b735058ece4: Layer already exists
503e53e365f3: Layer already exists
v1: digest: sha256:33692b607ee955714e84929ecc588840aeba1287ddf7fac6e3b7e0dafc4f274c size: 1568


#Create ingress object
kubectl create -f ingress.yaml

# Ingress can provide load balancing, SSL termination and name-based virtual hosting.
# More details can be found in Googles documentation:  
https://kubernetes.io/docs/concepts/services-networking/ingress/

#Example ingress.yaml file:
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
    name: test-website-ingress
spec:
    backend:
        serviceName: test-website
        servicePort: 80

#Get details of ingress object
kubectl get ingress test-website-ingress --watch

NAME                   HOSTS     ADDRESS   PORTS     AGE
test-website-ingress   *                   80        3s
test-website-ingress   *         34.95.70.83   80        13s
test-website-ingress   *         34.95.70.83   80        13s

#Get details of ingress object
kubectl describe ingress test-website-ingress

Name:             test-website-ingress
Namespace:        default
Address:          34.95.70.83
Default backend:  test-website:80 (10.8.1.8:80,10.8.1.9:80,10.8.2.6:80)
Rules:
  Host  Path  Backends
  ----  ----  --------
  *     *     test-website:80 (10.8.1.8:80,10.8.1.9:80,10.8.2.6:80)
Annotations:
  ingress.kubernetes.io/forwarding-rule:  k8s-fw-default-test-website-ingress--0e20ca25204f6195
  ingress.kubernetes.io/target-proxy:     k8s-tp-default-test-website-ingress--0e20ca25204f6195
  ingress.kubernetes.io/url-map:          k8s-um-default-test-website-ingress--0e20ca25204f6195
  ingress.kubernetes.io/backends:         {"k8s-be-30480--0e20ca25204f6195":"Unknown"}
Events:
  Type    Reason  Age   From                     Message
  ----    ------  ----  ----                     -------
  Normal  ADD     1m    loadbalancer-controller  default/test-website-ingress
  Normal  CREATE  1m    loadbalancer-controller  ip: 34.95.70.83

#Creating persistant disks
kubectl apply -f test-website-volumeclaim.yaml

#Example yaml file for persistant disk
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
    name: test-website-volumeclaim
spec:
    accessMode:
    - ReadWriteOnce
    resources:
        requests:
            storage: 200Gi

#Get status of persistent volume claims (persistent disks)
kubectl get pvc

#detele persistent volume claim
kubectl delete pvc test-website-volumeclaim
kubectl delete pvc test-mysql-volumeclaim

#Create secret object in Kubectl
kubectl create secret generic mysql --from-literal=password=ReallyStrongPassword123

#Referencing Secret object in .yaml file
...
    spec: containers:
    - image: mysql:5.6
      name: mysql
      env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
            name: mysql
            key: password
...

#Setting current account as admin on cluster via role binding
kubectl create clusterrolebinding cluster-admin-binding \
 --clusterrole=cluster-admin \
 --user=$(gcloud config get-value account)

 #Create service account (tiller is server side of Helm package manager)
 kubectl create serviceaccount tiller --namespace kube-system

#Initiate Helm
./helm init --service-account=tiller

#Update Helm
./helm update

#Check Helm version
./helm version

#Install Jenkins using Helm
./helm install -n cd stable/jenkins \
 -f jenkins/values.yaml  \
 --version 0.16.6 --wait

#Get your 'admin' user password by running:
printf $(kubectl get secret --namespace default cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

#Save POD name to env variable
export POD_NAME=$(kubectl get pods -l "component=cd-jenkins-master" -o jsonpath="{.items[0].metadata.name}")

#Port forward port on pod
kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &

#Create new namespace
kubectl create ns production

#deploy to a specific namespace
kubectl apply -f k8s/production -n production

#Get External IP of app (app name is gceme-frontend in this example and it is in the production namespace)
export FRONTEND_SERVICE_IP=$(kubectl get -o \
jsonpath="{.status.loadBalancer.ingress[0].ip}" \
 --namespace=production services gceme-frontend)


########################################
####   Kubernetes Dashboard Beta    ####
########################################

#### First grant cluster level permissions
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value account)

#### Create a new dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml

#### Edit yaml file for dashboard
kubectl -n kube-system edit service kubernetes-dashboard
# change "type: ClusterIP" to "type: NodePort" and save file

#### Get Token for logging into K8s Dashboard
kubectl -n kube-system describe $(kubectl -n kube-system \
get secret -n kube-system -o name | grep namespace) | grep token:

#### Open connection to dashboard on port 8081 for example
kubectl proxy --port 8081
# use Cloud Shell's web preview and change port to 8081 to view the page. You first need to remove the /?authuser=0 and then add the /api/v1/... similar to the URL below to access the dashboard

https://8081-dot-6692035-dot-devshell.appspot.com/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/service?namespace=default

# Select Token and paste in the Token you copied above to access the Dashboard

#########################
####    App Engine   ####
#########################

#### Download a sample Hello World App Engine app
mkdir appengine-hello
cd appengine-hello
gsutil cp gs://cloud-training/archinfra/gae-hello/* .

#### Run the sample Hello World app in Cloud Shell's local development server
dev_appserver.py $(pwd)

#### Afer running the above command go to In click Web Preview in Cloud Shell to Preview on port 8080

#### To deploy app to App Engine
gcloud app deploy app.yaml

#### Once deployed you can test your app by going to the URL provide with this command
gcloud app browse

#### To redeploy app in App Engine (The --quiet flag disables all interactive prompts when running gcloud commands. If input is required, defaults will be us)
gcloud app deploy app.yaml --quiet

#########################
####    Cloud SQL    ####
#########################

#### Different Connection methods to connect to Cloud SQL
https://cloud.google.com/sql/docs/mysql/external-connection-methods?hl=en_US&_ga=2.121186319.-668297787.1549999676


########################
####    BigQuery    ####
########################

#### Example Syntax for a query in BigQuery
SELECT *
FROM [DatasetID.TableID]
WHERE (DatasetID.TableID.Field > 0);

#### Example BigQuery from example dataset that has 22,537 records
SELECT product, resource_type, start_time, end_time,
cost, project_id, project_name, project_labels_key, currency, currency_conversion_rate,
usage_amount, usage_unit
FROM [cloud-training-prod-bucket.arch_infra.billing_data]
WHERE ([cloud-training-prod-bucket.arch_infra.billing_data.cost] > 0)
  LIMIT 100

#### Grouping data in your Query
SELECT product, COUNT(*)
FROM [cloud-training-prod-bucket.arch_infra.billing_data]
WHERE ([cloud-training-prod-bucket.arch_infra.billing_data.cost] > 1)
GROUP BY product


########################
#### Stack Driver   ####
########################

#### To install Stack Driver monitoring agent
curl -O https://repo.stackdriver.com/stack-install.sh
sudo bash stack-install.sh --write-gcm

#### To install Stack Driver logging agent (for EC2 and Compute Engine resources as App Engine Kubernetes engine have it built-in already)
curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
sudo bash install-logging-agent.sh

#### Note that Stackdriver Logging only keeps logs for 30 days. To keep logs longer they need to be exported to Cloud Storage

#################################
###  Cloud Source Repository  ###
#################################

#Create a repo
gcloud alpha source repos create test_repo

#Use GCloud Credential helper
git config credential.helper gcloud.sh

#Add you Google Cloud Repo as current branch
git remote add origin https://source.developers.google.com/p/learning-automation-io-test/r/test_repo

git config --global user.email "testaccount@google_test.com"
git config --global user.name "Google Tester"




################################
### USING DEPLOYMENT MANAGER ###
################################

#Copying file from Google Cloud resource to your Cloud Shell terminal (using gsutil)
gsutil cp gs://cloud-training/gcpfcoreinfra/mydeploy.yaml mydeploy.yaml

#Creating deployment from yaml file
gcloud deployment-manager deployments create my-first-depl --config mydeploy.yaml


##############################################
####    Using Terraform in Cloud Shell    ####
##############################################

#Download and Install Terraform
wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
unzip terraform_0.11.13_linux_amd64.zip

#Export Terraform path
export PATH="$PATH:$HOME/terraform"
cd /usr/bin
sudo ln -s $HOME/terraform
cd $HOME
source ~/.bashrc

# Now you can use Terraform init, plan, apply, etc. without having to specify the Google Cloud (GCP) provider or use a credentials file from a service account to provision infrastructure!