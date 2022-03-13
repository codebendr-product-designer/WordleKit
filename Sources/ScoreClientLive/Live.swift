import Foundation
import ScoreClient
import WordleKit
import Combine

#warning("add ACCESS_TOKEN")
//extension String {
//static let accessToken = "ACCESS_TOKEN GOES HERE"
//}


public extension WordleKit.ScoreClient {
    static var live: Self {
        .init {
            return URLSession.shared
                .dataTaskPublisher(for: .scores())
                .map(\.data)
                .decode(type: WordleKit.Scores.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            
        }
    }
}
