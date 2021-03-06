landingzone = {
  backend_type        = "azurerm"
  global_settings_key = "launchpad"
  level               = "level0"
  key                 = "azdo-contoso_demo"
  tfstates = {
    launchpad = {
      level   = "current"
      tfstate = "caf_launchpad.tfstate"
    }
  }
}

resource_groups = {
  rg1 = {
    name = "devops-agents-security"
  }
}

# need to add logged in user

keyvaults = {
  devops = {
    name               = "devops"
    resource_group_key = "rg1"
    sku_name           = "standard"

    creation_policies = {
      keyvault_level0_rw = {
        # Reference a key to an azure ad group
        lz_key             = "launchpad"
        azuread_group_key  = "keyvault_level0_rw"
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
      logged_in_user = {
        # if the key is set to "logged_in_user" add the user running terraform in the keyvault policy
        # More examples in /examples/keyvault
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
  }
}

keyvault_access_policies_azuread_apps = {
  level0 = {
    contoso_demo = {
      lz_key             = "launchpad"
      azuread_app_key    = "contoso_demo"
      secret_permissions = ["Get", "List"]
    }
  }
  level1 = {
    contoso_demo = {
      lz_key             = "launchpad"
      azuread_app_key    = "contoso_demo"
      secret_permissions = ["Get", "List"]
    }
  }
  level2 = {
    contoso_demo = {
      lz_key             = "launchpad"
      azuread_app_key    = "contoso_demo"
      secret_permissions = ["Get", "List"]
    }
  }
  level3 = {
    contoso_demo = {
      lz_key             = "launchpad"
      azuread_app_key    = "contoso_demo"
      secret_permissions = ["Get", "List"]
    }
  }
  level4 = {
    contoso_demo = {
      lz_key             = "launchpad"
      azuread_app_key    = "contoso_demo"
      secret_permissions = ["Get", "List"]
    }
  }
}


azuread_apps = {

  contoso_demo = {
    useprefix               = true
    application_name        = "caf-level4-contoso-demo"
    password_expire_in_days = 60
    tenant_name             = "M365x803675.onmicrosoft.com"
    keyvaults = {
      devops = {
        secret_prefix = "aadapp-caf-launchpad-level0"
      }
    }
  }

}

custom_role_definitions = {

  caf-azdo-to-azure-subscription = {
    name        = "caf-azure-devops-TO-azure-subscription"
    useprefix   = true
    description = "CAF Custom role for service principal in Azure Devops to access resources"
    permissions = {
      actions = [
        "Microsoft.Resources/subscriptions/read",
        "Microsoft.KeyVault/vaults/read"
      ]
    }
  }

}


role_mapping = {
  custom_role_mapping = {
    subscriptions = {
      logged_in_subscription = {
        "caf-azdo-to-azure-subscription" = {
          azuread_apps = {
            keys = ["contoso_demo"]
          }
        }
      }
    }
  }
}
