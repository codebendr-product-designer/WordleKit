import Combine
import WordleKit

public extension WordleKit {
    struct ScoreClient {
        public enum Method: String {
            case get, post, delete
        }
        public typealias ScoresPublisher = () -> AnyPublisher<Scores, Error>
        
        public var scores: ScoresPublisher
        public init(
            scores: @escaping ScoresPublisher
        ) {
            self.scores = scores
        }
    }
}
