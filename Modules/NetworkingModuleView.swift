import SwiftUI

struct NetworkingModuleView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            Text("Networking Module")
                .font(.title3)
                .bold()

            Text("HTTP vs ATS + pinning (next).")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Networking")
    }
}

#Preview {
    NavigationStack {
        NetworkingModuleView()
    }
}
