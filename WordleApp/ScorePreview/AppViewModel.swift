import ScoreClientLive
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
            polling()
            
            Timer.publish(every: 10, on: .main, in: .common)
                  .autoconnect()
                  .scan(0) { count, _ in
                      self.polling()
                      return count + 1
                  }
                  .assign(to: \.counter, on: self)
                  .store(in: &cancellables)

        }
        
        private func difference(
            local: [Scores.Score],
            remote: [Scores.Score]) -> [Scores.Score] {
            local.diff(from: remote)
        }
        
        private func polling() {
            scoreClient
                .scores()
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { [weak self] scores in
                        print("polling")
  
                        dump(self?.difference(
                                local: AppStorage.shared.scores,
                                remote: scores.scores)
                            )
                            self?.scores = AppStorage.shared.scores
                      
                    }
                )
                .store(in: &cancellables)
        }
    }
}
