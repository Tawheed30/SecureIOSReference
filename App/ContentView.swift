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
        VStack(spacing: 12) {
            Text("Secure iOS Reference")
                .font(.title2)
                .bold()

            Text(modeText)
                .font(.headline)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
