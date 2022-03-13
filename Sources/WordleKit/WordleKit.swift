import Foundation
public struct WordleKit {}


#warning("move to Helper/Utils Module when you have more of these")
public extension Array where Element: Hashable {
     func diff(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return .init(thisSet.symmetricDifference(otherSet))
    }
}
