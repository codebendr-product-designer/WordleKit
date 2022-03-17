public extension Array where Element: Hashable {
     func diffing(from other: [Element]) -> [Element] {
         .init(Set(self).symmetricDifference(Set(other)))
    }
}
