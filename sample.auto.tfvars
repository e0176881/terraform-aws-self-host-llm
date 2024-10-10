region                    = "ap-southeast-1"
azs                       = ["ap-southeast-1a", "ap-southeast-1b"]
vpc_private_subnets_cidrs = ["172.31.48.0/20", "172.31.64.0/20"]
vpc_private_subnets_names = ["private-48-1a", "private-64-1b"]
vpc_public_subnets_cidrs  = ["172.31.0.0/20", "172.31.16.0/20"]
vpc_public_subnets_names  = ["public-0-1a", "public-16-1b"]
requests = [
    {
      "zone_id": "Z00452101CERWZ9WHQTQG",
      "sub_domain": "hackathon.orson.store"
      "acm": "arn:aws:acm:ap-southeast-1:147997135442:certificate/9879e898-6cdf-445e-bd65-ab9e17385046"
    },
    {
      "zone_id": "Z0559120KGLV50M1FRYV",
      "sub_domain": "hackathon2.orson.store"
      "acm": "arn:aws:acm:ap-southeast-1:147997135442:certificate/1f34486f-a49c-466e-8688-7141af691132"
    }
]


llm_ec2_configs = [
  {
    llm_model     = "gemma2:9b"
    instance_type = "g5g.4xlarge"
    ami_id        = ""
    ebs_volume_gb = 200
    app_port      = 11434
  },

]

create_api_gw                   = true
api_gw_disable_execute_endpoint = true
api_gw_domain                   = "llm.orson.store"
api_gw_domain_route53_zone      = "Z091946522PAMK167PRLV"
api_gw_domain_ssl_cert_arn      = "arn:aws:acm:ap-southeast-1:147997135442:certificate/f5468d22-f7a3-4bff-86b5-3241790682dd"

open_webui_task_cpu   = 2048
open_webui_task_mem   = 4096
open_webui_task_count = 2
open_webui_port       = 8080
open_webui_image_url  = "orsonoh93/open-webui:v0.3.16"
# open_webui_domain_route53_zone = "Z00452101CERWZ9WHQTQG"
# open_webui_domain_ssl_cert_arn = "arn:aws:acm:ap-southeast-1:147997135442:certificate/9879e898-6cdf-445e-bd65-ab9e17385046"
