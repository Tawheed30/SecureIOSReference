import SwiftUI

struct ContentView: View {
    var modeText: String {
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
                }
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
