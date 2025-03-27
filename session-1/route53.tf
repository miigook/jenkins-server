resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.tesraa.zone_id
  name    = "jenkins.<yourdomain>.com"
  type    = "A"
  ttl     = 300
  records = [aws_instance.jenkins_server.public_ip]
}

resource "aws_route53_record" "www_jenkins" {
  zone_id = data.aws_route53_zone.tesraa.zone_id
  name    = "www.jenkins.<yourdomain>.com"
  type    = "A"
  ttl     = 300
  records = [aws_instance.jenkins_server.public_ip]
}

data "aws_route53_zone" "tesraa" {
  name         = "<yourdomain>.com"

}