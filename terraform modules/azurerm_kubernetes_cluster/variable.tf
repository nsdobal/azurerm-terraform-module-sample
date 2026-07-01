variable "name" {
  type     = string
  nullable = false
}

variable "location" {
  type     = string
  nullable = false
}

variable "resource_group_name" {
  type     = string
  nullable = false
}

variable "default_node_pool" {
  type = object({
    name                          = optional(string, null)
    vm_size                       = optional(string, null)
    capacity_reservation_group_id = optional(string, null)
    auto_scaling_enabled          = optional(bool, true)
    host_encryption_enabed        = optional(string, null)
    node_public_ip_enabled        = optional(bool, false)
    gpu_driver                    = optional(string, "None") # valid values are : Install or None
    gpu_instance                  = optional(string)         # Valid values are : MIG1g, MIG2g, MIG3g, MIG4g and MIG7g
    host_group_id                 = optional(string, null)
    kubelet_config = optional(object({
      allowed_unsafe_sysctls    = optional(list(string), [])
      container_log_max_files   = optional(number)
      container_log_max_size_mb = optional(number, 10) # Maximum possible : 10MB
      cpu_cfs_quota_enabled     = optional(bool, true)
      cpu_manager_policy        = optional(string) # Valid values are None, Static
      image_gc_high_threshold   = optional(number) # Valid value is 0 to 100 in percentage
      image_gc_low_threshold    = optional(number) # Valid value is 0 to 100 in percentage
      pod_max_pid               = optional(number)
      topology_manager_policy   = optional(string) # Valid values are : none, best-effort, restricted or single-numa-node
    }), null)
    linux_os_config = optional(object({
      swap_file_size_mb = optional(number)
      sysctl_config = optional(object({
        fs_aio_max_nr                      = optional(number) # Valid range is : 65536 to 6553500
        fs_file_max                        = optional(number) # Valid range is : 8192 to 12000500
        fs_inotify_max_user_watches        = optional(number) # Valid range is : 781250 to 2097152
        fs_nr_open                         = optional(number) # Valid range is : 8192 to 20000500
        kernel_threads_max                 = optional(number) # Valid range is : 20 to 513785
        net_core_netdev_max_backlog        = optional(number) # Valid range is : 1000 to 3240000
        net_core_optmem_max                = optional(number) # Valid range is : 20480 to 4194304
        net_core_rmem_default              = optional(number) # Valid range is : 212992 to 134217728
        net_core_rmem_max                  = optional(number) # Valid range is : 212992 to 134217728
        net_core_somaxconn                 = optional(number) # Valid range is : 4096 to 3240000
        net_core_wmem_default              = optional(number) # Valid range is : 212992 to 134217728
        net_core_wmem_max                  = optional(number) # Valid range is : 212992 to 134217728
        net_ipv4_ip_local_port_range_max   = optional(number) # Valid range is : 32768  to 65535
        net_ipv4_ip_local_port_range_min   = optional(number) # Valid range is : 1024 to 60999
        net_ipv4_neigh_default_gc_thresh1  = optional(number) # Valid range is : 128 to 80000
        net_ipv4_neigh_default_gc_thresh2  = optional(number) # Valid range is : 512 to 90000
        net_ipv4_neigh_default_gc_thresh3  = optional(number) # Valid range is : 1024 to 100000
        net_ipv4_tcp_fin_timeout           = optional(number) # Valid range is : 5 to 120
        net_ipv4_tcp_keepalive_intvl       = optional(number) # Valid range is : 10 to 90
        net_ipv4_tcp_keepalive_probes      = optional(number) # Valid range is : 1 to 15
        net_ipv4_tcp_keepalive_time        = optional(number) # Valid range is : 30 to 432000
        net_ipv4_tcp_max_syn_backlog       = optional(number) # Valid range is : 128 to 3240000
        net_ipv4_tcp_max_tw_buckets        = optional(number) # Valid range is : 8000 to 1440000
        net_ipv4_tcp_tw_reuse              = optional(bool)
        net_netfilter_nf_conntrack_buckets = optional(number) # Valid range is : 65536 to 524288
        net_netfilter_nf_conntrack_max     = optional(number) # Valid range is : 131072 to 2097152
        vm_max_map_count                   = optional(number) # Valid range is : 65530 to 262144
        vm_swappiness                      = optional(number) # Valid range is : 0 to 100
        vm_vfs_cache_pressure              = optional(number) # Valid range is : 0 to 100
      }), null)
      transparent_huge_page_defrag = optional(string) # Valid values are : always, defer, defer+madvise, madvise and never
      transparent_huge_page        = optional(string) # Valid values are : always, madvise and never
    }), null)
    fips_enabed       = optional(bool)
    kubelet_disk_type = optional(string) # Valid values are : OS or Temporary
    max_pods          = optional(number)
    node_network_profile = optional(object({
      allowed_host_ports = optional(object({
        port_start = optional(number)
        port_end   = optional(number)
        protocol   = optional(string, "TCP") # Valid values are : TCP, UDP
      }), null)
      application_security_group_ids = optional(list(string), [])
      node_public_ip_tags            = optional(map, {})
    }), null)
    node_public_ip_prefix_id     = optional(string)
    node_labels                  = optional(map, {})
    only_criical_addons_enabled  = optional(bool)
    orchestrator_version         = optional(string)
    os_disk_size_gb              = optional(number)
    os_disk_type                 = optional(string, "Managed") # Valid values are : Ephemeral or Managed
    os_sku                       = optional(string, "Ubuntu")  # Valid values are : AzureLinux, AzureLinux3, Ubuntu, Ubuntu2204, Ubuntu2404, Windows2019 and Windows2022
    pod_subnet_id                = optional(string, null)
    proximity_placement_group_id = optional(string, null)
    scale_down_mode              = optional(string, "Delete") # Valid values are : Delete, Deallocate
    snapshot_id                  = optional(string)
    temporary_name_for_rotation  = optional(string, null)
    type                         = optional(string, "VirtualMachineScaleSets") # Valid values are : VirtualMachineScaleSets
    tags                         = optional(map, {})
    ultra_ssd_enabled            = optional(bool, false)
    upgrade_settings = optional(object({
      drain_timeout_in_minutes      = optional(number)
      node_soak_duration_in_minutes = optional(number, 0)
      max_surge                     = number
      undrainable_node_behavior     = optional(string) # Valid values are : Cordon and Schedule
    }), null)
    vnet_subnet_id   = optional(string)
    workload_runtime = optional(string) # Valid values are : KataVmIsolation, OCIContainer
    zones            = optional(list(string), [])
    max_count        = optional(number, null) # Valid range is 1 to 1000
    min_count        = optional(number, null) # Valid range is 1 to 1000
    node_count       = optional(number, null) # Valid range is 1 to 1000 (between min_count and max_count)
  })
  nullable = false
}

