import SwiftUI

@main
struct KeeleSoberApp: App {
    @StateObject private var viewModel = KeeleSoberViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
