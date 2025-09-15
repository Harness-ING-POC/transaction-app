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
    platform_api_key    = "pat.IFG41DWvSnaRLOVNB2uesg.68c817f8365cc96fc3c22585.dfA7EYy4ECpG4DSGJz2z"  
}