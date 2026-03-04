import SwiftUI

struct StorageModuleView: View {
    @State private var username: String = "demo_user"
    @State private var token: String = "demo_token_123"
    @State private var status: String = "Ready"

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Build Mode")
                    Spacer()
                    Text(currentModeLabel)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                }

                Text("This module demonstrates insecure local storage vs Keychain.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Demo Data (safe)") {
                TextField("Username", text: $username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                TextField("Token", text: $token)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section("Actions") {
                Button("Save credentials") {
                    save()
                }

                Button("Load credentials") {
                    load()
                }

                Button("Clear credentials", role: .destructive) {
                    clear()
                }
            }

            Section("Status") {
                Text(status)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Notes") {
                Text(notesText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Storage")
    }

    private var currentModeLabel: String {
        #if VULN
        return "VULNERABLE"
        #elseif FIXED
        return "FIXED"
        #else
        return "UNKNOWN"
        #endif
    }

    private var notesText: String {
        #if VULN
        return "VULN: stores token in UserDefaults (plaintext, easy to extract)."
        #elseif FIXED
        return "FIXED: stores token in Keychain (encrypted at rest, access-controlled)."
        #else
        return "Build with Debug-VULN or Debug-FIXED."
        #endif
    }

    // Step 35 will implement these with VULN vs FIXED behavior.
    private func save() {
        #if VULN
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: "demo.username")
        defaults.set(token, forKey: "demo.token") // plaintext
        status = "VULN: Saved to UserDefaults (plaintext)"
        #elseif FIXED
        do {
            try KeychainService.save(service: "SecureIOSReference", account: "demo.username", data: Data(username.utf8))
            try KeychainService.save(service: "SecureIOSReference", account: "demo.token", data: Data(token.utf8))
            status = "FIXED: Saved to Keychain"
        } catch {
            status = "FIXED: Keychain save failed: \(error.localizedDescription)"
        }
        #else
        status = "Unknown build mode"
        #endif
    }

    private func load() {
        #if VULN
        let defaults = UserDefaults.standard
        username = defaults.string(forKey: "demo.username") ?? ""
        token = defaults.string(forKey: "demo.token") ?? ""
        status = "VULN: Loaded from UserDefaults"
        #elseif FIXED
        do {
            if let u = try KeychainService.load(service: "SecureIOSReference", account: "demo.username"),
               let t = try KeychainService.load(service: "SecureIOSReference", account: "demo.token") {
                username = String(decoding: u, as: UTF8.self)
                token = String(decoding: t, as: UTF8.self)
                status = "FIXED: Loaded from Keychain"
            } else {
                status = "FIXED: Nothing in Keychain"
            }
        } catch {
            status = "FIXED: Keychain load failed: \(error.localizedDescription)"
        }
        #else
        status = "Unknown build mode"
        #endif
    }

    private func clear() {
        #if VULN
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "demo.username")
        defaults.removeObject(forKey: "demo.token")
        status = "VULN: Cleared UserDefaults"
        #elseif FIXED
        do {
            try KeychainService.delete(service: "SecureIOSReference", account: "demo.username")
            try KeychainService.delete(service: "SecureIOSReference", account: "demo.token")
            status = "FIXED: Cleared Keychain"
        } catch {
            status = "FIXED: Keychain delete failed: \(error.localizedDescription)"
        }
        #else
        status = "Unknown build mode"
        #endif
    }
}

#Preview {
    NavigationStack {
        StorageModuleView()
    }
}
