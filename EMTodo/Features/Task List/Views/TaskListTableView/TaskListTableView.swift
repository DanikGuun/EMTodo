
import UIKit

class TaskListTableView: UITableView, TaskListPresenter, UITableViewDelegate {
    
    var isDoneUpdated: ((UUID) -> Void)?
    private var diffableDataSource: UITableViewDiffableDataSource<UUID, UUID>!
    private var items: [TaskListItem] = []
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        self.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.delegate = self
        self.estimatedRowHeight = DC.cellHeight
        setupDiffableDataSource()
        reloadSnapshot()
        self.selectionFollowsFocus = false
    }
    
    private func setupDiffableDataSource() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: self, cellProvider: { [weak self] (tableView, indexPath, id) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            if let item = self?.items.first(where: { $0.id == id }) {
                var conf = TaskListTableContentConfiguration()
                conf.title = item.title
                conf.taskDescription = item.taskDescription
                conf.subtitle = item.subTitle
                conf.isDone = item.isDone
                cell.contentConfiguration = conf
            }
            cell.selectionStyle = .none
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Удалить", handler: { [weak self] (action, view, completion) in
            self?.removeCellAndItem(indexPath)
            completion(true)
        })
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let conf = UISwipeActionsConfiguration(actions: [deleteAction])
        return conf
    }
    
    private func removeCellAndItem(_ indexPath: IndexPath) {
        guard let id = diffableDataSource.itemIdentifier(for: indexPath) else { return }
        items.removeAll(where: { $0.id == id })
        var snapshot = diffableDataSource.snapshot()
        snapshot.deleteItems([id])
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let id = diffableDataSource.itemIdentifier(for: indexPath) else { return }
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].isDone.toggle()
        
        DispatchQueue.main.async { [weak self] in //откладываем на следующий RunLoop, тк CABasicAnimation конфликтует с анимацией выделения ячейки
            guard let cell = self?.cellForRow(at: indexPath) else { return }
            guard var conf = cell.contentConfiguration as? TaskListTableContentConfiguration else { return }
            conf.isDone.toggle()
            cell.contentConfiguration = conf
        }
    }
    
}
