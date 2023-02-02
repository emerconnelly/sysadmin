# about
This script is intended to audit user account age & MFA details using hybrid and legacy systems, i.e.
- Azure Graph (Legacy Per-User MFA)
- Exchange Online
- Microsoft Graph

I may update this script over time to include new data, better the formatting, or improve efficiency.

This script expects you have an Azure app registered with the required permissions, a certificate for authentication, and the required variables found in [a relative link](variables_template.json)

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
