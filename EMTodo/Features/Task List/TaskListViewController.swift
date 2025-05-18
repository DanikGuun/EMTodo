
import UIKit
import SnapKit

class TaskListViewController: UIViewController, Coordinatable {
    var coordinator: (any Coordinator)?
    var taskListPresenter: TaskListPresenter = TaskListTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTaskListPresenter()
    }
    
    private func setupTaskListPresenter() {
        view.addSubview(taskListPresenter)
        taskListPresenter.translatesAutoresizingMaskIntoConstraints = false
        
        taskListPresenter.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        taskListPresenter.setTasks([TaskListItem(), TaskListItem(), TaskListItem(), TaskListItem(), TaskListItem()])
    }
    
}
