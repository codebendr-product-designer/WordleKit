import Foundation
import WordleKit

public extension WordleKit {
    
    // MARK: - Scores
    struct Scores: Codable  {
        
        public let scores: [Score]
        
        public init(scores: [WordleKit.Scores.Score]) {
            self.scores = scores
        }
        
        // MARK: - Score
        public struct Score: Codable, Identifiable, Hashable {
            public var id: Int
            public var date: String = ""
            public var word: String = ""
            public var tries: [String] = []
            public var isNew = false
            
            enum CodingKeys: String, CodingKey {
                case id, date, word, tries
            }
            
            public init(id: Int = 0, word: String, tries: [String], isNew: Bool = false) {
                self.word = word
                self.tries = tries
                self.id = id
            }
        }
    }
}

