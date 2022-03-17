import Foundation

public struct Tries: Hashable {
    let id = UUID()
    var character: Character
    var type: Int
    
    public init(_ character: Character = .init(" "), _ type: Int = 0) {
        self.character = character
        self.type = type
    }
}
