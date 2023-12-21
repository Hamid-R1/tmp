resource "aws_vpc_peering_connection" "peering_connection" {
  provider = aws.ap-southeast-1

  peer_vpc_id          = aws_vpc.ohio_vpc.id  #ohio_vpc
  vpc_id               = aws_vpc.wp_vpc.id    #songapore_vpc
  auto_accept          = true

  tags = {
    Name = "cross-region-peering"
  }
}

# Create routes for the peering connection in each VPC's route table
resource "aws_route" "route_singapore" {
  #route_table_id = aws_route_table.wp-public-rt.id
  route_table_id         = aws_vpc.wp_vpc.wp-public-rt
  destination_cidr_block = aws_vpc.ohio_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

resource "aws_route" "route_ohio" {
  provider                = aws.us-east-2
  route_table_id         = aws_vpc.ohio_vpc.ohio-public-rt   #main_route_table_id
  destination_cidr_block = aws_vpc.wp_vpc.cidr_block        #.vpc_singapore
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}
