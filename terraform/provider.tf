terraform {  
    required_providers {  
        harness = {  
            source = "harness/harness"
        }  
    }  
}

provider "harness" {  
    endpoint   = "https://workshop.harness.io"  
    account_id = "IFG41DWvSnaRLOVNB2uesg"  
    platform_api_key    = "pat.IFG41DWvSnaRLOVNB2uesg.68c816c985d7245766437b99.qF9cLTx2HPYKQvu81VXi"  
}