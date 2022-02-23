## IST/TFCB API
variable "api_key" {
  type = string
  description = "IST api key" 
}

variable "api_key_file" {
  type = string
  description = "IST api key file" 
}

variable "api_endpoint" {
  type = string
  description = "IST endpoint" 
}

variable "organization" {
  type = string
  description = "TFCB organization name" 
}

## vSphere
variable "vsphere_user" {
  type = string
  description = "the username for vsphere"
}

variable "vsphere_password" {
  type = string
  description = "the password to access vsphere"
}

variable "vsphere_server" {
  type = string
  description = "hostname or ip address of your vcenter server" 
}

variable "vsphere_datacenter" {
  type = string
  description = "the name of the datacenter"
}

variable "vsphere_cluster" {
  type = string
  description = "the name of the cluster"
}

variable "vsphere_datastore" {
  type = string
  description = "the name of the datastore"
}

variable "vsphere_vm_template" {
  type = string
  description = "the name of the vm template"
}

variable "vsphere_vm_name" {
  type = string
  description = "the name of the vm"
}

variable "vsphere_folder_name" {
  type=string
}

variable "vsphere_resource_pool" {
  type = string
  description = "the name of the resourcepool for examples: Cluster1/Resources " 
}

variable "vsphere_network-1" {
  type = string
  description = "the name of the vsphere port-group/vlan " 
}