variable "dns_prefix" {
  type     = string
  nullable = true
  default  = null
}

variable "dns_prefix_private_cluster" {
  type     = string
  nullable = true
  default  = null
}

variable "aci_connector_linux" {
  type = object({
    subnet_name = string
  })
  nullable = true
  default  = null
}

variable "ai_toolchain_operator_enabled" {
  type     = bool
  nullable = true
  default  = false
}

variable "automatic_upgrade_channel" {
  type     = string
  nullable = true
  default  = "None"
  validation {
    condition     = var.automatic_upgrade_channel == null || contains(["patch", "rapid", "node-image", "stable", "None"], var.automatic_upgrade_channel)
    error_message = "azurerm_kubernetes_cluster > automatic_upgrade_channel : Possible values are patch, rapid, node-image, stable, none"
  }
}

variable "api_server_access_profile" {
  type = object({
    authorized_ip_ranges                = optional(list(string), [])
    subnet_id                           = optional(string, null)
    virtual_network_integration_enabled = optional(bool, false)
  })
  nullable = true
  default  = null
}

variable "auto_scaler_profile" {
  type = object({
    balance_similar_node_groups                   = optional(bool, false)
    deamonset_eviction-for_empty_nodes_enabled    = optional(bool, false)
    daemonset_eviction_for_occupied_nodes_enabled = optional(bool, true)
    expander                                      = optional(string, "random") # valid values are : least-waste, priority, most-pods, random
    ignore_daemonsets_utilization_enabled         = optional(bool, false)
    max_graceful_termination_sec                  = optional(number, 600) # Number in seconds
    max_node_provisioning_time                    = optional(string, "15m")
    max_unready_nodes                             = optional(number, 3)
    max_unready_percentage                        = optional(number, 45)
    new_pod_scale_up_delay                        = optional(string, "10s")
    scale_down_delay_after_add                    = optional(string, "10m")
    scale_down_delay_after_delete                 = optional(string) # 1st priority, else take from scan_interval
    scale_down_delay_after_failure                = optional(string, "3m")
    scan_interval                                 = optional(string, "10s")
    scale_down_unneeded                           = optional(string, "10m")
    scale_down_unready                            = optional(string, "20m")
    scale_down_utilization_threshold              = optional(number, 0.5)
    empty_bulk_delete_max                         = optional(number, 10)
    skip_nodes_with_local_storage                 = optional(bool, false)
    skip_nodes_with_system_pods                   = optional(bool, true)
  })
  nullable = true
  default  = null
}

