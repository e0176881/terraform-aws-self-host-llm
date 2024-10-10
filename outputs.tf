output "llm_service_endpoint" {
  value = module.llm_service.service_endpoint
}

output "open_webui_endpoint" {
  value = {
    for key, value in module.open_webui_service : key => value.service_endpoint
  }
}
