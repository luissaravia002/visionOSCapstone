import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var showQuitAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Bigger Start button that says "Start Game!"
                NavigationLink(destination: AnimalSelectionView()) {
                    Text("Start Game!")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(60)
                        .frame(maxWidth: .infinity)
                }
                
                // Settings and Quit buttons arranged horizontally.
                HStack(spacing: 20) {
                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(50)
                            .frame(maxWidth: .infinity)

                    }
                    
                    Button(action: {
                        showQuitAlert = true
                    }) {
                        Text("Quit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(50)
                            .frame(maxWidth: .infinity)

                    }
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("CommuniVerse")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
            }
            .alert("Are you sure you want to quit?", isPresented: $showQuitAlert) {
                Button("Yes", role: .destructive) {
                    #if os(macOS)
                    NSApplication.shared.terminate(nil)
                    #else
                    exit(0)
                    #endif
                }
                Button("No", role: .cancel) { }
            } message: {
                Text("This will exit the application.")
            }
        }
    }
}

#Preview {
    ContentView()
}
