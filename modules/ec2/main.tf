data "aws_key_pair" this {
  key_name = var.key_name
  include_public_key = true
}

# resource "aws_iam_instance_profile" "this" {
#   name = "${var.name}-ec2-inst-profile"
#   role = aws_iam_role.this.name
# }
 
# resource "aws_iam_role" "this" {
#   name               = "${var.name}-ec2-role"
#   assume_role_policy = <<EOF
#     {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#         "Effect": "Allow",
#         "Principal": {
#             "Service": "ec2.amazonaws.com"
#         },
#         "Action": "sts:AssumeRole",
#         "Condition": {}
#         }
#     ]
#     }
# EOF    
# }

# resource "aws_iam_role_policy_attachment" "ec2-role-ssm-instance-core" {
#   role       = aws_iam_role.this.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

resource "aws_network_interface" "mgmt" {
  count = var.enable_mgmt_eni ? 1 : 0
  subnet_id = var.mgmt_subnet_id
  security_groups = var.security_group_mgmt_ids
  source_dest_check = var.source_dest_check
  tags = merge({Name = "${var.name}-MGMT"}, var.common_tags)
}

resource "aws_network_interface" "inside" {
  count = var.enable_inside_eni ? 1 : 0
  subnet_id = var.inside_subnet_id
  security_groups = var.security_group_inside_ids
  source_dest_check = var.source_dest_check
  tags = merge({Name = "${var.name}-INSIDE"}, var.common_tags)
}

resource "aws_network_interface" "outside" {
  count = var.enable_outside_eni ? 1 : 0
  subnet_id = var.outside_subnet_id
  security_groups = var.security_group_outside_ids
  source_dest_check = var.source_dest_check
  tags = merge({Name = "${var.name}-OUTSIDE"}, var.common_tags)
}

resource "aws_instance" "this" {
  ami = var.ami_id
  instance_type = var.instance_type
  security_groups = var.multi_eni ? null :  var.security_group_ids
  subnet_id = var.multi_eni ? null :  var.subnet_id
  #iam_instance_profile = aws_iam_instance_profile.this.name
  user_data = var.user_data
  key_name = data.aws_key_pair.this.key_name
  tags = merge({Name = "${var.name}"}, var.common_tags)

  # primary_network_interface {
  #   network_interface_id = var.enable_mgmt_eni ? aws_network_interface.mgmt[0].id : 0
  # }
  dynamic "network_interface" {
    for_each = var.multi_eni ? [
      {
        device_index          = 0
        network_interface_id  = aws_network_interface.mgmt[0].id
        #delete_on_termination = var.eni_delete_on_termination
      },
      {
        device_index          = 1
        network_interface_id  = aws_network_interface.inside[0].id
        #delete_on_termination = var.eni_delete_on_termination
      },
      {
        device_index          = 2
        network_interface_id  = aws_network_interface.outside[0].id
        #delete_on_termination = var.eni_delete_on_termination
      }
    ] : []

    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = network_interface.value.network_interface_id
      #delete_on_termination = network_interface.value.delete_on_termination
    }
  }

  lifecycle {
  ignore_changes = all
}
}

# resource "aws_network_interface_attachment" "inside" {
#   count = var.enable_inside_eni ? 1: 0
#   instance_id          = aws_instance.this.id
#   network_interface_id = aws_network_interface.inside[count.index].id
#   device_index         = 1
# }

# resource "aws_network_interface_attachment" "outside" {
#   count = var.enable_outside_eni ? 1 : 0
#   instance_id          = aws_instance.this.id
#   network_interface_id = aws_network_interface.outside[count.index].id
#   device_index         = 2
# }

resource "aws_eip" "mgmt" {
  count = var.enable_mgmt_eni ? 1 : 0
  depends_on = [ aws_instance.this ]
  domain = "vpc"
  network_interface = aws_network_interface.mgmt[count.index].id
  tags = merge({Name = "${var.name}-EIP-MGMT"}, var.common_tags)
}

resource "aws_eip" "outside" {
  count = var.enable_outside_eni ? 1 : 0
  depends_on = [ aws_instance.this ]
  domain = "vpc"
  network_interface = aws_network_interface.outside[count.index].id
  tags = merge({Name = "${var.name}-EIP-OUTSIDE"}, var.common_tags)
}