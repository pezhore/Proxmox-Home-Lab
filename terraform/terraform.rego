package terraform.analysis

import input as tfplan

########################
# Parameters for Policy
########################

# acceptable score for automated authorization
blast_radius := 100

# weights assigned for each operation on each resource-type
weights := {
    "local_file": { "delete": 1, "create": 1, "modify": 1},
    "netbox_cluster": { "delete": 30, "create": 10, "modify": 5},
    "netbox_interface": { "delete": 5, "create": 1, "modify": 1},
    "netbox_ip_address": { "delete": 10, "create": 5, "modify": 1},
    "netbox_platform": { "delete": 30, "create": 10, "modify": 5},
    "netbox_primary_ip": { "delete": 10, "create": 5, "modify": 1},
    "netbox_virtual_machine": { "delete": 20, "create": 10, "modify": 5},
    "powerdns_record": { "delete": 10, "create": 5, "modify": 1},
    "powerdns_zone": { "delete": 10, "create": 5, "modify": 1},
    "proxmox_virtual_environment_container": { "delete": 10, "create": 5, "modify": 1},
    "proxmox_virtual_environment_file": { "delete": 10, "create": 5, "modify": 1},
    "proxmox_virtual_environment_pool": { "delete": 30, "create": 10, "modify": 5},
    "proxmox_virtual_environment_role": { "delete": 30, "create": 10, "modify": 5},
    "proxmox_virtual_environment_time": { "delete": 10, "create": 5, "modify": 1},
    "proxmox_virtual_environment_user": { "delete": 30, "create": 10, "modify": 5},
    "proxmox_virtual_environment_vm": { "delete": 30, "create": 10, "modify": 5},
    "proxmox_vm_qemu": { "delete": 30, "create": 10, "modify": 5}
}

# Consider exactly these resource types in calculations
resource_types := {
    "local_file",
    "netbox_cluster",
    "netbox_interface",
    "netbox_ip_address",
    "netbox_platform",
    "netbox_primary_ip",
    "netbox_virtual_machine",
    "powerdns_record",
    "powerdns_zone",
    "proxmox_virtual_environment_container",
    "proxmox_virtual_environment_file",
    "proxmox_virtual_environment_pool",
    "proxmox_virtual_environment_role",
    "proxmox_virtual_environment_time",
    "proxmox_virtual_environment_user",
    "proxmox_virtual_environment_vm",
    "proxmox_vm_qemu"
}

#########
# Policy
#########

# Authorization holds if score for the plan is acceptable and no changes are made to IAM
default authz = false
authz {
    score < blast_radius
    not touches_iam
}

# Compute the score for a Terraform plan as the weighted sum of deletions, creations, modifications
score = s {
    all := [ x |
            some resource_type
            crud := weights[resource_type];
            del := crud["delete"] * num_deletes[resource_type];
            new := crud["create"] * num_creates[resource_type];
            mod := crud["modify"] * num_modifies[resource_type];
            x := del + new + mod
    ]
    s := sum(all)
}

# Whether there is any change to IAM
touches_iam {
    all := resources["aws_iam"]
    count(all) > 0
}

####################
# Terraform Library
####################

# list of all resources of a given type
resources[resource_type] = all {
    some resource_type
    resource_types[resource_type]
    all := [name |
        name:= tfplan.resource_changes[_]
        name.type == resource_type
    ]
}

# number of creations of resources of a given type
num_creates[resource_type] = num {
    some resource_type
    resource_types[resource_type]
    all := resources[resource_type]
    creates := [res |  res:= all[_]; res.change.actions[_] == "create"]
    num := count(creates)
}


# number of deletions of resources of a given type
num_deletes[resource_type] = num {
    some resource_type
    resource_types[resource_type]
    all := resources[resource_type]
    deletions := [res |  res:= all[_]; res.change.actions[_] == "delete"]
    num := count(deletions)
}

# number of modifications to resources of a given type
num_modifies[resource_type] = num {
    some resource_type
    resource_types[resource_type]
    all := resources[resource_type]
    modifies := [res |  res:= all[_]; res.change.actions[_] == "update"]
    num := count(modifies)
}

violation[sprintf("Score [ %d ] exceeds blast radius of [ %d ]", [score, blast_radius])]{
    score > blast_radius
}
