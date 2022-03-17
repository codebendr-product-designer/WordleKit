import Foundation
import WordleKit

public extension WordleKit {
    // MARK: - Scores
    struct Scores: Codable  {
        public let scores: [Score]
        
        // MARK: - Score
        public struct Score: Codable, Identifiable, Hashable {
            public var id: Int = 0
            public var date: String = ""
            public var word: String = ""
            public var tries: [String] = []
            
            public init(word: String, tries: [String]) {
                self.word = word
                self.tries = tries
            }
        }
    }
}

