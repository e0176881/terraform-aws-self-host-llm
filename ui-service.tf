module "open_webui_service" {
  for_each = local.requests_to_map
  source = "./modules/open-webui-service"

  region = var.region
  azs    = var.azs

  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  ecs_subnet_ids = module.vpc.private_subnets
  alb_subnet_ids = module.vpc.public_subnets

  llm_service_endpoint = module.llm_service.service_endpoint

  open_webui_task_cpu            = var.open_webui_task_cpu
  open_webui_task_mem            = var.open_webui_task_mem
  open_webui_task_count          = var.open_webui_task_count
  open_webui_port                = var.open_webui_port
  open_webui_image_url           = var.open_webui_image_url
  open_webui_domain              = each.value.sub_domain
  open_webui_domain_route53_zone = each.value.zone_id
  open_webui_domain_ssl_cert_arn = each.value.acm
}
