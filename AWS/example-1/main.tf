output "azname-1" {
  value = "${data.aws_availability_zones.available.names[0]}"
}

output "azname-2" {
  value = "${data.aws_availability_zones.available.names[1]}"
}

output "ami-1" {
  value = "${data.aws_ami.amazon_linux.id}"
}
