data "aws_route53_zone" "selected" {
  name         = "utkusarioglu.com"
  private_zone = false
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.10.2"

  zone_name = data.aws_route53_zone.selected.name

  records = [
    {
      name = "${var.vault_subdomain}.nextjs-grpc"
      type = "A"
      alias = {
        name    = data.aws_elb.vault_lb.dns_name
        zone_id = data.aws_elb.vault_lb.zone_id
        # name    = var.vault_alb_url
        # zone_id = "what's this..."
        # zone_id = data.vault_alb.
        # zone_id = var.route53_zone_id
        # name    = "d-10qxlbvagl.execute-api.eu-west-1.amazonaws.com"
        # zone_id = "Z04539252QOO67LX08V98"
      }
    },
  ]
}
