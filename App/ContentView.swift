import SwiftUI

struct ContentView: View {

    private var modeText: String {
        #if VULN
        return "Mode: VULNERABLE"
        #elseif FIXED
        return "Mode: FIXED"
        #else
        return "Mode: UNKNOWN"
        #endif
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Secure iOS Reference")
                        .font(.title2)
                        .bold()

                    Text(modeText)
                        .font(.headline)
                }

                Section("Modules") {
                    NavigationLink("Storage (UserDefaults vs Keychain)") {
                        StorageModuleView()
                    }

                    NavigationLink("Networking (HTTP vs ATS + pinning)") {
                        NetworkingModuleView()
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
