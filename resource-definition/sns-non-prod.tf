resource "humanitec_resource_definition" "sns_non_prod" {
  driver_type = "humanitec/terraform"
  id          = "${local.app}-sns-non-prod"
  name        = "${local.app}-sns-non-prod"
  type        = "sns-topic"

  provision = {
    "aws-policy#${local.app}-sns-policy" = {
      "is_dependent" : true,
      "match_dependents" : true
    }
  }

  driver_inputs = {
    secrets = {
      variables = jsonencode({
        access_key      = var.access_key
        secret_key      = var.secret_key
        assume_role_arn = var.assume_role_arn
        region          = var.region
      })
    },
    values = {
      "source" = jsonencode(
        {
          path = "terraform/sns/non-prod"
          rev  = "refs/heads/main"
          url  = "https://github.com/nickhumanitec/examples.git"
        }
      )
      "variables" = jsonencode(
        {
          name = "$${context.app.id}-$${context.env.id}"
          app  = "$${context.app.id}"
          env  = "$${context.env.id}"
          res  = "$${context.res.id}"
        }
      )
    }
  }
  lifecycle {
    ignore_changes = [
      criteria
    ]
  }

}

resource "humanitec_resource_definition_criteria" "sns_non_prod" {
  resource_definition_id = humanitec_resource_definition.sns_non_prod.id
  app_id                 = humanitec_application.app.id
  env_id                 = "development"
}