# Disabling LLMNR and mDNS in Active Directory via Group Policy

This repository provides documentation and guidelines for disabling Link-Local Multicast Name Resolution (LLMNR) and Multicast DNS (mDNS) in an Active Directory environment using Group Policy. Disabling these protocols helps enhance your organization's security posture by preventing potential man-in-the-middle attacks.

## Why Disable LLMNR and mDNS?

Both LLMNR and mDNS are name resolution protocols that can be exploited by attackers to:
- Capture authentication hashes
- Execute man-in-the-middle attacks
- Potentially gain unauthorized access to network resources

## Prerequisites

Before implementing these changes, ensure you have:
- Domain Administrator privileges
- Access to Group Policy Management Console
- Basic understanding of Active Directory and Group Policy

## Implementation Steps

### Step 1: Create Group Policy Objects (GPOs)

Create separate GPOs for Domain Controllers and Client Computers:

![Group Policy Objects](images/group_policy.png)

### Step 2: Configure LLMNR Settings

1. Edit the GPO and navigate to: Computer Configuration > Administrative Templates > Network > DNS Client
2. Enable the "Turn off multicast name resolution" policy

![Search for LLMNR Policy](images/stepbysearch.png)

### Step 3: Configure mDNS Settings

1. Edit the GPO and navigate to: Computer Configuration > Preferences > Windows Settings > Registry
2. Add a new registry item with the following details:
   - Action: Create
   - Hive: HKEY_LOCAL_MACHINE
   - Key Path: SOFTWARE\Policies\Microsoft\Windows NT\DNSClient
   - Value name: EnableMulticast
   - Value type: REG_DWORD
   - Value data: 0

![Disable mDNS Settings](images/disable%20mdsn.png)

### Step 4: Link GPOs to Appropriate OUs

Link the created GPOs to the appropriate Organizational Units (OUs) containing your domain controllers and client computers.

### Step 5: Verify Policy Application

After applying GPOs, verify that they are correctly applied using:
- `gpresult /r` command
- Registry Editor to check if the registry keys are properly set

## Verification

To verify that LLMNR is disabled, check for the following registry key:
```
HKLM\Software\Policies\Microsoft\Windows NT\DNSClient\EnableMulticast = 0
```

## Conclusion

Disabling LLMNR and mDNS helps enhance your organization's security posture by eliminating potential attack vectors. Regular auditing of these settings is recommended to ensure they remain correctly configured across your Active Directory environment.

## Additional Resources

- [Microsoft Documentation on LLMNR](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc816897(v=ws.10))
- [MITRE ATT&CK: LLMNR/NBT-NS Poisoning](https://attack.mitre.org/techniques/T1557/001/)