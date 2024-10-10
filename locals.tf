locals {
  # tags
  tags = {
    "system" = "llm"
  }
  requests_to_map = { for index, request in var.requests : request.zone_id => request }
}
