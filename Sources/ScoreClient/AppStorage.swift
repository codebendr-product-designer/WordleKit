import WordleKit
import Foundation

public extension WordleKit {
    
#warning("can use property wrapper feature?")
    final class AppStorage {
        private var defaults: UserDefaults
        
        init(){
            defaults = UserDefaults.standard
        }
        
        public static let shared = AppStorage()
        public var scores: [Scores.Score] {
            get {
                guard let saved = defaults.object(forKey: "scores") as? Data else { return [] }
                guard let data = try? JSONDecoder().decode([Scores.Score].self, from: saved) else { return [] }
                return data
            }
            set {
                guard let save = try? JSONEncoder().encode(newValue) else { return }
                defaults.set(save, forKey: "scores")
            }
        }
        
    }
}
