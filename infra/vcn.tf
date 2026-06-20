resource "oci_core_vcn" "aiostreams_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "aiostreams-vcn"
  dns_label      = "aiostreamsvcn"
}

resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_id
  display_name   = "internet-gateway"
  vcn_id         = oci_core_vcn.aiostreams_vcn.id
}

resource "oci_core_route_table" "rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.aiostreams_vcn.id
  display_name   = "route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

resource "oci_core_security_list" "sl" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.aiostreams_vcn.id
  display_name   = "security-list"

  # Outbound: Permitir todo tráfego de saída
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # Inbound: Permitir SSH
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    tcp_options {
        min = 22
        max = 22
    }
  }

  # Inbound: Permitir Porta do AIOStreams (3000)
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    tcp_options {
        min = 3000
        max = 3000
    }
  }
}

resource "oci_core_subnet" "subnet" {
  cidr_block        = "10.0.1.0/24"
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.aiostreams_vcn.id
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.sl.id]
  display_name      = "aiostreams-subnet"
  dns_label         = "aiostreamssub"
}