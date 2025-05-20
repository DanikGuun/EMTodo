
import Foundation

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
    
    func makeDatePickerViewController(startDate: Date, callback: @escaping (Date) -> Void) -> any Coordinatable {
        let controller = DatePickerViewController()
        controller.callback = callback
        controller.datePicker.date = startDate
        return controller
    }
    
}
