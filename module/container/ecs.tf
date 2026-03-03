resource "aws_ecs_task_definition" "ecs_task_definition" {
    family = "3-tier-ecs-service"
    network_mode = "awsvpc"
    execution_role_arn = aws_iam_role.ecs_task_execution_iam_role.arn
    cpu = 256
    memory = 512
    requires_compatibilities = ["FARGATE"]
    container_definitions = jsonencode([local.container_definition])


    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-ecs-task-definition"
        }
    )
}

resource "aws_ecs_cluster" "ecs_service"{
    name=  "ecs-cluster"
}

resource "aws_ecs_service" "ecs_service"{
    name = "3-tier-ecs-service"
    cluster = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.ecs_task_definition.arn
    desired_count =3
    launch_type= "FARGATE"


    network_configuration {
        security_groups = aws_security_group.ecs_security_group.*.id
        subnets=  var.subnet_ids
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.alb_target_group.arn
        container_name= local.container_definition.name
        container_port= 80
    }
    depends_on = [aws_lb_listener.alb_listener, aws_iam_role_policy_attachment.ecs_task_execution_role]

    tags = merge(
        var.tags,
        {
            "name" = "${var.environment}-ecs-service"
        }
    )
}
