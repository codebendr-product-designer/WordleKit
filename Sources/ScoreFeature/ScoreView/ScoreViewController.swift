import UIKit
import WordleKit
import ScoreClient
import UIKit
import Combine
import Foundation
import Helpers
import SwiftUI

public extension WordleKit {
    class ScoreViewController: UIViewController {
        typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Scores.Score>
        enum Section {
            case main
        }
        
        var viewModel: AppViewModel
        private var cancellables = Set<AnyCancellable>()
        private var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        var dataSource: DiffableDataSource! = nil
        var collectionView = UICollectionView()
        
        public  init(
            _ viewModel: AppViewModel
        ) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
            
            self.viewModel.$scores
                .removeDuplicates()
                .sink { score in
                    var snapshot = NSDiffableDataSourceSnapshot<Section, WordleKit.Scores.Score>()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(score)
                    self.dataSource.apply(snapshot, animatingDifferences: true)
                }
                .store(in: &cancellables)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            self.navigationItem.title = "Scores"
            
        }
    }
}

public extension WordleKit.ScoreViewController {
    private func createLayout() -> UICollectionViewLayout {
        config.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .systemBackground : .white
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        config.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .systemBackground : .white
    }
}

public extension WordleKit.ScoreViewController {
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, WordleKit.Scores.Score> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.word.firstUppercased
            content.textProperties.font = .systemFont(ofSize: 30, weight: .semibold)
            content.secondaryText = item.tries.joined(separator: " ")
            content.secondaryTextProperties.font = .systemFont(ofSize: 17, weight: .medium)
            content.secondaryTextProperties.color = .systemIndigo
            let backgroundView = UIView(frame: cell.frame)
            backgroundView.backgroundColor = .secondarySystemBackground
            
            cell.backgroundView = backgroundView
            cell.accessories = [.disclosureIndicator(options: .init(tintColor: .systemIndigo))]
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, WordleKit.Scores.Score>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: WordleKit.Scores.Score) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
    }
}

extension WordleKit.ScoreViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let _ = dataSource.itemIdentifier(for: indexPath) else { return }
        
    }
}

//public extension WordleKit {
//struct ViewControllerPreview: UIViewControllerRepresentable {
//    typealias UIViewControllerType = ScoreViewController
//
//    func makeUIViewController(context: Context) -> ScoreViewController {
//        .init(.init(scoreClient: .))
//    }
//
//    func updateUIViewController(_ uiViewController: ScoreViewController, context: Context) {}
//
//}
//}
//@available(iOS 13.0, *)
//struct ViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        WordleKit.ViewControllerPreview()
//            .ignoresSafeArea()
//    }
//}



