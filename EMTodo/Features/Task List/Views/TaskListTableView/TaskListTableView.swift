
import UIKit

class TaskListTableView: UICollectionView, TaskListPresenter {
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<UUID, UUID>!
    private var items: [TaskListItem] = []
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: Self.makeLayout())
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        setupDiffableDataSource()
        reloadSnapshot()
    }
    
    private func setupDiffableDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: self, cellProvider: { (collection, indexPath, id) in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.contentConfiguration = TaskListTableContentConfiguration()
            return cell
        })
    }
    
    func setTasks(_ tasks: [TaskListItem]) {
        items = tasks
        reloadSnapshot()
    }
    
    private func reloadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems(items.map { $0.id })
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let conf = UICollectionLayoutListConfiguration(appearance: .plain)
    
        let layout = UICollectionViewCompositionalLayout.list(using: conf)
        
        return layout
    }
    
}
