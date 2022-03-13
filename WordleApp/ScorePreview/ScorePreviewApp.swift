import SwiftUI
import WordleKit

@main
struct ScorePreviewApp: App {
    var body: some Scene {
        WindowGroup {
            WordleKit.ContentView(
                .init(scoreClient: .live)
            )
        }
    }
}
