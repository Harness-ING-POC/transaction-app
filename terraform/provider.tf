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
    platform_api_key    = "sat.IFG41DWvSnaRLOVNB2uesg.68c8199285d7245766438ece.YjkoIowFCZlNQzr9S7Tz"  
}