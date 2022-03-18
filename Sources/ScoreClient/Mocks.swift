import WordleKit
import SwiftUI

#warning("should be moved to helper or utils Module")
import Combine
public extension AnyPublisher {
    init(_ value: Output) {
        self = Just(value).setFailureType(to: Failure.self).eraseToAnyPublisher()
    }
}
public extension WordleKit.ScoreClient {
    static let happyPath = Self {
        .init(.init(scores: [
            .init(word: "lapse", tries: ["stair","peony","lapse"]),
            .init(word: "month", tries: ["stair","tuned","monty","month"]),
            .init(word: "sweet", tries: ["corgi","pause","sleds","sweet"])
        ])
        )
    }
    
    static let polling = Self {
        var scores: [WordleKit.Scores.Score] = [
            .init(word: "lapse", tries: ["stair","peony","lapse"])
        ]
     
        var _scores: [WordleKit.Scores.Score] = [
            .init(word: "lapse", tries: ["stair","peony","lapse"]),
            .init(word: "month", tries: ["stair","tuned","monty","month"]),
            .init(word: "sweet", tries: ["corgi","pause","sleds","sweet"])
        ]
        
        return Timer.publish(every: 5, on: .main, in: .default)
           .autoconnect()
           .scan(_scores, { score, _ in
               return score
           })
           .map{ _ in
               var s = WordleKit.Scores.Score(word: "lapse", tries: ["stair","peony","lapse"])
               s.id = Int.random(in: 0..<5400)
               _scores.append(s)
               return _scores
           }
           .map{ WordleKit.Scores.init(scores:$0) }
           .setFailureType(to: Error.self)
           .eraseToAnyPublisher()
    }
}

