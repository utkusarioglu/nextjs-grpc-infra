resource "aws_eip" "nat_gw_elastic_ip" {
  tags = {
    Name = "${var.cluster_name}-nat-eip"
  }
}
