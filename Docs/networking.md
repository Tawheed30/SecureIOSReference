# Networking Module — ATS (HTTP) Demo

## Goal
Show how **ATS** blocks insecure **HTTP** by default, and how a misconfigured app can allow it.

## Build modes
- **VULN**: HTTP allowed (ATS weakened via Info.plist / settings)
- **FIXED**: ATS enforced (HTTP blocked by design)

## How to run
1. Scheme → **Debug-VULN** or **Debug-FIXED**
2. Open **Networking (HTTP vs ATS + pinning)**
3. URL: `http://example.com`
4. Tap **Send request**

## Expected results
- **VULN**: request succeeded (HTTP 200)
- **FIXED**: ATS enforced (HTTP blocked), typically `-1022`

## Notes
- This is a controlled demo. In real apps you should prefer HTTPS and avoid broad ATS exceptions.
