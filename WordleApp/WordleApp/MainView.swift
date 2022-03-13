import Foundation
import UIKit

class MainView: UIView {
    init() {
        super.init(frame: .init())
        backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
