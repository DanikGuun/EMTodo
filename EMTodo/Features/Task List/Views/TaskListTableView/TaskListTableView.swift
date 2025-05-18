
import UIKit

class TaskListTableView: UITableView, TaskListPresenter, UITableViewDelegate {
    
    private var diffableDataSource: UITableViewDiffableDataSource<UUID, UUID>!
    private var items: [TaskListItem] = []
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        self.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.delegate = self
        self.rowHeight = DC.cellHeight
        setupDiffableDataSource()
        reloadSnapshot()
    }
    
    private func setupDiffableDataSource() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: self, cellProvider: { (tableView, indexPath, id) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.contentConfiguration = TaskListTableContentConfiguration(title: "Title", taskDescription: "sla;djflasdjflkjasl;kdjforengadfkjloadkjsfloi94utghou4397uho'hsdjfsxa/fnk34toihreoiw", subtitle: "Subtitle")
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
        let deleteAction = UIContextualAction(style: .normal, title: "Удалить", handler: { (action, view, completion) in
            completion(true)
        })
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let conf = UISwipeActionsConfiguration(actions: [deleteAction])
        return conf
    }
    
}
