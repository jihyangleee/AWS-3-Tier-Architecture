#launch template
#bastion
resource "aws_launch_template" "bastion" {
    name_prefix = "bastion"
    instance_type= local.instance_type
    image_id= data.aws_ami.amazon_linux.id
    vpc_security_group_ids = var.bastion_security_group_ids
    key_name= local.ec2_key_pair_name

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-bastion"
        }
    )
}

#application
resource "aws_launch_template" "application" {
    name_prefix = "application"
    instance_type= local.instance_type
    image_id = data.aws_ami.amazon_linux.id
    vpc_security_group_ids= var.application_security_group_ids
    key_name= local.ec2_key_pair_name
    user_data = filebase64("./script/install_apache.sh")

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-application"
        }
    )
}


#auto scaling group

