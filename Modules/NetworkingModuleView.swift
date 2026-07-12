import SwiftUI

struct NetworkingModuleView: View {
    @State private var urlString: String = "http://example.com"
    @State private var result: String = "Ready"
    @State private var isLoading: Bool = false

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

                Text("Demonstrates plain HTTP behavior under ATS. VULN can be configured to allow HTTP; FIXED blocks HTTP by design and expects HTTPS.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Request") {
                TextField("URL", text: $urlString)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section("Actions") {
                Button(isLoading ? "Sending…" : "Send request") {
                    sendRequest()
                }
                .disabled(isLoading)

                Button("Reset", role: .destructive) {
                    urlString = "http://example.com"
                    result = "Ready"
                }
            }

            Section("Result") {
                Text(result)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Notes") {
                Text(notesText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Networking")
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
        return "VULN: This build demonstrates allowing insecure HTTP by weakening ATS in Info.plist (NSAppTransportSecurity). If ATS is not weakened, HTTP will fail with -1022."
        #elseif FIXED
        return "FIXED: HTTP is blocked by design. Use HTTPS URLs (e.g., https://example.com). ATS remains strict."
        #else
        return "Build with Debug-VULN or Debug-FIXED."
        #endif
    }

    private func sendRequest() {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed),
              let scheme = url.scheme?.lowercased() else {
            result = "Invalid URL"
            return
        }

        #if FIXED
        if scheme == "http" {
            result = "FIXED: ATS enforced (HTTP blocked by design)"
            return
        }
        #endif

        isLoading = true
        result = "Sending…"

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.timeoutInterval = 10

        URLSession.shared.dataTask(with: req) { _, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error as NSError? {
                    #if VULN
                    self.result = "VULN: failed (\(error.code)): \(error.localizedDescription)"
                    #else
                    self.result = "Failed (\(error.code)): \(error.localizedDescription)"
                    #endif
                    return
                }

                let status = (response as? HTTPURLResponse)?.statusCode ?? -1
                #if VULN
                self.result = "VULN: request succeeded (HTTP \(status))"
                #else
                self.result = "Request succeeded (HTTP \(status))"
                #endif
            }
        }.resume()
    }
}

#Preview {
    NavigationStack {
        NetworkingModuleView()
    }
}
