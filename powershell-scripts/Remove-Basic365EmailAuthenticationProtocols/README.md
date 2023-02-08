# About

This script disables **ALL** basic authentication protocols for every mailbox in your Microsoft 365 tenant.
![alt text](screenshot1.png)

Disabling these basic auth protocols will substantially improve your security posturing.

BE CAREFUL -- analyze Azure sign-in logs before taking any actions.

## Why?

Protocols like SMTP, POP, & IMAP do not authenticate with MFA, making them a popular attack vector.
Don't fall prey to an SMTP phishing hack after putting in the hardwork to deploy MFA.

Read more: https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/disable-basic-authentication-in-exchange-online

## Recommendations

Disable these protocols at the Microsoft 365 tenant level & the Exchange Online level

#### M365
- admin.microsoft.com > Settings > Org settings > Modern authentication > disable all basic authentication protocls
![alt text](screenshot2.png)

#### Exchange Online
- 

Enable modern authentication for Outlook in Exchange Online
- https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/enable-or-disable-modern-authentication-in-exchange-online
