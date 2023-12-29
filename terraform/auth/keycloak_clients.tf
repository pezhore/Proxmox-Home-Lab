resource "keycloak_openid_client" "netbox" {
    realm_id = keycloak_realm.lan_pezlab_dev.id
    client_id = "netbox"
    name = "netbox"
    enabled = true
    access_type = "CONFIDENTIAL"
    standard_flow_enabled = true
    valid_redirect_uris = [
        "https://netbox.lan.pezlab.dev/*"
    ]
}