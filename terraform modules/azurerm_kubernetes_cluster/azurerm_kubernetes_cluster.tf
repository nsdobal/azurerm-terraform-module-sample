resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dynamic "default_node_pool" {
    for_each = var.default_node_pool == null ? [] : [var.default_node_pool]
    content {
      name                          = coalesce(default_node_pool.value.name, "${name}-default_node_pool")
      vm_size                       = default_node_pool.value.vm_size
      capacity_reservation_group_id = default_node_pool.value.capacity_reservation_group_id
      auto_scaling_enabled          = coalesce(default_node_pool.value.auto_scaling_enabled, true)
      host_encryption_enabled       = coalesce(default_node_pool.value.host_encryption_enabed, false)
      node_public_ip_enabled        = coalesce(default_node_pool.value.node_public_ip_enabled, false)
      gpu_driver                    = coalesce(default_node_pool.value.gpu_driver, "None")
      gpu_instance                  = default_node_pool.value.gpu_instance
      host_group_id                 = default_node_pool.value.host_group_id
      dynamic "kubelet_config" {
        for_each = default_node_pool.value.kubelet_config == null ? [] : [default_node_pool.value.kubelet_config]
        content {
          allowed_unsafe_sysctls    = coalesce(kubelet_config.value.allowed_unsafe_sysctls, [])
          container_log_max_files   = kubelet_config.value.container_log_max_files
          container_log_max_size_mb = coalesce(kubelet_config.value.container_log_max_size_mb, 10)
          cpu_cfs_quota_enabled     = coalesce(kubelet_config.value.cpu_cfs_quota_enabled, true)
          cpu_manager_policy        = kubelet_config.value.cpu_manager_policy
          image_gc_high_threshold   = kubelet_config.value.image_gc_high_threshold
          image_gc_low_threshold    = kubelet_config.value.image_gc_low_threshold
          pod_max_pid               = kubelet_config.value.pod_max_pid
          topology_manager_policy   = kubelet_config.value.topology_manager_policy
        }
      }
      dynamic "linux_os_config" {
        for_each = default_node_pool.value.linux_os_config == null ? [] : [default_node_pool.value.linux_os_config]
        content {
          swap_file_size_mb = linux_os_config.value.swap_file_size_mb
          dynamic "sysctl_config" {
            for_each = linux_os_config.value.sysctl_config == null ? [] : [linux_os_config.value.sysctl_config]
            content {
              fs_aio_max_nr                      = sysctl_config.value.fs_aio_max_nr
              fs_file_max                        = sysctl_config.value.fs_file_max
              fs_inotify_max_user_watches        = sysctl_config.value.fs_inotify_max_user_watches
              fs_nr_open                         = sysctl_config.value.fs_nr_open
              kernel_threads_max                 = sysctl_config.value.kernel_threads_max
              net_core_netdev_max_backlog        = sysctl_config.value.net_core_netdev_max_backlog
              net_core_optmem_max                = sysctl_config.value.net_core_optmem_max
              net_core_rmem_default              = sysctl_config.value.net_core_rmem_default
              net_core_rmem_max                  = sysctl_config.value.net_core_rmem_max
              net_core_somaxconn                 = sysctl_config.value.net_core_somaxconn
              net_core_wmem_default              = sysctl_config.value.net_core_wmem_default
              net_core_wmem_max                  = sysctl_config.value.net_core_wmem_max
              net_ipv4_ip_local_port_range_max   = sysctl_config.value.net_ipv4_ip_local_port_range_max
              net_ipv4_ip_local_port_range_min   = sysctl_config.value.net_ipv4_ip_local_port_range_min
              net_ipv4_neigh_default_gc_thresh1  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh1
              net_ipv4_neigh_default_gc_thresh2  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh2
              net_ipv4_neigh_default_gc_thresh3  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh3
              net_ipv4_tcp_fin_timeout           = sysctl_config.value.net_ipv4_tcp_fin_timeout
              net_ipv4_tcp_keepalive_intvl       = sysctl_config.value.net_ipv4_tcp_keepalive_intvl
              net_ipv4_tcp_keepalive_probes      = sysctl_config.value.net_ipv4_tcp_keepalive_probes
              net_ipv4_tcp_keepalive_time        = sysctl_config.value.net_ipv4_tcp_keepalive_time
              net_ipv4_tcp_max_syn_backlog       = sysctl_config.value.net_ipv4_tcp_max_syn_backlog
              net_ipv4_tcp_max_tw_buckets        = sysctl_config.value.net_ipv4_tcp_max_tw_buckets
              net_ipv4_tcp_tw_reuse              = sysctl.value.net_ipv4_tcp_tw_reuse
              net_netfilter_nf_conntrack_buckets = sysctl_config.value.net_netfilter_nf_conntrack_buckets
              net_netfilter_nf_conntrack_max     = sysctl_config.value.net_netfilter_nf_conntrack_max
              vm_max_map_count                   = sysctl_config.value.vm_max_map_count
              vm_swappiness                      = sysctl_config.value.vm_swappiness
              vm_vfs_cache_pressure              = sysctl_config.value.vm_vfs_cache_pressure
            }
          }
          transparent_huge_page_defrag = linux_os_config.value.transparent_huge_page_defrag
          transparent_huge_page        = linux_os_config.value.transparent_huge_page
        }
      }
      fips_enabled      = default_node_pool.value.fips_enabled
      kubelet_disk_type = default_node_pool.value.kubelet_disk_type
      max_pods          = default_node_pool.value.max_pods
      dynamic "node_network_profile" {
        for_each = default_node_pool.value.node_network_profile == null ? [] : [default_node_pool.value.node_network_profile]
        content {
          dynamic "allowed_host_ports" {
            for_each = node_network_profile.value.allowed_host_ports == null ? [] : [node_network_profile.value.allowed_host_ports]
            content {
              port_start = allowed_host_ports.value.port_start
              port_end   = allowed_host_ports.value.port_end
              protocol   = coalesce(allowed_host_ports.value.protocol, "TCP")
            }
          }
          application_security_group_ids = node_network_profile.value.application_security_group_ids
          node_public_ip_tags            = coalesce(node_network_profile.value.node_public_ip_tags, {})
        }
      }
      node_public_ip_prefix_id     = default_node_pool.value.node_public_ip_enabled == true ? default_node_pool.value.node_public_ip_prefix_id : null
      node_labels                  = coalesce(default_node_pool.value.node_labels, {})
      only_critical_addons_enabled = default_node_pool.value.only_criical_addons_enabled
      orchestrator_version         = default_node_pool.value.orchestrator_version
      os_disk_size_gb              = default_node_pool.value.os_disk_size_gb
      os_disk_type                 = coalesce(default_node_pool.value.os_disk_type, "Managed")
      os_sku                       = coalesce(default_node_pool.value.os_sku, "Ubuntu")
      pod_subnet_id                = default_node_pool.value.pod_subnet_id
      proximity_placement_group_id = default_node_pool.value.proximity_placement_group_id
      scale_down_mode              = coalesce(default_node_pool.value.scale_down_mode, "Delete")
      snapshot_id                  = coalsce(default_node_pool.value.snapshot_id)
      temporary_name_for_rotation  = var.default_node_pool.value.temporary_name_for_rotation
      type                         = coalesce(default_node_pool.value.type, "VirtualMachineScaleSets")
      tags                         = coalesce(default_node_pool.value.tags, {})
      ultra_ssd_enabled            = coalesce(default_node_pool.value.ultra_ssd_enabled, false)
      dynamic "upgrade_settings" {
        for_each = default_node_pool.value.upgrade_settings == null ? [] : [efault_node_pool.value.upgrade_settings]
        content {
          drain_timeout_in_minutes      = upgrade_settings.value.drain_timeout_in_minutes
          node_soak_duration_in_minutes = coalesce(upgrade_settings.value.node_soak_duration_in_minutes, 0)
          max_surge                     = upgrade_settings.value.max_surge
          undrainable_node_behavior     = upgrade_settings.value.undrainable_node_behavior
        }
      }
      vnet_subnet_id   = default_node_pool.value.vnet_subnet_id
      workload_runtime = default_node_pool.value.workload_runtime
      zones            = coalesce(default_node_pool.value.zones, [])
      max_count        = default_node_pool.value.auto_scaling_enabled == true ? default_node_pool.value.max_count : null
      min_count        = default_node_pool.value.auto_scaling_enabled == true ? default_node_pool.value.min_count : null
      node_count       = default_node_pool.value.auto_scaling_enabled == true ? default_node_pool.value.node_count : null
    }
  }

  dns_prefix                 = var.dns_prefix_private_cluster == null ? var.dns_prefix : null
  dns_prefix_private_cluster = var.dns_prefix_private_cluster

  dynamic "aci_connector_linux" {
    for_each = var.aci_connector_linux == null ? [] : [var.aci_connector_linux]
    content {
      subnet_name = aci_connector_linux.value.subnet_name
    }
  }

  ai_toolchain_operator_enabled = coalesce(var.ai_toolchain_operator_enabled, false)
  automatic_upgrade_channel     = coalesce(var.automatic_upgrade_channel, "None")

  dynamic "api_server_access_profile" {
    for_each = var.api_server_access_profile == null ? [] : [var.api_server_access_profile]
    content {
      authorized_ip_ranges                = coalesce(api_server_access_profile.value.authorized_ip_ranges, [])
      subnet_id                           = api_server_access_profile.value.subnet_id
      virtual_network_integration_enabled = coalesce(api_server_access_profile.value.virtual_network_integration_enabled, false)
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = var.auto_scaler_profile == null ? [] : [var.auto_scaler_profile]
    content {
      balance_similar_node_groups                   = coalesce(auto_scaler_profile.value.balance_similar_node_groups, false)
      daemonset_eviction_for_empty_nodes_enabled    = coalesce(auto_scaler_profile.value.daemonset_eviction_for_empty_nodes_enabled, false)
      daemonset_eviction_for_occupied_nodes_enabled = coalesce(auto_scaler_profile.value.daemonset_eviction_for_occupied_nodes_enabled, true)
      expander                                      = coalesce(auto_scaler_profile.value.expander, "random")
      ignore_daemonsets_utilization_enabled         = coalesce(auto_scaler_profile.value.ignore_daemonsets_utilization_enabled, false)
      max_graceful_termination_sec                  = coalesce(auto_scaler_profile.value.max_graceful_termination_sec, 600)
      max_node_provisioning_time                    = coalesce(auto_scaler_profile.value.max_node_provisioning_time, "15m")
      max_unready_nodes                             = coalesce(auto_scaler_profile.value.max_unready_nodes, 3)
      max_unready_percentage                        = coalesce(auto_scaler_profile.value.max_unready_percentage, 45)
      new_pod_scale_up_delay                        = coalesce(auto_scaler_profile.value.new_pod_scale_up_delay, "10s")
      scale_down_delay_after_add                    = coalesce(auto_scaler_profile.value.scale_down_delay_after_add, "10m")
      scale_down_delay_after_delete                 = coalesce(auto_scaler_profile.value.scale_down_delay_after_delete, auto_scaler_profile.value.scan_interval)
      scale_down_delay_after_failure                = coalesce(auto_scaler_profile.value.scale_down_delay_after_failure, "3m")
      scan_interval                                 = coalesce(auto_scaler_profile.value.scan_interval, "10s")
      scale_down_unneeded                           = coalesce(auto_scaler_profile.value.scale_down_unneeded, "10m")
      scale_down_unready                            = coalesce(auto_scaler_profile.value.scale_down_unready, "20m")
      scale_down_utilization_threshold              = coalesce(auto_scaler_profile.value.scale_down_utilization_threshold, 0.5)
      empty_bulk_delete_max                         = coalesce(auto_scaler_profile.value.empty_bulk_delete_max, 10)
      skip_nodes_with_local_storage                 = coalesce(auto_scaler_profile.value.skip_nodes_with_local_storage, false)
      skip_nodes_with_system_pods                   = coalesce(auto_scaler_profile.value.skip_nodes_with_system_pods, true)
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.azure_active_directory_role_based_access_control == null ? [] : [var.azure_active_directory_role_based_access_control]
    content {
      tenant_id              = azure_active_directory_role_based_access_control.value.tenant_id
      admin_group_object_ids = coalesce(azure_active_directory_role_based_access_control.value.admin_group_object_ids, [])
      azure_rbac_enabled     = coalesce(azure_active_directory_role_based_access_control.value.azure_rbac_enabled, true)
    }
  }

  azure_policy_enabled = var.azure_policy_enabled

  dynamic "confidential_computing" {
    for_each = var.confidential_computing == null ? [] : [var.confidential_computing]
    content {
      sgx_quote_helper_enabled = confidential_computing.value.sgx_quote_helper_enabled
    }
  }

  cost_analysis_enabled               = var.sku_tier == "Standard" || var.sku_tier == "Premium" ? var.cost_analysis_enabled : false
  custom_ca_trust_certificates_base64 = coalesce(var.custom_ca_trust_certificates_base64, [])
  disk_encryption_set_id              = var.disk_encryption_set_id
  edge_zone                           = var.edge_zone
  http_application_routing_enabled    = var.http_application_routing_enabled

  dynamic "http_proxy_config" {
    for_each = var.http_proxy_config == null ? [] : [var.http_proxy_config]
    content {
      http_proxy  = http_proxy_config.value.http_proxy
      https_proxy = http_proxy_config.value.https_proxy
      no_proxy    = coalesce(http_proxy_config.value.no_proxy, [])
      trusted_ca  = http_proxy_config.value.trusted_ca
    }
  }

  dynamic "identity" {
    for_each = var.identity != null && var.service_principal == null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.type == "UserAssigned" ? coalesce(identity.value.identity_ids, []) : null
    }
  }

  image_cleaner_enabled = var.image_cleaner_enabled

  dynamic "ingress_application_gateway" {
    for_each = var.ingress_application_gateway == null ? [] : [var.ingress_application_gateway]
    content {
      gateway_id   = ingress_application_gateway.value.gateway_id
      gateway_name = ingress_application_gateway.value.gateway_name
      subnet_cidr  = ingress_application_gateway.value.subnet_cidr
      subnet_id    = ingress_application_gateway.value.subnet_id
    }
  }

  dynamic "key_management_service" {
    for_each = var.key_management_service == null ? [] : [var.key_management_service]
    content {
      key_vault_key_id         = key_management_service.value.key_vault_key_id
      key_vault_network_access = coalesce(key_management_service.value.key_vault_network_access, "Public")
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider == null ? [] : [var.key_vault_secrets_provider]
    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = coalesce(key_vault_secrets_provider.value.secret_rotation_interval, "2m")
    }
  }

  dynamic "kubelet_identity" {
    for_each = var.kubelet_identity == null ? [] : [var.kubelet_identity]
    content {
      client_id                 = kubelet_identity.value.client_id
      object_id                 = kubelet_identity.value.object_id
      user_assigned_identity_id = kubelet_identity.value.user_assigned_identity_id
    }
  }

  kubernetes_version = var.kubernetes_version

  dynamic "linux_profile" {
    for_each = var.linux_profile == null ? [] : [var.linux_profile]
    content {
      admin_username = linux_profile.value.admin_username
      dynamic "ssh_key" {
        for_each = linux_profile.value.ssh_key == null ? [] : [linux_profile.value.ssh_key]
        content {
          key_data = ssh_key.value.key_data
        }
      }
    }
  }

  local_account_disabled = var.local_account_disabled

  dynamic "maintenance_window" {
    for_each = var.maintenance_window == null ? [] : [var.maintenance_window]
    content {
      dynamic "allowed" {
        for_each = maintenance_window.value.allowed == null ? [] : [maintenance_window.value.allowed]
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
      dynamic "not_allowed" {
        for_each = maintenance_window.value.not_allowed == null ? [] : [maintenance_window.value.not_allowed]
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = var.maintenance_window_auto_upgrade == null ? [] : [var.maintenance_window_auto_upgrade]
    content {
      frequency    = maintenance_window_auto_upgrade.value.frequency
      interval     = maintenance_window_auto_upgrade.value.interval
      duration     = maintenance_window_auto_upgrade.value.duration
      day_of_week  = maintenance_window_auto_upgrade.value.day_of_week
      day_of_month = maintenance_window_auto_upgrade.value.day_of_month
      week_index   = maintenance_window_auto_upgrade.value.week_index
      start_time   = maintenance_window_auto_upgrade.value.start_time
      utc_offset   = maintenance_window_auto_upgrade.value.utc_offset
      start_date   = maintenance_window_auto_upgrade.value.start_date
      dynamic "not_allowed" {
        for_each = maintenance_window_auto_upgrade.value.not_allowed == null ? [] : [maintenance_window_auto_upgrade.value.not_allowed]
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_node_os" {
    for_each = var.maintenance_window_node_os == null ? [] : [var.maintenance_window_node_os]
    content {
      frequency    = maintenance_window_node_os.value.frequency
      interval     = maintenance_window_node_os.value.interval
      duration     = maintenance_window_node_os.value.duration
      day_of_week  = maintenance_window_node_os.value.day_of_week
      day_of_month = maintenance_window_node_os.value.day_of_month
      week_index   = maintenance_window_node_os.value.week_index
      start_time   = maintenance_window_node_os.value.start_time
      utc_offset   = maintenance_window_node_os.value.utc_offset
      start_date   = maintenance_window_node_os.value.start_date
      dynamic "not_allowed" {
        for_each = maintenance_window_node_os.value.not_allowed == null ? [] : [maintenance_window_node_os.value.not_allowed]
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "microsoft_defender" {
    for_each = var.microsoft_defender == null ? [] : [var.microsoft_defender]
    content {
      log_analytics_workspace_id = microsoft_defender.value.log_analytics_workspace_id
    }
  }

  dynamic "monitor_metrics" {
    for_each = var.monitor_metrics == null ? [] : [var.monitor_metrics]
    content {
      annotations_allowed = coalesce(monitor_metrics.value.annotations_allowed, true)
      labels_allowed      = coalesce(monitor_metrics.value.labels_allowed, true)
    }
  }

  dynamic "network_profile" {
    for_each = var.network_profile == null ? [] : [var.network_profile]
    content {
      network_plugin      = network_profile.value.network_plugin
      network_mode        = network_profile.value.network_mode
      network_policy      = network_profile.value.network_policy
      dns_service_ip      = network_profile.value.dns_service_ip
      network_data_plane  = coalesce(network_profile.value.network_data_plane, "azure")
      network_plugin_mode = coalesce(network_profile.value.network_plugin_mode, "overlay")
      outbound_type       = coalesce(network_profile.value.outbound_type, "loadBalancer")
      pod_cidr            = network_profile.value.pod_cidr
      pod_cidrs           = coalesce(network_profile.value.pod_cidrs, [])
      ip_versions         = coalesce(network_profile.value.ip_versions, "Ipv4")
      load_balancer_sku   = coalesce(network_profile.value.load_balancer_sku, "standard")
      dynamic "load_balancer_profile" {
        for_each = network_profile.value.load_balancer_profile != null && network_profile.value.load_balancer_sku == "standard" ? [network_profile.value.load_balancer_profile] : []
        content {
          backend_pool_type           = coalesce(load_balancer_profile.value.backend_pool_type, "NodeIPConfiguration")
          idle_timeout_in_minutes     = coalesce(load_balancer_profile.value.idle_timeout_in_minutes, 30)
          managed_outbound_ip_count   = load_balancer_profile.value.managed_outbound_ip_count
          managed_outbound_ipv6_count = coalesce(load_balancer_profile.value.managed_outbound_ipv6_count, 0)
          outbound_ip_address_ids     = coalesce(load_balancer_profile.value.outbound_ip_address_ids, [])
          outbound_ip_prefix_ids      = coalesce(load_balancer_profile.value.outbound_ip_prefix_ids, [])
          outbound_ports_allocated    = coalesce(load_balancer_profile.value.outbound_ports_allocated, 0)
        }
      }
      dynamic "nat_gateway_profile" {
        for_each = network_profile.value.nat_gateway_profile != null && network_profile.value.load_balancer_sku == "standard" ? [network_profile.value.nat_gateway_profile] : []
        content {
          idle_timeout_in_minutes   = coalesce(nat_gateway_profile.value.idle_timeout_in_minutes, 4)
          managed_outbound_ip_count = nat_gateway_profile.value.managed_outbound_ip_count
        }
      }
      dynamic "advanced_networking" {
        for_each = network_profile.value.advanced_networking == null ? [] : [network_profile.value.advanced_networking]
        content {
          observability_enabled = coalesce(advanced_networking.value.observability_enabled, false)
          security_enabled      = coalesce(advanced_networking.value.security_enabled, false)
        }
      }
    }
  }

  dynamic "bootstrap_profile" {
    for_each = var.bootstrap_profile == null ? [] : [var.bootstrap_profile]
    content {
      artifact_source       = coalesce(bootstrap_profile.value.artifact_source, "Direct")
      container_registry_id = bootstrap_profile.value.container_registry_id
    }
  }

  node_os_upgrade_channel = var.automatic_upgrade_channel == "node-image" ? "NodeImage" : coalesce(var.node_os_upgrade_channel, "NodeImage")

  dynamic "node_provisioning_profile" {
    for_each = var.node_provisioning_profile == null ? [] : [var.node_provisioning_profile]
    content {
      default_node_pools = coalesce(node_provisioning_profile.value.default_node_pools, "Auto")
      mode               = coalesce(node_provisioning_profile.value.mode, "Manual")
    }
  }

  node_resource_group = var.node_resource_group
  oidc_issuer_enabled = coalesce(var.oidc_issuer_enabled, false)

  dynamic "oms_agent" {
    for_each = var.oms_agent == null ? [] : [var.oms_agent]
    content {
      log_analytics_workspace_id      = oms_agent.value.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = oms_agent.value.msi_auth_for_monitoring_enabled
    }
  }

  open_service_mesh_enabled           = coalesce(var.open_service_mesh_enabled, false)
  private_cluster_enabled             = coalesce(var.private_cluster_enabled, false)
  private_dns_zone_id                 = var.private_dns_zone_id
  private_cluster_public_fqdn_enabled = coalesce(var.private_cluster_public_fqdn_enabled, false)
  role_based_access_control_enabled   = coalesce(var.role_based_access_control_enabled, true)
  run_command_enabled                 = coalesce(var.run_command_enabled, true)

  dynamic "service_mesh_profile" {
    for_each = var.service_mesh_profile == null ? [] : [var.service_mesh_profile]
    content {
      mode                             = coalesce(service_mesh_profile.value.mode, "Istio")
      revisions                        = service_mesh_profile.value.revisions
      internal_ingress_gateway_enabled = service_mesh_profile.value.internal_ingress_gateway_enabled
      external_ingress_gateway_enabled = service_mesh_profile.value.external_ingress_gateway_enabled
      dynamic "certificate_authority" {
        for_each = service_mesh_profile.value.certificate_authority == null ? [] : [service_mesh_profile.value.certificate_authority]
        content {
          key_vault_id           = certificate_authority.value.key_vault_id
          root_cert_object_name  = certificate_authority.value.root_cert_object_name
          cert_chain_object_name = certificate_authority.value.cert_chain_object_name
          cert_object_name       = certificate_authority.value.cert_object_name
          key_object_name        = certificate_authority.value.key_object_name
        }
      }
    }
  }

  dynamic "service_principal" {
    for_each = var.service_principal != null && var.identity == null ? [var.service_principal] : []
    content {
      client_id     = service_principle.value.client_id
      client_secret = service_principal.value.client_secret
    }
  }

  sku_tier = coalesce(var.sku_tier, "Standard")

  dynamic "storage_profile" {
    for_each = var.storage_profile == null ? [] : [var.storage_profile]
    content {
      blob_driver_enabled         = coalesce(storage_profile.value.blob_driver_enabled, false)
      disk_driver_enabled         = coalesce(storage_profile.value.disk_driver_enabled, true)
      file_driver_enabled         = coalesce(storage_profile.value.file_driver_enabled, true)
      snapshot_controller_enabled = coalesce(storage_profile.value.snapshot_controller_enabled, true)
    }
  }

  support_plan = coalesce(var.support_plan, "KubernetesOfficial")

  dynamic "upgrade_override" {
    for_each = var.upgrade_override == null ? [] : [var.upgrade_override]
    content {
      force_upgrade_enabled = upgrade_override.value.force_upgrade_enabled
      effective_until       = upgrade_override.value.effective_until
    }
  }

  dynamic "web_app_routing" {
    for_each = var.web_app_routing == null ? [] : [var.web_app_routing]
    content {
      dns_zone_ids             = web_app_routing.value.dns_zone_ids
      default_nginx_controller = coalesce(web_app_routing.value.default_nginx_controller, "AnnotationControlled")
    }
  }

  dynamic "windows_profile" {
    for_each = var.windows_profile == null ? [] : [var.windows_profile]
    content {
      admin_username = windows_profile.value.admin_username
      admin_password = windows_profile.value.admin_password
      license        = coalesce(windows_profile.value.license, "Windows_Server")
      dynamic "gmsa" {
        for_each = windows_profile.value.gmsa == null ? [] : [windows_profile.value.gmsa]
        content {
          dns_server  = gmsa.value.dns_server
          root_domain = gmsa.value.root_domain
        }
      }
    }
  }

  dynamic "workload_autoscaler_profile" {
    for_each = var.workload_autoscaler_profile == null ? [] : [var.workload_autoscaler_profile]
    content {
      keda_enabled                    = workload_autoscaler_profile.value.keda_enabled
      vertical_pod_autoscaler_enabled = workload_autoscaler_profile.value.vertical_pod_autoscaler_enabled
    }
  }

  workload_identity_enabled = coalesce(var.workload_identity_enabled, false)
  tags                      = var.environment == null ? var.tags : merge({ environment = var.environment }, var.tags)

}