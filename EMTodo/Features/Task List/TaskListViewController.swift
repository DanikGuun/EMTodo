
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
    
    static let taskNames: [String] = ["Task 1", "Task 2", "Task 3", "Task 4", "Task 5"]
    static let taskDescriptions: [String] = ["Description 1", "Description 2", "Description 3", "Description 4", "Description 5"]
    static let tasksubtitles: [String] = ["Subtitle 1", "Subtitle 2", "Subtitle 3", "Subtitle 4", "Subtitle 5"]
    static let bools: [Bool] = [true, false, true, false, true]
    var tasks = (0..<10).map { _ in return TaskListItem(id: UUID(), title: taskNames.randomElement()!, taskDescription: taskDescriptions.randomElement()!, isDone: bools.randomElement()!, subtitle: tasksubtitles.randomElement()!) }
    
    
    private func setupTaskListPresenter() {
        view.addSubview(taskListPresenter)
        taskListPresenter.translatesAutoresizingMaskIntoConstraints = false
        
        taskListPresenter.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        taskListPresenter.setTasks(tasks)
    }
    
}
