locals {
  _frr_lib = "${path.module}/../../frr-sidecar/charts/frr-sidecar/templates"
  runtime_patch_checksum = sha256(join("", [
    filesha256("${path.module}/charts/ipt-server/templates/deployment.yaml"),
    filesha256("${path.module}/charts/ipt-server/templates/runtime-patches.yaml"),
    filesha256("${path.module}/charts/ipt-server/files/sitecustomize.py"),
    # frr-sidecar library chart templates — track changes so helm_release
    # upgrades when library templates change (#51)
    filesha256("${local._frr_lib}/_container.tpl"),
    filesha256("${local._frr_lib}/_frrconf.tpl"),
    filesha256("${local._frr_lib}/_initContainer.tpl"),
    filesha256("${local._frr_lib}/_volume.tpl"),
  ]))
}

resource "helm_release" "ipt_server" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = false
  chart            = "${path.module}/charts/ipt-server"
  dependency_update = true

  values = [
    yamlencode({
      namespace = var.namespace
      name      = var.name
      images = {
        iptServer = var.ipt_server_image
        powerdns  = var.powerdns_image
        frr       = var.frr_image
      }
      routes         = var.routes
      pbrInterfaces  = var.pbr_interfaces
      nicAttach      = var.nic_attach
      cleanConntrack = var.clean_conntrack
      domainRouteTtl = var.domain_route_ttl
      pinningEgress  = var.pinning_egress
      pinningTtl     = var.pinning_ttl
      pinningApiPort = var.pinning_api_port
      runtimePatchChecksum = local.runtime_patch_checksum
      labels         = var.labels
      ospf           = var.ospf
    })
  ]
}
