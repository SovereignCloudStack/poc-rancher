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
  security_group_ids = ["9f155500-8e55-475d-a525-2a09bad0fa28"]
}

resource "openstack_networking_port_v2" "jump_host" {
  name  = "poc-rancher-jump"
  admin_state_up     = "true"
  dns_name    = "poc-rancher-jump"
  network_id     = var.network
  # the default security group
  security_group_ids = ["de83841a-3cb0-431d-83dd-fea11ea4aaf5"]
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

resource "openstack_compute_instance_v2" "jump_host" {
  name        = "poc-rancher-jump"
  image_name    = var.image
  flavor_name = var.control_plane_flavor
  availability_zone_hints = var.availability_zone
  config_drive= true
  key_pair    = data.openstack_compute_keypair_v2.deployer.name

  network {
    port = openstack_networking_port_v2.jump_host.id
  }
}

resource "openstack_networking_floatingip_v2" "jump_host" {
  pool = "external"
}

resource "openstack_compute_floatingip_associate_v2" "jump_host" {
  floating_ip = openstack_networking_floatingip_v2.jump_host.address
  instance_id = openstack_compute_instance_v2.jump_host.id
}