variable "azure_active_directory_role_based_access_control" {
  type = object({
    tenant_id              = optional(string)
    admin_group_object_ids = optional(list(string), [])
    azure_rbac_enabled     = optional(bool, true)
  })
  nullable = true
  default  = null
}

variable "azure_policy_enabled" {
  type     = bool
  nullable = true
  default  = null
}

variable "confidential_computing" {
  type = object({
    sgx_quote_helper_enabled = bool
  })
  nullable = true
  default  = null
}

variable "cost_analysis_enabled" {
  type     = bool
  nullable = true
  default  = false
}

variable "custom_ca_trust_certificates_base64" {
  type     = list(string)
  nullable = true
  default  = []
}

variable "disk_encryption_set_id" {
  type     = string
  nullable = true
  default  = null
}

variable "edge_zone" {
  type     = string
  nullable = true
  default  = null
}

variable "http_application_routing_enabled" {
  type     = bool
  nullable = true
  default  = null
}

variable "http_proxy_config" {
  type = object({
    http_proxy  = optional(string)
    https_proxy = optional(string)
    no_proxy    = optional(list(string), [])
    trusted_ca  = optional(string)
  })
  nullable = true
  default  = null
}

variable "identity" {
  type = object({
    type         = string # Valid values are : SystemAssigned, UserAssigned
    identity_ids = optional(list(string), [])
  })
  nullable = true
  default  = null
}

variable "image_cleaner_enabled" {
  type     = bool
  nullable = true
  default  = null
}

variable "ingress_application_gateway" {
  type = object({
    gateway_id   = optional(string)
    gateway_name = optional(string)
    subnet_cidr  = optional(string)
    subnet_id    = optional(string)
  })
  nullable = true
  default  = null
}

variable "key_management_service" {
  type = object({
    key_vault_key_id         = string
    key_vault_network_access = optional(string, "Public") # Valid values are : Public, Private
  })
  nullable = true
  default  = null
}

variable "key_vault_secrets_provider" {
  type = object({
    secret_rotation_enabled  = optional(bool)
    secret_rotation_interval = optional(string, "2m")
  })
  nullable = true
  default  = null
}

variable "kubelet_identity" {
  type = object({
    client_id                 = optional(string)
    object_id                 = optional(string)
    user_assigned_identity_id = optional(string)
  })
  nullable = true
  default  = null
}

variable "kubernetes_version" {
  type     = string
  nullable = true
  default  = null
}

variable "linux_profile" {
  type = object({
    admin_username = string
    ssh_key = object({
      key_data = string
    })
  })
  nullable = true
  default  = null
}

variable "local_account_disabled" {
  type     = bool
  nullable = true
  default  = null # If true, you need to enable kubernetes RBAC and AKS-managed azure AD integration
}

variable "maintenance_window" {
  type = object({
    allowed = optional(object({
      day   = string       # Valid values are Monday to Sunday
      hours = list(number) # Valid range 0 to 23 ~ 1 is 1am 1,2 is 1am to 3am
    }), null)
    not_allowed = optional(object({
      end   = string
      start = string
    }), null)
  })
  nullable = true
  default  = null
}

