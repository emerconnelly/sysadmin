# about
This script is intended to audit user account age & MFA details for hybrid and legacy Microsoft systems, i.e.
- Azure Graph (for Legacy Per-User MFA) [support expires soon]
- Exchange Online
- Microsoft Graph

I may update this script over time to include new data, better the formatting, or improve efficiency.

## pre-requisites
- Azure app registration with the required permissions
- RSA-signed certificate for authentication, and the required variables found in [this json template](variables_template.json).

## how to
1. download the (script)[Get-CustomUserReport.ps1] and [variables template](variables_template.json) to the same folder.
2. fill in your values and rename the variables template to `variables.json`.
3. run the script using PowerShell 5.x

---
### personal notes
#### create certificate
- https://geekshangout.com/connect-mggraph-using-a-service-principal/
- https://practical365.com/use-certificate-authentication-microsoft-graph-sdk/
- Exchange Online Management PS module does not support CNG certs
  - https://www.oneidentity.com/community/identity-manager/f/forum/33082/the-new-powershell-v2-cmdlet-to-exchange-online
  - https://stackoverflow.com/questions/22581811/invalid-provider-type-specified-cryptographicexception-when-trying-to-load-pri/34103154#34103154

#### create azure app
- add required permissions (MS Graph > App permissions)
- https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.reports/get-mgauditlogsignin?view=graph-powershell-1.0
- https://learn.microsoft.com/en-us/graph/api/signin-list?view=graph-rest-1.0&tabs=powershell
= upload certificate

#### import required sub-modules into script
- https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.reports/get-mgauditlogsignin?view=graph-powershell-1.0
- connect script via certificate

#### how to write ODate queries
- https://learn.microsoft.com/en-us/graph/filter-query-parameter?tabs=powershell
- https://helloitsliam.com/2021/10/19/microsoft-graph-powershell-filtering-working-and-failures/

#### how to format date
- https://stackoverflow.com/questions/2249619/how-to-format-a-datetime-in-powershell
