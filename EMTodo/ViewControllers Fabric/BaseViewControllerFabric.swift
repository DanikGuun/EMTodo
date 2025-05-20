
class BaseViewControllerFabric: ViewControllersFabric {
    func makeTaskListViewController() -> any Coordinatable {
        return TaskListViewController()
    }
    
    func makeAddTaskViewController() -> any Coordinatable {
        return TaskEditingViewController()
    }
    
    func makeEditTaskViewController(task: ToDoTask) -> any Coordinatable {
        return TaskEditingViewController()
    }
    
}
