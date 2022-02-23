## TFCB
provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = var.endpoint
}
#terraform {
#  credentials "app.terraform.io" {
#    token = ""
#    }
#  cloud {
#    organization = "CSSLAB"

#    workspaces {
#      name = "vm-prov"
#    }
#  }
#}

## Provider

provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = ""
  vsphere_server = "csslab-rtp-vc-01.cisco.com"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

## Data

data "vsphere_datacenter" "dc" {
  name = "RTP"
}

data "vsphere_datastore" "datastore" {
  name          = "HXDS-1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "CSS-Cluster-HX"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "CSS-Cluster-HX/Resources/Cluster-Pools/Consultants/mahazan"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "vlan-109" {
  name          = "vlan109-10.122.109.0-24"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "tmpl-centos7min" {
  name          = "CentOS-7-min"
#  template_uuid = "42249d02-cea5-39b5-ed66-9f60a135fd21"
  datacenter_id = data.vsphere_datacenter.dc.id
}

## Resources
#resource "vsphere_folder" "parent" {
#  path          = "Home Folders"
#  type          = "vm"
#  datacenter_id = data.vsphere_datacenter.dc.id
#}

#resource "vsphere_folder" "folder" {
#  path          = "${vsphere_folder.parent.path}/mahazan"
#  type          = "vm"
#  datacenter_id = data.vsphere_datacenter.dc.id
#}

#resource "vsphere_virtual_machine" "tmpl-centos7min" {
#  name          = "CentOS-7-min"
#  template_uuid = "42249d02-cea5-39b5-ed66-9f60a135fd21"
#  datacenter_id = data.vsphere_datacenter.dc.id
#}

resource "vsphere_virtual_machine" "linux-test-tf" {
  name             = "linux-test-tf"
  folder           = "Home Folders/mahazan"
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

#    customize {
#      linux_options {
#        host_name = "terraform-test"
#        domain    = "cisco.com"
#      }

#      network_interface {
#        ipv4_address = "10.0.0.10"
#        ipv4_netmask = 24
#      }

#      ipv4_gateway = "10.0.0.1"
#    }
  }
}
