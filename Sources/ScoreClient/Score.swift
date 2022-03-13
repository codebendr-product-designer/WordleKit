import Foundation
import WordleKit

public extension WordleKit {
    // MARK: - Scores
    struct Scores: Codable  {
        public let scores: [Score]
        
        // MARK: - Score
        public struct Score: Codable, Identifiable, Hashable {
            public let id: Int
            public let date, word: String
            public let tries: [String]
        }
    }
}

