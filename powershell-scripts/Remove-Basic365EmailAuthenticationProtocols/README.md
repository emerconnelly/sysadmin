# About
This script disables **ALL** basic authentication protocols for every mailbox in your Microsoft 365 tenant.

Disabling these basic auth protocols can substantially improve security posturing, but BE CAREFUL.
Monitor your Azure sign-in logs before taking any actions.

# Why?
Protocols like SMTP, POP, & IMAP do not authenticate with MFA, making them a popular attack vector.
Don't fall prey to an SMTP phishing hack after putting in the hardwork to deploy MFA.

# Recommendations