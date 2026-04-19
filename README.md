# ipt_server

Workload-centric Terraform module for the IPT policy gateway stack on one Linux host.

Why:

- `ipt_server` is the preferred transit/policy gateway for all client payload traffic
- owns FRR in its own namespace for OSPF participation in the backbone routing domain
- DNS interception and geo-routing live here, not distributed across ingress stacks

Inputs:

- `name`
- `host_name`
- `ipt_server_dir`
- `backbone_network_name`
- `backbone_ip`
- `dataplane_subnet`
- `dataplane_ip`
- `dns_service_ip`
- `frr_router_id`
- `frr_ospf_area`
- `advertised_prefixes`
- `remote_next_hops`
- `routes`
- `ws_port`
- `db`
- `clean_conntrack`
- `domain_route_ttl`

Behavior:

- renders the IPT role payload expected by the shared executor
- applies and destroys the workload through `modules/linux_apply`
- FRR runs in the `ipt_server` network namespace via `network_mode: service:garuda_ipt`
- connects to `backbone_network` as `external: true`
