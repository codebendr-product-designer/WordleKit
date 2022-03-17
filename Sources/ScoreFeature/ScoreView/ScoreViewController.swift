import UIKit
import WordleKit
import ScoreClient
import UIKit
import Combine
import Foundation
import Helpers
import SwiftUI
import Animations

public extension WordleKit {
    class ScoreViewController: UIViewController {
        typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Scores.Score>
        typealias DiffableSnapshot =  NSDiffableDataSourceSnapshot<Section, Scores.Score>
        enum Section {
            case main
        }
        
        @ObservedObject var viewModel: AppViewModel
        private var cancellables = Set<AnyCancellable>()
        private var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        private var dataSource: DiffableDataSource! = nil
        private var collectionView: UICollectionView! = nil
        private let transitionDelegate = TransitionDelegate()
        
        public  init(
            _ viewModel: AppViewModel
        ) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            navigationItem.title = "Scores"
            
            configureHierarchy()
            configureDataSource()
            
            self.transitioningDelegate = transitionDelegate
            
            self.viewModel.$scores
                .removeDuplicates()
                .sink { score in
                    var snapshot = DiffableSnapshot()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(score)
                    self.dataSource.apply(snapshot, animatingDifferences: true)
                }
                .store(in: &cancellables)
            
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
        
        dataSource = DiffableDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: WordleKit.Scores.Score) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
    }
}

extension WordleKit.ScoreViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let score = dataSource.itemIdentifier(for: indexPath) else { return }
        let detail = WordleKit.DetailViewController(
            tries: viewModel.tries(score)
        )
        
#warning("weird behavior, view dismissal fires once when this is not called. is this related to loadViewIfNeeded()")
        let _ = detail.view!
        
        detail.transitioningDelegate = transitioningDelegate
        self.navigationController?.navigationItem.title = score.word
        self.navigationController?.present(detail, animated: true) { [weak self] in
            let cardViewController = WordleKit.CardViewController(totalScores: self?.viewModel.totalScore ?? 0)
            detail.add(cardViewController)
        }
        
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