variable "maintenance_window_auto_upgrade" {
  type = object({
    frequency    = string # Valid values are : Daily, Weekly, AbsoluteMonthly and RelativeMonthly
    interval     = number
    duration     = number # Valid range is 4 to 24 in hours
    day_of_week  = optional(string, null)
    day_of_month = optional(number, null) # Valid range is 0 to 31
    week_index   = optional(string, null)
    start_time   = optional(string, null)
    utc_offset   = optional(string, null)
    start_date   = optional(string, null)
    not_allowed = optional(object({
      end   = string
      start = string
    }), null)
  })
  nullable = true
  default  = null
}

variable "maintenance_window_node_os" {
  type = object({
    frequency    = string # Valid values are Daily, Weekly, AbsoluteMonthly and RelativeMonthly
    interval     = string
    duration     = number           # Valid range is 4 to 24 in hours
    day_of_week  = optional(string) # Valid values are Monday to Sunday 
    day_of_month = optional(number) # Valid range is 0 to 31
    week_index   = optional(string) # Valid values are First, Second, Third, Fourth, and Last
    start_time   = optional(string)
    utc_offset   = optional(string)
    start_date   = optional(string)
    not_allowed = optional(object({
      end   = string
      start = string
    }), null)
  })
  nullable = true
  default  = null
}

variable "microsoft_defender" {
  type = object({
    log_analytics_workspace_id = string
  })
  nullable = true
  default  = null
}

variable "monitor_metrics" {
  type = object({
    annotations_allowed = optional(bool, true)
    labels_allowed      = optional(bool, true)
  })
  nullable = true
  default  = null
}

variable "network_profile" {
  type = object({
    network_plugin      = string           # Valid values are : azure, kubenet and none
    network_mode        = optional(string) # Valid values are : bridge and transparent
    network_policy      = optional(string) # Valid values are : calico, azure and cilium
    dns_service_ip      = optional(string)
    network_data_plane  = optional(string, "azure ")       # Valid values are : azure and cilium
    network_plugin_mode = optional(string, "overlay")      # Valid values are : overlay
    outbound_type       = optional(string, "loadBalancer") # Valid values are : loadBalancer, userDefinedRouting, managedNATGateway, userAssignedNATGateway and none
    pod_cidr            = optional(string)
    pod_cidrs           = optional(list(string), [])
    ip_versions         = optional(list(string), ["IPv4"]) # Valid values are : IPv4 and/or IPv6
    load_balancer_sku   = optional(string, "standard")     # Valid values are : basic and standard
    load_balancer_profile = optional(object({
      backend_pool_type           = optional(string, "NodeIPConfiguration") # Valid values are : NodeIP and NodeIPConfiguration
      idle_timeout_in_minutes     = optional(number, 30)                    # Valid range is 4 to 300
      managed_outbound_ip_count   = optional(number)                        # Valid range is 1 to 100
      managed_outbound_ipv6_count = optional(number, 0)                     # Valid range is 1 to 100
      outbound_ip_address_ids     = optional(list(string), [])
      outbound_ip_prefix_ids      = optional(list(string), [])
      outbound_ports_allocated    = optional(number, 0) # Valid range is 0 to 64000
    }), null)
    nat_gateway_profile = optional(object({
      idle_timeout_in_minutes   = optional(number, 4) # Valid range is 4 to 120
      managed_outbound_ip_count = optional(number)    # Valid range is 1 to 16
    }), null)
    advanced_networking = optional(object({
      observability_enabled = optional(bool, false)
      security_enabled      = optional(bool, false)
    }), null)
  })
  nullable = true
  default  = null
}

variable "bootstrap_profile" {
  type = object({
    artifact_source       = optional(string, "Direct") # Valid values are : Cache and Direct
    container_registry_id = optional(string)           # ACR ID
  })
  nullable = true
  default  = null
}

variable "node_os_upgrade_channel" {
  type     = string
  nullable = true
  default  = "NodeImage"
  validation {
    condition     = var.node_os_upgrade_channel == null || contains(["Unmanaged", "SecurityPatch", "NodeImage", "None"], var.node_os_upgrade_channel)
    error_message = "azurerm_kubernetes_cluster > node_os_upgrade_channel : Valid values are Unmanaged, SecurityPatch, NodeImage, None"
  }
}

