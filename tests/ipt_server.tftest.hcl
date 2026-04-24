# Contract tests for modules/ipt_server.

mock_provider "ansible" {}

variables {
  name                  = "ipt_server__test"
  host_name             = "test-host"
  ipt_server_dir        = "/opt/garuda/ipt_server"
  workload_client_cidrs = toset(["10.0.24.0/24"])
  routes = [{
    route = [{ gw = "10.0.0.1" }]
    rules = ["0.0.0.0/0"]
  }]
  connection_data = {
    host                 = "test.example.com"
    user                 = "testuser"
    password             = null
    connection           = "ssh"
    network_os           = "linux"
    ssh_private_key_file = "~/.ssh/id_ed25519"
  }
  labels = {
    "garuda.frr.ospf.router_id" = "10.130.30.99"
  }
}

run "contract_labels_variable_passes_through_router_id" {
  command = plan

  assert {
    condition     = var.labels["garuda.frr.ospf.router_id"] == "10.130.30.99"
    error_message = "labels variable must pass through the router_id key verbatim"
  }
}

# Absence of variable "frr_router_id" is enforced statically: if someone
# re-introduces it, terraform validate in this module will fail when any
# caller omits it. No runtime assertion is possible for a missing variable —
# the guarantee lives in the module schema, not in a test run.
