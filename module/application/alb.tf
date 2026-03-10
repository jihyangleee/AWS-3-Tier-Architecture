resource "aws_lb" "application_loadbalancer"{

    name = "application-loadbalancer"
    security_groups = var.lb_security_group_ids 
    subnets = var.public_subnet_ids
    idle_timeout = 400

    depends_on = [
        aws_autoscaling_group.autoscaling_group_application
    ]
    tags = merge(
        var.tags,
        {
        "name" = "${var.environment}-lb"
        }
    )
}

# 로드 밸런서가 보내는 target 목적지 
resource "aws_lb_target_group" "application_loadbalancer_target_group" {
    name ="application-loadbalancer-tg"
    port = 80 #서버가 대기하는 포트
    protocol = "HTTP"
    vpc_id = var.vpc_id

    lifecycle {
        create_before_destroy = true #삭제하기 전 새로운 것을 먼저 만든다 
        # 먼저 삭제하게 되면 중간에 공백이 발생하여 서비스가 끊길 수 있다. 
    }

    tags = merge (
        var.tags,
        {
            "name" = "${var.environment}-lb-target-group"
        }
    )
}

resource "aws_lb_listener" "application_loadbalancer_listener" {
    load_balancer_arn = aws_lb.application_loadbalancer.arn 
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.application_loadbalancer_target_group.arn
    }

    tags= merge(
        var.tags,
        {
            "name" = "${var.environment}-lb-listener"
        }
    )
}

