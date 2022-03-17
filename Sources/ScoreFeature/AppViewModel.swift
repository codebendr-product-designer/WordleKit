import ScoreClient
import Combine
import WordleKit
import Helpers
import SwiftUI

public extension WordleKit {
    class AppViewModel: ObservableObject {
        @Published public var scores = [Scores.Score]()
        @Published private var counter = 0
        private let scoreClient: ScoreClient
        public var totalScore = 0
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
        
        private func polling() {
            scoreClient
                .scores()
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { [weak self] scores in
                        self?.scores = scores.scores
                    }
                )
                .store(in: &cancellables)
        }
        
        private func diffing(
            local: [Scores.Score],
            from remote: [Scores.Score]) -> [Scores.Score] {
                local.diffing(from: remote)
            }
        
#warning("Dirty Dancing, figure out a better DSA for this")
        public func tries(_ score: Scores.Score) -> [Tries] {
            var tries = [Tries]()
            var doubleCharCheck: Character = .init(" ")
            var characterCount = 0
            
            //            tries = score.tries
            //                .map{$0}
            //                .enumerated()
            //                .map { [weak self] index, word -> String in
            //                    let positionalScore = word.count * index
            //                    self?.totalScore = score.word == word && index <= 3 ?
            //                    positionalScore * 30 :
            //                    -positionalScore * 10
            //                    return word
            //                }
            //                .map{(Character($0),$0)}
            //                .map{ character, string in
            //                    characterCount += 1
            //                    if score.word.contains(character) {
            //                        return .init(character, 1)
            //                    } else if score.word == string {
            //                        return .init(character, 2)
            //                    } else {
            //                        if let index = score.word.firstIndex(of: character),
            //                           let stringIndex = string.firstIndex(of: character) {
            //                            if score.word[index] == score.word[stringIndex] {
            //                                if string.indicesOf(string: .init(character)).count >= 2 {
            //                                    let characterRemoved = string.squeezed
            //                                    if let characterRemovedIndex = string.squeezed.firstIndex(of: character) {
            //                                        if doubleCharCheck == .init(" ") {
            //                                            doubleCharCheck = character
            //                                            return .init(characterRemoved[characterRemovedIndex], 2)
            //                                        }
            //                                    }
            //                                } else {
            //                                    return .init(character, 2)
            //                                }
            //                            }
            //                        }
            //                    }
            //                    return .init(character, 0)
            //                }
            //
            //            tries += (0..<30 - characterCount)
            //                .map { _ in
            //                    .init(.init(" "))
            //            }
            
            score.tries.forEach { stringArray in
                stringArray.forEach { character in
                    characterCount += 1
                    
                    var t = Tries()
                    if score.word.contains(character) {
                        t = Tries(character, 1)
                    } else {
                        t = Tries(character, 0)
                    }
                    if score.word == stringArray {
                        t = Tries(character, 2)
                    } else {
                        if let index = score.word.firstIndex(of: character),
                           let mainIndex = stringArray.firstIndex(of: character)  {
                            if score.word[index] == score.word[mainIndex]  {
                                if stringArray.indicesOf(string: .init(character)).count >= 2 {
                                    let s = stringArray.squeezed
                                    
                                    if let w = s.firstIndex(of: character) {
                                        
                                        if doubleCharCheck == .init(" ") {
                                            doubleCharCheck = character
                                            t = Tries(s[w], 2)
                                            
                                        }
                                    }
                                    
                                } else {
                                    t = Tries(character, 2)
                                }
                                
                                
                            }
                        }
                    }
                    
                    tries.append(t)
                }
            }
            let count = 30 - characterCount
            
            for _ in 0..<count  {
                tries.append(.init(.init(" ")))
            }
            return tries
        }
    }
}
