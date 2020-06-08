# Build Kubernetes based on the Oracle Linux Container Services for use with Kubernetes.
# Oracle Container Services for use with Kubernetes version 1.1.9 is based on Kubernetes version 1.9.1, as released upstream.
# Developer branch is is based on Kubernetes version v1.11.3, as released upstream.

### Environment ###
  provider "opc" {
    user                = "${var.ociUser}"
    password            = "${var.ociPass}"
    identity_domain     = "${var.idDomain}"
    endpoint            = "${var.apiEndpoint}"
  }
  resource "opc_compute_ssh_key" "ocsk-public-key1" {
    name                = "ocsk-public-key1"
    key                 = "${file(var.ssh_public_key)}"
    enabled             = true
  }

### Network ###
  ### Network :: IP Network ###
    # N/A
  ### Network :: Shared Network ###
    ### Network :: Shared Network :: IP Reservation ###
    resource "opc_compute_ip_reservation" "reservation-mst1" {
      parent_pool         = "/oracle/public/ippool"
      name                = "mst1-external"
      permanent           = true
    }
    ### Network :: Shared Network :: Security Applications ###
    resource "opc_compute_security_application" "http-8080" {
      name     = "http-8080"
      protocol = "tcp"
      dport    = "8080"
    }
    ### Network :: Shared Network :: Security Lists ###
    # A security list is a group of Oracle Compute Cloud Service instances that you can specify as the source or destination in one or more security rules. The instances in a
    # security list can communicate fully, on all ports, with other instances in the same security list using their private IP addresses.
    ###
    resource "opc_compute_security_list" "mst-sec-list1" {
      name                 = "mst-sec-list1"
      policy               = "deny"
      outbound_cidr_policy = "permit"
    }
    ### Network :: Shared Network :: Security Rules ###
    # Security rules are essentially firewall rules, which you can use to permit traffic
    # between Oracle Compute Cloud Service instances in different security lists, as well as between instances and external hosts.
    ###
    resource "opc_compute_sec_rule" "mst-sec-rule1" {
      depends_on       = ["opc_compute_security_list.mst-sec-list1"]
      name             = "mst-sec-rule1"
      source_list      = "seciplist:${opc_compute_security_ip_list.sec-ip-list1.name}"
      destination_list = "seclist:${opc_compute_security_list.mst-sec-list1.name}"
      action           = "permit"
      application      = "/oracle/public/ssh"
    }
    resource "opc_compute_sec_rule" "mst-sec-rule2" {
      depends_on       = ["opc_compute_security_list.mst-sec-list1"]
      name             = "mst-sec-rule2"
      source_list      = "seciplist:${opc_compute_security_ip_list.sec-ip-list1.name}"
      destination_list = "seclist:${opc_compute_security_list.mst-sec-list1.name}"
      action           = "permit"
      application      = "/oracle/public/http"
    }
    resource "opc_compute_sec_rule" "mst-sec-rule3" {
      depends_on       = ["opc_compute_security_list.mst-sec-list1"]
      name             = "mst-sec-rule3"
      source_list      = "seciplist:${opc_compute_security_ip_list.sec-ip-list1.name}"
      destination_list = "seclist:${opc_compute_security_list.mst-sec-list1.name}"
      action           = "permit"
      application      = "/oracle/public/https"
    }
    resource "opc_compute_sec_rule" "mst-sec-rule4" {
      depends_on       = ["opc_compute_security_list.mst-sec-list1", "opc_compute_security_application.http-8080"]
      name             = "mst-sec-rule4"
      source_list      = "seciplist:${opc_compute_security_ip_list.sec-ip-list1.name}"
      destination_list = "seclist:${opc_compute_security_list.mst-sec-list1.name}"
      action           = "permit"
      application      = "http-8080"
    }
    ### Network :: Shared Network :: Security IP Lists ###
    # A security IP list is a list of IP subnets (in the CIDR format) or IP addresses that are external to instances in OCI Classic.
    # You can use a security IP list as the source or the destination in security rules to control network access to or from Classic instances.
    ###
    resource "opc_compute_security_ip_list" "sec-ip-list1" {
      name        = "sec-ip-list1-inet"
      ip_entries = [ "0.0.0.0/0" ]
    }
    resource "opc_compute_security_ip_list" "sec-ip-list2" {
      name        = "sec-ip-list2-docker"
      ip_entries = [ "172.17.0.0/16" ]
    }

### Storage ###
  ### Storage :: Master ###
  resource "opc_compute_storage_volume" "mst-volume1" {
    size                = "40"
    description         = "mst-volume1: bootable storage volume"
    name                = "mst-volume1-boot"
    storage_type        = "/oracle/public/storage/latency"
    bootable            = true
    image_list          = "/oracle/public/OL_7.2_UEKR4_x86_64"
    image_list_entry    = 1
  }

### Compute ###
  ### Compute :: Master ###
  resource "opc_compute_instance" "mst-instance1" {
    name                = "mst-instance1"
    label               = "mst-instance1"
    shape               = "oc3"
    hostname            = "mst-instance1"
    reverse_dns         = true
    storage {
      index             = 1
      volume            = "${opc_compute_storage_volume.mst-volume1.name}"
    }
    networking_info {
      index             = 0
      shared_network    = true
      sec_lists         = ["${opc_compute_security_list.mst-sec-list1.name}"]
      nat               = ["${opc_compute_ip_reservation.reservation-mst1.name}"]
      dns               = ["mst-instance1"]
    }
    ssh_keys            = ["${opc_compute_ssh_key.ocsk-public-key1.name}"]
    boot_order          = [ 1 ]
  }

### Null-Resources ###
  ### Null-Resources :: Master ###
  resource "null_resource" "mst-instance1" {
      depends_on = ["opc_compute_instance.mst-instance1"]
      provisioner "file" {
        connection {
          timeout = "30m"
          type = "ssh"
          host = "${opc_compute_ip_reservation.reservation-mst1.ip}"
          user = "opc"
          private_key = "${file(var.ssh_private_key)}"
        }
      source      = "script/"
      destination = "/tmp/"
      }
      provisioner "remote-exec" {
        connection {
          timeout = "30m"
          type = "ssh"
          host = "${opc_compute_ip_reservation.reservation-mst1.ip}"
          user = "opc"
          private_key = "${file(var.ssh_private_key)}"
        }
        inline = [
          "chmod +x /tmp/mgt-script.sh",
          "chmod +x /tmp/mgt/kubernetes-env.sh",
          "sudo /tmp/mgt-script.sh ${var.verDeveloper} ${var.containerRepoUser} ${var.containerRepoPass} ${var.envDashMonMet} ${var.envMicroSvc} ${var.envIngress} ${var.envSvcMesh}",
        ]
      }
  }

### Output ###
  output "Master_Node_Public_IPs" {
    value = ["${opc_compute_ip_reservation.reservation-mst1.ip}"]
  }
