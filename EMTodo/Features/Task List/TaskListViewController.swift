
import UIKit
import SnapKit

class TaskListViewController: UIViewController, Coordinatable {
    var coordinator: (any Coordinator)?
    var taskListPresenter: TaskListPresenter = TaskListTableView()
    var toolbar = UIToolbar()
    var toolbarLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTaskListPresenter()
        setupToolbar()
        setupToolbarLabel()
    }
    
    static let taskNames: [String] = ["Task 1", "Task 2", "Task 3", "Task 4", "Task 5"]
    static let taskDescriptions: [String] = ["Description 1", "Description 2", "Description 3", "Descriptiogjlsahdhfjajksdhfk;jadshdgfkjasdhgkjadhfkjvhrbfnijv ljersfdnbveagrjklshbgnre;io'jgklsdcjflkadsjgkleryionvuacmpxtighwertpx,oghwcorimvgnhn 4", "Description 5"]
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
        
        self.taskListPresenter.setTasks(tasks)

    }
    
    private func setupToolbar() {
        view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        toolbar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let addButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addNewTask))
        toolbar.items = [space, addButton]
    }
    
    private func setupToolbarLabel() {
        toolbar.addSubview(toolbarLabel)
        toolbarLabel.translatesAutoresizingMaskIntoConstraints = false
        toolbarLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.leading.trailing.equalTo(self.toolbar).inset(15).priority(.high)
        }
        toolbarLabel.textAlignment = .center
        toolbarLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        toolbarLabel.textColor = .secondaryLabel
    }
    
    @objc
    private func addNewTask() {
        coordinator?.goToAddTaskViewController(animated: true)
    }
    
}
