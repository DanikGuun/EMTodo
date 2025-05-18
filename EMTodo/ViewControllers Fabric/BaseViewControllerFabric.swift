
class BaseViewControllerFabric: ViewControllersFabric {
    func makeTaskListViewController() -> any Coordinatable {
        return ViewController()
    }
    
    func makeAddTaskViewController() -> any Coordinatable {
        return ViewController()
    }
    
    func makeEditTaskViewController(task: ToDoTask) -> any Coordinatable {
        return ViewController()
    }
    
}
