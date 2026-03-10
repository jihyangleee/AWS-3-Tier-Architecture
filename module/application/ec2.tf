# Bastion EC2 (단일 인스턴스)
resource "aws_instance" "bastion" {
    ami                    = data.aws_ami.amazon_linux.id
    instance_type          = local.instance_type
    subnet_id              = var.public_subnet_ids[0]
    vpc_security_group_ids = var.bastion_security_group_ids
    key_name               = local.ec2_key_pair_name

    tags = merge(
        var.tags,
        {
            "Name" = "${var.environment}-bastion"
        }
    )
}

# Application Launch Template
resource "aws_launch_template" "application" {
    name_prefix = "application"
    instance_type= local.instance_type
    image_id = data.aws_ami.amazon_linux.id
    vpc_security_group_ids= var.application_security_group_ids  #application 단의 ec2가 생성되기에 application sg 적용 
    key_name= local.ec2_key_pair_name
    user_data = filebase64("./script/install_apach.sh")
    # user_data 속 .sh 파일은 인스턴스가 생성되면서 실행된다. 

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-application"
        }
    )
}

# - application
resource "aws_autoscaling_group" "autoscaling_group_application"{
    name = "application-group-application"
    vpc_zone_identifier= var.private_subnet_ids
    min_size= 2
    max_size =4
    desired_capacity = 2

    target_group_arns = tolist([aws_lb_target_group.application_loadbalancer_target_group.arn])

    launch_template{
        id  = aws_launch_template.application.id
        version = "$Latest"
    }
}

# attachment - aws autoscalinggroup 에서 생성되는 서버들을
# target group에 속하게끔 연결지어주는 역할 

resource "aws_autoscaling_attachment" "autoscaling_group_application_attachment"{
    autoscaling_group_name= aws_autoscaling_group.autoscaling_group_application.id
    lb_target_group_arn = aws_lb_target_group.application_loadbalancer_target_group.arn

}


data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values =["amzn2-ami-hvm-*-x86_64-gp2"]
    }

    filter{
        name="virtualization-type"
        values=["hvm"]
    }
}