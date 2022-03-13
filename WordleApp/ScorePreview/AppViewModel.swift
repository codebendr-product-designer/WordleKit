import ScoreClientLive
import Combine
import WordleKit
import SwiftUI

public extension WordleKit {
    class AppViewModel: ObservableObject {
        @Published public var scores = [Scores.Score]()
        private let scoreClient: ScoreClient
        private var cancellables = Set<AnyCancellable>()
        
        public init(scoreClient: ScoreClient) {
            self.scoreClient = scoreClient
            polling()
            

        }
        
        
        private func polling() {
            scoreClient
                .scores()
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { [weak self] scores in
                        print("polling")
  
                      
                    }
                )
                .store(in: &cancellables)
        }
    }
}
