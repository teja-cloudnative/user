module "ec2" {
  source              = "git::https://github.com/teja-cloudnative/terraform-mutable-ec2"
  SPOT_INSTANCE_COUNT = var.SPOT_INSTANCE_COUNT
  OD_INSTANCE_COUNT   = var.OD_INSTANCE_COUNT
  SPOT_INSTANCE_TYPE  = var.SPOT_INSTANCE_TYPE
  OD_INSTANCE_TYPE    = var.OD_INSTANCE_TYPE
  ENV                 = var.ENV
  COMPONENT           = var.COMPONENT
  ALB_ATTACH_TO       = "backend"
  PORT                = var.PORT
  TRIGGER             = var.TRIGGER
}

module "tags" {
  depends_on = [module.ec2]
  count       = length(local.ALL_TAGS)
  source      = "git::https://github.com/teja-cloudnative/terraform-tags"
  TAG_NAME    = lookup(element(local.ALL_TAGS, count.index), "name")
  TAG_VALUE   = lookup(element(local.ALL_TAGS, count.index), "value")
  ENV         = var.ENV
  RESOURCE_ID_COUNT = local.RESOURCE_ID_COUNT
  ALL_TAG_IDS = module.ec2.ALL_TAG_IDS
}

locals {
  ALL_TAGS = [
    {
      name  = "Name"
      value = "${var.COMPONENT}-${var.ENV}"
    },
    {
      name  = "env"
      value = var.ENV
    },
    {
      name  = "component"
      value = var.COMPONENT
    },
    {
      name  = "project_name"
      value = "roboshop"
    }
  ]
  RESOURCE_ID_COUNT = (var.OD_INSTANCE_COUNT * 2) + (var.SPOT_INSTANCE_COUNT * 3)
}