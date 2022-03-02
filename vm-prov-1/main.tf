## Provider ##

terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"  
    }
  }
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

# If you have a self-signed cert
  allow_unverified_ssl = false
}

## Data

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "tmpl-centos7min" {
  name          = var.vsphere_vm_template
#  template_uuid = "42249d02-cea5-39b5-ed66-9f60a135fd21"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "vlan-109" {
  name          = var.vsphere_network-1
  datacenter_id = data.vsphere_datacenter.dc.id
}

## Resources

resource "vsphere_virtual_machine" "new-vm" {
  name             = var.vsphere_vm_name
  folder           = var.vsphere_folder_name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id         = "centos7_64Guest"
  wait_for_guest_net_timeout  = -1
  force_power_off = true

  network_interface {
    network_id   = data.vsphere_network.vlan-109.id
    adapter_type = data.vsphere_virtual_machine.tmpl-centos7min.network_interface_types[0]
  }

  disk {
    label = "disk0"
    size = "${data.vsphere_virtual_machine.tmpl-centos7min.disks.0.size}"
    thin_provisioned = "${data.vsphere_virtual_machine.tmpl-centos7min.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.tmpl-centos7min.id
  }
}