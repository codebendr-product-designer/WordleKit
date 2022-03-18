import XCTest
import Combine
import Foundation
import WordleKit
import ScoreClient
import ScoreFeature

#warning("use fatalError() to drive test")

public extension Array where Element == WordleKit.Scores.Score {
    static var scores: [WordleKit.Scores.Score]  = [
        .init(word: "lapse", tries: ["stair","peony","lapse"]),
        .init(word: "month", tries: ["stair","tuned","monty","month"]),
        .init(word: "sweet", tries: ["corgi","pause","sleds","sweet"])
    ]
}


final class ClientTests: XCTestCase {
    
    func testScore_WasRecieved() {
        
        let viewModel = WordleKit.AppViewModel(
            scoreClient: .init(scores: {
                .init(.init(scores: .scores))
              }
            )
        )
        
        XCTAssertEqual(viewModel.scores, .scores)
        
    }
    
    func testScoreTries_CheckThatCharacterCountIsAlways30() {
        
        let viewModel = WordleKit.AppViewModel(
            scoreClient: .init(scores: {
                .init(.init(scores: .scores))
              }
            )
        )
        
        XCTAssertEqual(viewModel.tries(viewModel.scores[0]).count, 30)
        
    }
}
