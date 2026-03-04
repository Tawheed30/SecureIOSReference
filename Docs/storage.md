# Storage Module — UserDefaults vs Keychain

## Goal
Demonstrate insecure local credential storage (VULN) vs secure storage (FIXED) using the same UI and build-time switch.

## Build Modes
- **Debug-VULN**: stores `demo.username` + `demo.token` in **UserDefaults** (plaintext).
- **Debug-FIXED**: stores the same values in **Keychain** (encrypted at rest, access controlled).

## How to Run
1. Product → Scheme → Edit Scheme… → Run → Build Configuration:
   - `Debug-VULN` or `Debug-FIXED`
2. Run → Home → Storage
3. Tap **Clear → Save → Load** and observe Status.

## Security Notes
### Why UserDefaults is insecure for secrets
- Stored as plaintext in the app sandbox.
- Commonly extracted via device backups, malware, or local filesystem access on compromised devices.

### Why Keychain is preferred
- Encrypted at rest + access control policies.
- Designed for secrets (tokens, passwords, keys).

## Limitations
- This is a teaching demo with safe values (`demo_*`).
- Keychain accessibility is set to `kSecAttrAccessibleWhenUnlocked` for simplicity.

## Files
- `Modules/StorageModuleView.swift`
- `Security/KeychainService.swift`
