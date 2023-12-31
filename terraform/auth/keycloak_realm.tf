resource "keycloak_realm" "lan_pezlab_dev" {
  realm             = "lan-pezlab-dev"
  enabled           = true
  display_name      = "Pezlab Lan"
  display_name_html = "<b>Pezlab Lan</b>"


  access_code_lifespan = "1h"
  account_theme        = "keycloak.v2"
  admin_theme          = "keycloak.v2"
  email_theme          = "keycloak"
  login_theme          = "keycloak"
  ssl_required         = "external"
  password_policy      = "upperCase(1) and length(8) and forceExpiredPasswordChange(365) and notUsername"


  internationalization {
    supported_locales = [
      "en",
    ]
    default_locale = "en"
  }

  security_defenses {
    headers {
      x_frame_options                     = "DENY"
      content_security_policy             = "frame-src 'self'; frame-ancestors 'self'; object-src 'none';"
      content_security_policy_report_only = ""
      x_content_type_options              = "nosniff"
      x_robots_tag                        = "none"
      x_xss_protection                    = "1; mode=block"
      strict_transport_security           = "max-age=31536000; includeSubDomains"
    }
    brute_force_detection {
      permanent_lockout                = false
      max_login_failures               = 30
      wait_increment_seconds           = 60
      quick_login_check_milli_seconds  = 1000
      minimum_quick_login_wait_seconds = 60
      max_failure_wait_seconds         = 900
      failure_reset_time_seconds       = 43200
    }
  }
}

resource "keycloak_ldap_user_federation" "ldap_user_federation" {
  name     = "freeipa"
  realm_id = keycloak_realm.lan_pezlab_dev.id
  enabled  = true

  edit_mode               = "READ_ONLY"
  search_scope            = "SUBTREE"
  username_ldap_attribute = "uid"
  rdn_ldap_attribute      = "uid"
  uuid_ldap_attribute     = "uidNumber"
  user_object_classes = [
    "inetorgperson",
    "organizationalperson"
  ]
  connection_url  = "ldaps://ldap.lan.pezlab.dev:636"
  users_dn        = "cn=users,cn=accounts,dc=lan,dc=pezlab,dc=dev"
  bind_dn         = "uid=bind,cn=users,cn=accounts,DC=lan,DC=pezlab,DC=dev"
  bind_credential = data.vault_generic_secret.ldap.data["bind"]

  connection_timeout = "5s"
  read_timeout       = "10s"
}

resource "keycloak_ldap_group_mapper" "ldap_group_mapper" {
  realm_id                = keycloak_realm.lan_pezlab_dev.id
  ldap_user_federation_id = keycloak_ldap_user_federation.ldap_user_federation.id
  name                    = "group-mapper"

  ldap_groups_dn            = "cn=groups,cn=accounts,dc=lan,dc=pezlab,dc=dev"
  group_name_ldap_attribute = "cn"
  group_object_classes = [
    "groupOfNames"
  ]
  membership_attribute_type      = "DN"
  membership_ldap_attribute      = "member"
  membership_user_ldap_attribute = "cn"
  memberof_ldap_attribute        = "memberOf"
}