variable "node_provisioning_profile" {
  type = object({
    default_node_pools = optional(string, "Auto")   # Valid values are : Auto and Manual
    mode               = optional(string, "Manual") # Valid values are : Auto and Manual
  })
  nullable = true
  default  = null
}

variable "node_resource_group" {
  type     = string
  nullable = true
  default  = null
}

variable "oidc_issuer_enabled" {
  type     = bool
  nullable = true
  default  = false
}

variable "oms_agent" {
  type = object({
    log_analytics_workspace_id      = string
    msi_auth_for_monitoring_enabled = optional(bool)
  })
  nullable = true
  default  = null
}

variable "open_service_mesh_enabled" {
  type     = bool
  nullable = true
  default  = false
}

variable "private_cluster_enabled" {
  type     = bool
  nullable = true
  default  = false
}

variable "private_dns_zone_id" {
  type     = string
  nullable = true
  default  = null
}

variable "private_cluster_public_fqdn_enabled" {
  type     = bool
  nullable = true
  default  = false
}

variable "role_based_access_control_enabled" {
  type     = bool
  nullable = true
  default  = true
}

variable "run_command_enabled" {
  type     = bool
  nullable = true
  default  = true
}

variable "service_mesh_profile" {
  type = object({
    mode                             = optional(string, "Istio") # Valid values are : Istio
    revisions                        = string
    internal_ingress_gateway_enabled = optional(bool)
    external_ingress_gateway_enabled = optional(bool)
    certificate_authority = optional(object({
      key_vault_id           = string
      root_cert_object_name  = string
      cert_chain_object_name = string
      cert_object_name       = string
      key_object_name        = string
    }), null)
  })
  nullable = true
  default  = null
}

variable "service_principal" {
  type = object({
    client_id     = string
    client_secret = string
  })
  nullable = true
  default  = null
}

variable "sku_tier" {
  type     = string
  nullable = true
  default  = "Standard"
  validation {
    condition     = var.sku_tier == null || contains(["Free", "Standard", "Premium"], var.sku_tier)
    error_message = "azurerm_kubernetes_cluster > sku_tier : valid values are Free, Standard, Premium"
  }
}

variable "storage_profile" {
  type = object({
    blob_driver_enabled         = optional(bool, false)
    disk_driver_enabled         = optional(bool, true)
    file_driver_enabled         = optional(bool, true)
    snapshot_controller_enabled = optional(bool, true)
  })
  nullable = true
  default  = null
}

variable "support_plan" {
  type     = string
  nullable = true
  default  = "KubernetesOfficial"
  validation {
    condition     = var.support_plan == null || contains(["KubernetesOfficial", "AKSLongTermSupport"], var.support_plan)
    error_message = "azurerm_kubernetes_cluster > support_plan : valid values are 'KubernetesOfficial', 'AKSLongTermSupport'"
  }
}

variable "upgrade_override" {
  type = object({
    force_upgrade_enabled = bool
    effective_until       = optional(string, null)
  })
  nullable = true
  default  = null
}

variable "web_app_routing" {
  type = object({
    dns_zone_ids             = list(string)
    default_nginx_controller = optional(string, "AnnotationControlled") # Valid values are : None, Internal, External and AnnotationControlled
  })
  nullable = true
  default  = null
}

variable "windows_profile" {
  type = object({
    admin_username = string
    admin_password = string
    license        = optional(string, "Windows_Server")
    gmsa = optional(object({
      dns_server  = string
      root_domain = string
    }), null)
  })
  nullable = true
  default  = null
}

variable "workload_autoscaler_profile" {
  type = object({
    keda_enabled                    = optional(bool)
    vertical_pod_autoscaler_enabled = optional(bool)
  })
  nullable = true
  default  = null
}

variable "workload_identity_enabled" {
  type     = bool
  nullable = true
  default  = false
}

variable "environment" {
  type     = string
  nullable = true
  default  = null
}

variable "tags" {
  type     = map(string)
  nullable = true
  default  = null
}

