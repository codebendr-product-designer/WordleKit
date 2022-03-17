
public extension String {
    func index(of char: Character) -> Int? {
        firstIndex(of: char)?.utf16Offset(in: self)
    }
}

public extension String {
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        while searchStartIndex < self.endIndex,
              let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
              !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        return indices
    }
}

public extension RangeReplaceableCollection where Element: Hashable {
    var squeezed: Self {
        var set = Set<Element>()
        return filter{ set.insert($0).inserted }
    }
}

public extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
}
