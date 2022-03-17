import UIKit
import WordleKit
import SwiftUI

#warning("extract extension to custom views")
public extension WordleKit {
    class DetailViewController: UIViewController {
        private var tries: [Tries]
        
        enum Section {
            case main
        }
        
        public init(tries: [Tries]) {
            self.tries = tries
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var dataSource: UICollectionViewDiffableDataSource<Section, Tries>! = nil
        var collectionView: UICollectionView! = nil
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            configureHierarchy()
            configureDataSource()
        }
    }
}

extension WordleKit.DetailViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 6
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension WordleKit.DetailViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<DetailViewCell, Tries> { (cell, indexPath, identifier) in
            cell.label.text = "\(identifier.character.uppercased())"
            switch identifier.type {
            case 1:
                cell.backgroundColor = .systemYellow
            case 2:
                cell.backgroundColor = .systemGreen
            default:
                cell.backgroundColor = .secondarySystemBackground
            }
            cell.layer.cornerRadius = 15
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.systemGray6.cgColor
            cell.label.textAlignment = .center
            cell.label.font = .systemFont(ofSize: 35, weight: .semibold)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Tries>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Tries) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Tries>()
        snapshot.appendSections([.main])
        snapshot.appendItems(tries)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension WordleKit.DetailViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//extension WordleKit.DetailViewController {
//    struct DetailViewControllerPreview: UIViewControllerRepresentable {
//        typealias UIViewControllerType = DetailViewController
//
//        func makeUIViewController(context: Context) -> DetailViewController {
//            DetailViewController(tries:([]))
//        }
//
//        func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {}
//
//    }
//}
//
//
//@available(iOS 13.0, *)
//struct DetailViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        WordleKit.DetailViewControllerPreview()
//            .ignoresSafeArea()
//    }
//}
