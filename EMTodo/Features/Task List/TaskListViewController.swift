
import UIKit
import SnapKit

class TaskListViewController: UIViewController, Coordinatable, TaskListPresenterDelegate, UISearchResultsUpdating {
    
    var coordinator: (any Coordinator)?
    var model: TaskListModel
    
    var taskListPresenter: TaskListPresenter = TaskListTableView()
    var toolbar = UIToolbar()
    var toolbarLabel = UILabel()
    var tasks: [TodoTask] = []
    
    init(model: TaskListModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        setupObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTaskListPresenter()
        setupToolbar()
        setupToolbarLabel()
        setupSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadTasks()
    }
    
    private func reloadTasks() {
        model.getAllTasks { [weak self] tasks in
            let items = tasks.map { TaskListItem(todoTask: $0) }
            self?.taskListPresenter.setTasks(items)
            self?.updateTasksCountLabel(count: tasks.count)
            self?.tasks = tasks
        }
    }
    
    //MARK: - TaskList Presenter
    private func setupTaskListPresenter() {
        view.addSubview(taskListPresenter)
        taskListPresenter.translatesAutoresizingMaskIntoConstraints = false
        taskListPresenter.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        taskListPresenter.taskDelegate = self
        
    }
    
    func taskListPresenter(didChangeCompletion task: TaskListItem) {
        model.updateTaskCompleted(task.id, isCompleted: task.isDone, completion: nil)
    }
    
    func taskListPresenter(didDelete task: TaskListItem) {
        model.removeTask(task.id, completion: nil)
        updateTasksCountLabel()
    }
    
    func taskListPresenter(requestToEdit task: TaskListItem) {
        coordinator?.goToEditTaskViewController(id: task.id, animated: true)
    }
    
    func taskListPresenter(requestToShare task: TaskListItem) {
        let text = model.getTaskShareText(task.todoTask)
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
    
    //MARK: - Toolbar
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
    
    //На 2 функции разделил, чтобы можно было обновлять без повторного запроса, например при reloadTasks
    private func updateTasksCountLabel() {
        model.getAllTasks { [weak self] tasks in
            self?.updateTasksCountLabel(count: tasks.count)
        }
    }
    
    private func updateTasksCountLabel(count: Int) {
        let text = model.getTasksCountTitle(count)
        toolbarLabel.text = text
    }
    
    @objc
    private func addNewTask() {
        coordinator?.goToAddTaskViewController(animated: true)
    }
    
    //MARK: SearchController
    private func setupSearchController() {
        let controller = UISearchController()
        controller.searchResultsUpdater = self
        controller.searchBar.placeholder = "Поиск"
        controller.hidesBottomBarWhenPushed = false
        controller.scopeBarActivation = .onSearchActivation
        controller.searchBar.scopeButtonTitles = ["Все", "Выполненные", "Не выполненные"]
        self.navigationItem.searchController = controller
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let filterTypes: [TaskFilterType] = [.all, .completed, .uncompleted]
        let selectedScope = searchController.searchBar.selectedScopeButtonIndex
        let type = filterTypes[selectedScope]
        let text = searchController.searchBar.text ?? ""
        let taskItems = model.getFilteredTasks(word: text, filterType: type, tasks: tasks).map { TaskListItem(todoTask: $0) }
        taskListPresenter.setTasks(taskItems)
        updateTasksCountLabel(count: taskItems.count)
    }
    
    //MARK: - Initial Task Observer
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(initialTaskLoaded), name: SceneDelegate.taskLoadedNotificationName, object: nil)
    }
    
    @objc
    private func initialTaskLoaded() {
        reloadTasks()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension TaskListItem {
    init(todoTask: TodoTask) {
        self.init()
        self.id = todoTask.id
        self.title = todoTask.title
        self.taskDescription = todoTask.taskDescription
        self.subTitle = getSubTitle(date: todoTask.date)
        self.isDone = todoTask.isDone

    }
    
    var todoTask: TodoTask {
        TodoTask(id: id, title: title, taskDescription: taskDescription, isDone: isDone, date: getDate())
    }
    
    private func getSubTitle(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    private func getDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: subTitle) ?? Date()
    }
    
}
