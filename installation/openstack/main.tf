############# DATA #######################
data "openstack_compute_keypair_v2" "deployer" {
  name       = "${var.cluster_name}"
}

################# RESOURCES ##############
resource "openstack_networking_port_v2" "control_plane" {
  count          = var.node_count
  name  = "${var.cluster_name}-control-plane-${count.index}"
  admin_state_up     = "true"
  dns_name    = "${var.cluster_name}-control-plane-${count.index}"
  network_id     = var.network
  # the default security group
  security_group_ids = ["f876acc8-1cc8-4c96-9f13-728f1bfbcb23"]
  # hierbei bin ich mir unsicher, aber ich hoffe, dass das nur netzintern den filter deaktiviert
  port_security_enabled = false
}

resource "openstack_compute_instance_v2" "control_plane" {
  count       = var.node_count
  name        = "${var.cluster_name}-${count.index + 1}"
  image_name    = var.image
  flavor_name = var.control_plane_flavor
  config_drive= true
  availability_zone_hints = var.availability_zone
  key_pair    = data.openstack_compute_keypair_v2.deployer.name

  network {
    port = element(openstack_networking_port_v2.control_plane.*.id, count.index)
  }
}

resource "openstack_networking_floatingip_v2" "control_plane" {
  count       = var.node_count
  pool = "external"
}


resource "openstack_compute_floatingip_associate_v2" "control_plane" {
  count       = var.node_count
  floating_ip = element(openstack_networking_floatingip_v2.control_plane.*.address, count.index)
  instance_id = openstack_compute_instance_v2.control_plane[count.index].id
}

# --- rancher-kubernetes-engine (rke) ---
data "template_file" "nodes" {
  count    = var.node_count
  template = file("${path.module}/template.d/node.yml.tpl")

  vars = {
    internal_address = element(openstack_compute_instance_v2.control_plane.*.network.0.fixed_ip_v4, count.index)
    external_address = element(openstack_networking_floatingip_v2.control_plane.*.address, count.index)
  }
}


data "template_file" "cluster-config" {
  template = file("${path.module}/template.d/cluster.yml.tpl")

  vars = {
    nodes = join("\n", data.template_file.nodes.*.rendered)
    floating_ip = openstack_networking_floatingip_v2.control_plane[0].address
  }
}

resource "local_file" "cluster-config" {
  content              = data.template_file.cluster-config.rendered
  filename             = "${path.module}/cluster.yml"
  directory_permission = "750"
  file_permission      = "600"
}
