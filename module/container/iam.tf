# role 생성 
data "aws_iam_policy_document" "ecs_task_execution_iam_role_policy" {
    version = "2012-10-17"

    statement{
        sid  = ""
        effect = "Allow"
        actions = ["sts:AssumeRole"] #권한을 빌려씀

        principals {
            type = "Service"
            identifiers= ["ecs-tasks.amazons.com"]
        }
    }
}

resource "aws_iam_role" "ecs_task_execution_iam_role"{
    name= "ecs-task-execution"
    assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_iam_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
    role= aws_iam_role.ecs_task_execution_iam_role.name
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

