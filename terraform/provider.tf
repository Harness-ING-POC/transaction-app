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
    platform_api_key    = "pat.IFG41DWvSnaRLOVNB2uesg.68c92a3daf7b346133901c0a.65ffUp9xZQ4FBJAcGgTu"  
}