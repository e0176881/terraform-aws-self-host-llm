# API gateway, vpc link, lambda auth
resource "aws_apigatewayv2_vpc_link" "llm" {
  name               = local.apigw_config.name
  security_group_ids = [aws_security_group.default_pub_subnet_sg.id, aws_security_group.default_pvt_subnet_sg.id]
  subnet_ids         = concat(module.vpc.private_subnets, module.vpc.public_subnets)

  tags = local.tags
}

resource "aws_apigatewayv2_api" "llm_apigw" {
  name                         = local.apigw_config.name
  protocol_type                = local.apigw_config.protocol_type
  disable_execute_api_endpoint = local.apigw_config.disable_execute_api_endpoint
  tags                         = local.tags
}

resource "aws_apigatewayv2_route" "root_post" {
  api_id    = aws_apigatewayv2_api.llm_apigw.id
  route_key = local.apigw_config.route_post
  target    = "integrations/${aws_apigatewayv2_integration.root_post.id}"
}

resource "aws_apigatewayv2_integration" "root_post" {
  api_id             = aws_apigatewayv2_api.llm_apigw.id
  integration_type   = "HTTP_PROXY"
  integration_method = "POST"
  integration_uri    = module.alb.listeners["http"].arn

  connection_type = "VPC_LINK"
  connection_id   = aws_apigatewayv2_vpc_link.llm.id
}

resource "aws_apigatewayv2_route" "root_get" {
  api_id    = aws_apigatewayv2_api.llm_apigw.id
  route_key = local.apigw_config.route_get
  target    = "integrations/${aws_apigatewayv2_integration.root_get.id}"
}

resource "aws_apigatewayv2_integration" "root_get" {
  api_id             = aws_apigatewayv2_api.llm_apigw.id
  integration_type   = "HTTP_PROXY"
  integration_method = "GET"
  integration_uri    = module.alb.listeners["http"].arn

  connection_type = "VPC_LINK"
  connection_id   = aws_apigatewayv2_vpc_link.llm.id
}

resource "aws_apigatewayv2_stage" "llm_auto_deploy" {
  api_id      = aws_apigatewayv2_api.llm_apigw.id
  name        = local.apigw_config.stage.name
  auto_deploy = local.apigw_config.stage.auto_deploy

  tags = local.tags
}

resource "aws_apigatewayv2_domain_name" "llm" {
  count = local.apigw_config.custom_domain_name["create"] ? 1 : 0

  domain_name = local.apigw_config.custom_domain_name["domain_name"]

  domain_name_configuration {
    certificate_arn = local.apigw_config.custom_domain_name["certificate_arn"]
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "llm" {
  count = local.apigw_config.custom_domain_name["create"] ? 1 : 0

  name    = aws_apigatewayv2_domain_name.llm[0].domain_name
  type    = "A"
  zone_id = local.apigw_config.custom_domain_name["route53_zone_id"]

  alias {
    name                   = aws_apigatewayv2_domain_name.llm[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.llm[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_apigatewayv2_api_mapping" "llm" {
  count = local.apigw_config.custom_domain_name["create"] ? 1 : 0

  api_id      = aws_apigatewayv2_api.llm_apigw.id
  domain_name = aws_apigatewayv2_domain_name.llm[0].id
  stage       = aws_apigatewayv2_stage.llm_auto_deploy.id
}
