# Security Best Practices: LLMNR and mDNS in Active Directory

This document outlines the security implications of Link-Local Multicast Name Resolution (LLMNR) and Multicast DNS (mDNS) in an Active Directory environment, and provides best practices for securing your network.

## Security Risks

### LLMNR Security Risks

Link-Local Multicast Name Resolution (LLMNR) presents several security risks:

1. **Man-in-the-Middle Attacks**: Attackers can listen for LLMNR queries and respond to them, posing as legitimate resources.

2. **Credential Theft**: When a system tries to access a resource using LLMNR, it may send authentication information that can be captured by an attacker.

3. **SMB Relay Attacks**: Captured authentication information can be relayed to access other systems on the network.

### mDNS Security Risks

Multicast DNS (mDNS) shares similar security risks:

1. **Network Reconnaissance**: mDNS can leak information about hosts and services on the network.

2. **Spoofing**: Attackers can spoof mDNS responses to redirect users to malicious services.

3. **Denial of Service**: mDNS traffic can be amplified to cause network congestion.

## Comprehensive Security Approach

Disabling LLMNR and mDNS should be part of a broader security strategy:

### 1. Network Segmentation

- Implement proper network segmentation between different security zones
- Use VLANs to isolate sensitive systems
- Implement proper ACLs at network boundaries

### 2. Name Resolution Security

- Ensure reliable DNS infrastructure with proper redundancy
- Consider implementing DNS over HTTPS (DoH) or DNS over TLS (DoT)
- Set up proper DNS records for all resources to reduce the need for fallback protocols
- Configure DNS suffix search lists to help with name resolution

### 3. Authentication Security

- Implement strict NTLMv2 policies and disable older NTLM versions
- Use Kerberos authentication where possible
- Enable SMB signing to prevent relay attacks
- Consider implementing LDAP signing and channel binding

### 4. Monitoring and Detection

- Monitor for unauthorized LLMNR/mDNS traffic as an indicator of potential misconfiguration or security policy bypass
- Set up alerts for suspicious authentication attempts
- Conduct regular network scanning to identify policy violations

### 5. Testing and Validation

Before full deployment:

- Test the impact of disabling LLMNR and mDNS in a controlled environment
- Identify any applications that may rely on these protocols
- Create a rollback plan in case of unexpected issues

## Implementation Order

When implementing these security changes, follow this recommended order:

1. Inventory systems and applications to identify potential dependencies
2. Test changes in a controlled environment
3. Apply changes to IT administrative systems first
4. Gradually roll out to other systems, starting with less critical infrastructure
5. Monitor for issues and adjust as needed

## Compatibility Considerations

Some applications and services may rely on LLMNR or mDNS for proper functionality:

- Home media streaming services
- Zero-configuration networking tools
- Some collaboration tools and IoT devices
- Printer discovery services

For these cases, consider:

- Creating exceptions for specific subnets or devices where necessary
- Implementing alternative discovery mechanisms
- Updating applications to use DNS instead of LLMNR/mDNS

## Regulatory Compliance

Disabling LLMNR and mDNS can help meet requirements for:

- NIST 800-53 security controls
- CIS Benchmarks
- DISA STIGs
- PCI DSS network security requirements

Document your implementation as part of your security compliance evidence.

## Conclusion

Disabling LLMNR and mDNS is a security best practice that eliminates potential attack vectors in your Active Directory environment. However, it should be implemented as part of a comprehensive security strategy, with careful testing and monitoring to ensure that legitimate business functions are not disrupted.

Regular review of your security policies and keeping up with emerging threats and mitigations is essential for maintaining a strong security posture.