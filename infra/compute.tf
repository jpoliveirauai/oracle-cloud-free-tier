data "oci_core_images" "ubuntu_amd" {
  compartment_id           = var.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.E2.1.Micro" # Shape AMD Gratuito
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "aiostreams_server" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  
  shape = "VM.Standard.E2.1.Micro"


  display_name = "aiostreams-instance"

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu_amd.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    
    user_data = base64encode(<<-EOF
              #!/bin/bash
              # Limpa as regras nativas que a Oracle bota no Ubuntu e que travam o SSH/Portas
              iptables -F
              iptables -X
              tfilter-persistent save

              apt-get update -y
              apt-get install -y docker.io docker-compose git
              systemctl start docker
              systemctl enable docker

              mkdir -p /app/aiostreams
              
              docker run -d \
                --name aiostreams \
                --restart always \
                -p 3000:3000 \
                dyrectorio/aiostreams:latest
              EOF
    )
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}