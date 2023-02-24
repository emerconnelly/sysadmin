## why?
I was unable to find an Intune CSP for this (maybe I am missing it), so registry config it is.
- [Policy CSP - RemoteDesktopServices](https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-remotedesktopservices)
- [Policy CSP - RemoteAssistance](https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-remoteassistance)

## how?
Set `Shadow` to `2` as a `REG_DWORD` under `HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services`.

## extra info
[A how-to](https://woshub.com/rds-shadow-how-to-connect-to-a-user-session-in-windows-server-2012-r2/) on shadow remoting & GPO config.
