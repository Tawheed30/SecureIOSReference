import SwiftUI

struct NetworkingModuleView: View {
    @State private var urlString: String = "http://example.com"
    @State private var result: String = "Ready"

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

                Text("Demonstrates plain HTTP behavior under ATS: VULN can be configured to allow HTTP, FIXED should enforce ATS.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Request") {
                TextField("URL", text: $urlString)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section("Actions") {
                Button("Send request") { sendRequest() }

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
        return """
VULN: this build is intended to demonstrate allowing insecure HTTP by weakening ATS (Info.plist). If ATS is not weakened, HTTP will still fail.
"""
        #elseif FIXED
        return """
FIXED: ATS should remain strict. Plain HTTP is expected to fail (by design).
"""
        #else
        return "Build with Debug-VULN or Debug-FIXED."
        #endif
    }

    private func sendRequest() {
        guard let url = URL(string: urlString) else {
            result = "Invalid URL"
            return
        }

        #if FIXED
        // FIXED build: do not try to bypass ATS in code. ATS should block HTTP.
        if url.scheme?.lowercased() == "http" {
            result = "FIXED: ATS enforced (HTTP blocked by design)"
            return
        }
        #endif

        result = "Loading..."

        URLSession.shared.dataTask(with: url) { _, response, error in
            DispatchQueue.main.async {
                #if VULN
                if let nsError = error as NSError? {
                    result = "VULN: failed (\(nsError.code)): \(nsError.localizedDescription)"
                    return
                }
                if let http = response as? HTTPURLResponse {
                    result = "VULN: request succeeded (HTTP \(http.statusCode))"
                } else {
                    result = "VULN: request succeeded"
                }

                #elseif FIXED
                if let nsError = error as NSError? {
                    result = "FIXED: failed (\(nsError.code)): \(nsError.localizedDescription)"
                    return
                }
                if let http = response as? HTTPURLResponse {
                    result = "FIXED: request succeeded (HTTP \(http.statusCode))"
                } else {
                    result = "FIXED: request succeeded"
                }

                #else
                if let nsError = error as NSError? {
                    result = "Failed (\(nsError.code)): \(nsError.localizedDescription)"
                } else {
                    result = "Success"
                }
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
