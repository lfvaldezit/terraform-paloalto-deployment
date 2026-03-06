# Palo Alto VM Deployment with Terraform

## 🏗️ Architecture

<img width="800" height="500" alt="image" src="https://raw.githubusercontent.com/lfvaldezit/terraform-paloalto-deployment/main/image.png" /> 

## 📝 tfvars file

```bash
#----------------------------
# VPC Variables
#----------------------------

name       = "SEC-PAFW"
cidr_block = "10.192.0.0/24"

outside_subnets = [{ name = "SEC-PAFW-OUTSIDE-FW1", cidr_block = "10.192.0.0/27", az = "us-east-1a" },
{ name = "SEC-PAFW-OUTSIDE-FW2", cidr_block = "10.192.0.32/27", az = "us-east-1b" }]

inside_subnets = [{ name = "SEC-PAFW-INSIDE-FW1", cidr_block = "10.192.0.64/28", az = "us-east-1a" },
{ name = "SEC-PAFW-INSIDE-FW2", cidr_block = "10.192.0.80/28", az = "us-east-1b" }]

management_subnets = [{ name = "SEC-PAFW-MGMT-FW1", cidr_block = "10.192.0.96/28", az = "us-east-1a" },
{ name = "SEC-PAFW-MGMT-FW2", cidr_block = "10.192.0.112/28", az = "us-east-1b" }]

spare_subnets = [{ name = "SEC-PAFW-SPARE-FW1", cidr_block = "10.192.0.128/26", az = "us-east-1a" },
{ name = "SEC-PAFW-SPARE-FW2", cidr_block = "10.192.0.192/26", az = "us-east-1b" }]

#----------------------------
# SG Variables
#----------------------------

security_groups_outside = {
  "SEC-PAFW-OUTSIDE-SG" = {
    "description" : "Security Group for the Outside ENI of the FW1",
    "inbound" : [
      { "protocol" : "tcp", "ports" : 443, "source" : "0.0.0.0/0", "description" : "" },
      { "protocol" : "tcp", "ports" : 80, "source" : "0.0.0.0/0", "description" : "" },
    ],
    "outbound" : [
      { "protocol" : "-1", "ports" : 0, "destination" : "0.0.0.0/0", "description" : "" },
    ],
  }
}

security_groups_inside = {
  "SEC-PAFW-INSIDE-SG" = {
    "description" : "Security Group for the Inside ENI of the FW1",
    "inbound" : [
      { "protocol" : "-1", "ports" : 0, "source" : "0.0.0.0/0", "description" : "" },
    ],
    "outbound" : [
      { "protocol" : "-1", "ports" : 0, "destination" : "0.0.0.0/0", "description" : "" },
    ],
  }
}

security_groups_mgmt = {
  "SEC-PAFW-MGMT-SG" = {
    "description" : "Security Group for the Mgmt ENI of the FW1",
    "inbound" : [
      { "protocol" : "tcp", "ports" : 443, "source" : "0.0.0.0/0", "description" : "" },
      { "protocol" : "tcp", "ports" : 22, "source" : "0.0.0.0/0", "description" : "" },
    ],
    "outbound" : [
      { "protocol" : "-1", "ports" : 0, "destination" : "0.0.0.0/0", "description" : "" },
    ],
  }
}

security_groups_web = {
  "SEC-WEB-SG" = {
    "description" : "Security Group for the Web Server ENI",
    "inbound" : [
      { "protocol" : "tcp", "ports" : 443, "source" : "0.0.0.0/0", "description" : "" },
      { "protocol" : "tcp", "ports" : 22, "source" : "0.0.0.0/0", "description" : "" },
    ],
    "outbound" : [
      { "protocol" : "-1", "ports" : 0, "destination" : "0.0.0.0/0", "description" : "" },
    ],
  }
}

#----------------------------
# EC2 Variables
#----------------------------

ami_id             = "ami-08982f1c5bf93d976"
instance_type      = "t3.small"
source_dest_check  = true

fw1_ami_id             = "ami-077005c797a9a09e9"
fw1_instance_type      = "m4.xlarge"
fw1_source_dest_check  = false
fw1_enable_mgmt_eni    = true
fw1_enable_inside_eni  = true
fw1_enable_outside_eni = true
```

## 🔥 Palo Alto VM Configuration

```bash

# Enter Configuration mode

configure

# Configure admin password

set mgt-config users admin password

# Configure Interfaces

set network interface ethernet ethernet1/1 layer3 dhcp-client
set network interface ethernet ethernet1/1 link-state up
set network interface ethernet ethernet1/1 layer3

set network interface ethernet ethernet1/2 layer3 dhcp-client
set network interface ethernet ethernet1/2 link-state up
set network interface ethernet ethernet1/2 layer3
 
# Configure zones and assign interfaces to each zone

set zone INSIDE network layer3 ethernet1/1
set zone OUTSIDE network layer3 ethernet1/2

# Use Default Virtual Router

set network virtual-router default interface [ ethernet1/1 ethernet1/2 ]

# Add Static Routes

set network virtual-router default routing-table ip static-route Default-Route interface ethernet1/2 destination 0.0.0.0/0 nexthop ip-address 10.192.0.1

set network virtual-router default routing-table ip static-route VPC-Internal interface ethernet1/1 destination 10.192.0.0/24 nexthop ip-address 10.192.0.65

# Configure Security Policy

set rulebase security rules Allow-VPC-To-Internet from INSIDE
set rulebase security rules Allow-VPC-To-Internet to OUTSIDE
set rulebase security rules Allow-VPC-To-Internet source any
set rulebase security rules Allow-VPC-To-Internet destination any
set rulebase security rules Allow-VPC-To-Internet application any
set rulebase security rules Allow-VPC-To-Internet service application-default
set rulebase security rules Allow-VPC-To-Internet action allow
set rulebase security rules Allow-VPC-To-Internet log-end yes

# Configure Source NAT Policy

set rulebase nat rules SNAT-VPC-To-Internet description "Source NAT inside to outside using outside interface IP"
set rulebase nat rules SNAT-VPC-To-Internet from INSIDE
set rulebase nat rules SNAT-VPC-To-Internet to OUTSIDE
set rulebase nat rules SNAT-VPC-To-Internet source any
set rulebase nat rules SNAT-VPC-To-Internet destination any
set rulebase nat rules SNAT-VPC-To-Internet service any
set rulebase nat rules SNAT-VPC-To-Internet to-interface ethernet1/2
set rulebase nat rules SNAT-VPC-To-Internet source-translation dynamic-ip-and-port interface-address interface ethernet1/2

commit
```