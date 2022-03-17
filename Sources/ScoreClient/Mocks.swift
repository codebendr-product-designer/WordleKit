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
}

