# vpc endpoints
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.wp_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = aws_route_table.wp-public-rt.id
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
}
