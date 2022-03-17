import ScoreClient
import Combine
import WordleKit
import SwiftUI

public extension WordleKit {
    class AppViewModel: ObservableObject {
        @Published public var scores = [Scores.Score]()
        @Published private var counter = 0
        private let scoreClient: ScoreClient
        private var cancellables = Set<AnyCancellable>()
        
        public init(scoreClient: ScoreClient) {
            self.scoreClient = scoreClient
        }
    }
}
