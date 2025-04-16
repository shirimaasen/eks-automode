resource "random_password" "petclinic_db_password" {
  length  = 24
  special = true
}

resource "aws_secretsmanager_secret" "petclinic_db_secret" {
  name        = var.secret_name
  description = "PetClinic database secret"

  lifecycle {
    ignore_changes = [name, description]
  }
}

# Standard secret version (applied unless lifecycle_ignore_changes is true)
resource "aws_secretsmanager_secret_version" "db_secret_value" {
  count         = var.lifecycle_ignore_changes ? 0 : 1
  secret_id     = aws_secretsmanager_secret.petclinic_db_secret.id
  secret_string = jsonencode({
    username = var.secret_username
    password = random_password.petclinic_db_password.result
  })
}

# Optional version with ignore_changes to prevent updates on every apply
resource "aws_secretsmanager_secret_version" "ignore_changes" {
  count         = var.lifecycle_ignore_changes ? 1 : 0
  secret_id     = aws_secretsmanager_secret.petclinic_db_secret.id
  secret_string = jsonencode({
    username = var.secret_username
    password = random_password.petclinic_db_password.result
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}