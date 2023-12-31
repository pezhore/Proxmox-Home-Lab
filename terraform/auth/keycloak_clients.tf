resource "keycloak_openid_client" "netbox" {
  realm_id              = keycloak_realm.lan_pezlab_dev.id
  client_id             = "netbox"
  name                  = "netbox"
  enabled               = true
  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  valid_redirect_uris = [
    "https://netbox.lan.pezlab.dev/*"
  ]
}

resource "keycloak_openid_client" "vault" {
  realm_id              = keycloak_realm.lan_pezlab_dev.id
  client_id             = "vault"
  name                  = "vault"
  enabled               = true
  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  valid_redirect_uris = [
    "https://vault.lan.pezlab.dev/ui/vault/auth/oidc/oidc/callback",
    "https://vault.lan.pezlab.dev/oidc/oidc/callback/"
  ]
}

resource "keycloak_openid_client" "pve" {
  realm_id              = keycloak_realm.lan_pezlab_dev.id
  client_id             = "pve"
  name                  = "pve"
  enabled               = true
  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  implicit_flow_enabled = true
  valid_redirect_uris = [
    "https://pve-01.lan.pezlab.dev:8006/*",
    "https://pve-02.lan.pezlab.dev:8006/*",
    "https://pve-03.lan.pezlab.dev:8006/*"
  ]
}