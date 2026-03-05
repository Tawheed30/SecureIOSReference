# Secure iOS Reference (Swift)

A reference iOS app that demonstrates **vulnerable vs fixed** secure engineering patterns using a build-time switch.

## Build modes
- **Debug-VULN**: intentionally insecure implementations (safe demo values only)
- **Debug-FIXED**: secure implementations with notes on tradeoffs/limitations

## Modules
- **Storage** — UserDefaults (VULN) vs Keychain (FIXED)
  See: `Docs/storage.md`
- **Networking** — ATS (HTTP) demo: VULN allows HTTP, FIXED blocks
  See: `Docs/networking.md`

## How to run
1. Xcode → Product → Scheme → Edit Scheme… → Run → Build Configuration:
   - `Debug-VULN` or `Debug-FIXED`
2. Run the app → open a module → follow the module doc steps.

## Repo layout
- `App/`        App entry + home navigation
- `Modules/`    Demo modules (UI + behavior)
- `Security/`   Security primitives/services (e.g., Keychain wrapper)
- `Docs/`       Module writeups (vuln → impact → fix → limitations)

## Safety
This project uses **demo credentials only** and is designed for education/testing.
