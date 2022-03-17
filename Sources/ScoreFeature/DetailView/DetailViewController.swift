import UIKit

class DetailViewController: UIViewController {
    private var tries: [Tries]
    
    enum Section {
        case main
    }
    
    init(tries: [Tries]) {
        self.tries = tries
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Tries>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureHierarchy()
//        configureDataSource()
    }
}
