# Palo Alto VM Deployment with Terraform

## 🏗️ Architecture

<img width="800" height="500" alt="image" src="https://raw.githubusercontent.com/lfvaldezit/terraform-paloalto-deployment/main/image.png" /> 

## 📝 tfvars file

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