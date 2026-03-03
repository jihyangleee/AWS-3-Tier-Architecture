locals{
    #ecr
    ecr_lifecycle_policy = {
        roules= [
            {
                rulePriority = 1
                description= "keep last 10 images"
                action  = {
                    type= "expire"
                }
                selection = {
                    tagStatus = "any" 
                    countType=  "imageCountMoreThan"
                }
            }
        ]
    }

    #ecs
    container_definition = {
        name= "3-tier-ecs-container" 
        image= aws_ecr_repository.ecr.repository_url
        cpu = 2
        memory =256
        essential = true
        portMappings = [
            {
                cotaninerPort=  8080
                hostport = 80
            }
        ]
    }

    entire_cidr_block ="0.0.0.0/0"
}

