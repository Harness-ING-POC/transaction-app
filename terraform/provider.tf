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
    platform_api_key    = "pat.IFG41DWvSnaRLOVNB2uesg.68c81ec0dc4c4c477bf32ea2.KMzCPUSZ2Uxit1jgwrcG"  
}