cluster_name = "poc-rancher"

control_plane_flavor  = "2C-4GB-40GB"
worker_flavor         = "2C-4GB-40GB"
lb_flavor             = "2C-4GB-40GB"
image                 = "Ubuntu 18.04"
external_network_name = "external"
availability_zone     = "south-2"
ssh_public_key_file   = "../work/poc-k8c.pub"
network  	      = "36881dc7-1809-45a0-a89c-34e038865974"
node_count          = 1