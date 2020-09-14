Please wait after using the "terraform apply" command for 5-10 minutes. 
Apps takes time to deploy.
And please check if the export of credentials is done.

Don't forget to include the values of the variables such as project name, service account e-mail and etc. in the file terraform.tfvars.

You can use the bucket to load the desired files for the tomkat. To do this, uncomment the necessary lines in the managed_instance_groups module and in main.tf, enter the names and add your credits. (main.tf, terraform.tfvars, variables.tf)

You can also use autoskelling: you need to uncomment autohealing in the network module and in the managed_instance_groups module to uncomment autoscelling.

You need to modify the configuration file /etc/elasticsearch/elasticsearch.yml.
Example:

## name the cluster
cluster.name: my-cluster
node.name: es-node-1
node.master: true
node.data: false
## enter the private IP and port of the host:
network.host: 172.11.61.27
http.port: 9200
## specify IP of nodes for cluster assembly:
discovery.zen.ping.unicast.hosts: ["172.11.61.27", "172.31.22.131", "172.31.32.221"]

## name the cluster
cluster.name: my-cluster
node.name: es-node-2
node.master: false
node.data: true
## enter the private IP and port of the host:
network.host: 172.31.22.131
http.port: 9200
## specify IP of nodes for cluster assembly:
discovery.zen.ping.unicast.hosts: ["172.11.61.27", "172.31.22.131", "172.31.32.221"]

Don't forget to restart the elasticsearch service.
