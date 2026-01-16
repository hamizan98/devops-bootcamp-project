resource "aws_ecr_repository" "final_project_repo" {
  name                 = "devops-bootcamp/final-project-hamizanaimanbinhamid"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "final-project-repo"
    Environment = "bootcamp"
  }
}

# Output untuk mendapatkan URL repository setelah apply
output "ecr_repo_url" {
  value = aws_ecr_repository.final_project_repo.repository_url
}