# Manual Instructions for Disabling LLMNR and mDNS via Group Policy

This document provides step-by-step manual instructions for disabling Link-Local Multicast Name Resolution (LLMNR) and Multicast DNS (mDNS) in an Active Directory environment using Group Policy Management Console.

## Prerequisites

- Domain Administrator privileges
- Group Policy Management Console installed
- Access to a domain controller

## Instructions for Disabling LLMNR

### Step 1: Create a New GPO

1. Open Group Policy Management Console (gpmc.msc)
2. Right-click on the OU where you want to apply the policy (e.g., Domain Controllers OU) and select "Create a GPO in this domain, and Link it here..."
3. Name the GPO (e.g., "Disable LLMNR") and click "OK"

### Step 2: Configure LLMNR Settings

1. Right-click on the newly created GPO and select "Edit"
2. Navigate to: Computer Configuration > Administrative Templates > Network > DNS Client
3. Find the policy named "Turn off multicast name resolution"
4. Double-click on it and set it to "Enabled"
5. Click "Apply" and then "OK"

![Search for LLMNR Policy](images/stepbysearch.png)

## Instructions for Disabling mDNS

### Step 1: Create a New GPO

1. Open Group Policy Management Console (gpmc.msc)
2. Right-click on the OU where you want to apply the policy (e.g., Client Computers OU) and select "Create a GPO in this domain, and Link it here..."
3. Name the GPO (e.g., "Disable mDNS") and click "OK"

![Group Policy Objects](images/group_policy.png)

### Step 2: Configure mDNS Settings

1. Right-click on the newly created GPO and select "Edit"
2. Navigate to: Computer Configuration > Preferences > Windows Settings > Registry
3. Right-click on Registry and select "New > Registry Item"
4. Configure the registry item with these settings:
   - Action: Create
   - Hive: HKEY_LOCAL_MACHINE
   - Key Path: SOFTWARE\Policies\Microsoft\Windows NT\DNSClient
   - Value name: EnableMulticast
   - Value type: REG_DWORD
   - Value data: 0
5. Click "OK"

![Disable mDNS Settings](images/disable%20mdsn.png)

## Verifying Policy Application

After configuring the GPOs, you should verify that they are correctly applied to the target computers:

### Method 1: Using GPResult

1. On a target computer, open Command Prompt as Administrator
2. Run the command: `gpresult /r`
3. Check that the correct GPOs are applied to the computer

### Method 2: Using Registry Editor

1. On a target computer, open Registry Editor (regedit.exe) as Administrator
2. Navigate to: HKLM\Software\Policies\Microsoft\Windows NT\DNSClient
3. Verify that the EnableMulticast value is set to 0

## Forcing Policy Update

If you want to force the policy to apply immediately:

1. On a target computer, open Command Prompt as Administrator
2. Run the command: `gpupdate /force`

## Troubleshooting

If the policy is not applying correctly:

1. Check that the GPO is linked to the correct OU
2. Verify that there are no conflicting policies with higher precedence
3. Ensure that the computer can communicate with the domain controllers
4. Check the Event Viewer for any Group Policy related errors

## Security Considerations

Disabling LLMNR and mDNS may impact name resolution in some environments. Before implementing these changes across your entire organization, it's recommended to test them in a controlled environment to ensure that there are no adverse effects on your network functionality.

Remember that these changes are security hardening measures and should be part of a comprehensive security strategy that includes regular auditing, monitoring, and updates to Group Policy settings.