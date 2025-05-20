
import Foundation

class BaseViewControllerFactory: ViewControllersFactory {
    
    var modelsFactory: ModelsFactory
    
    init(modelsFactory: ModelsFactory) {
        self.modelsFactory = modelsFactory
    }
    
    func makeTaskListViewController() -> any Coordinatable {
        let model = modelsFactory.createTasksListModel()
        return TaskListViewController(model: model)
    }
    
    func makeAddTaskViewController() -> any Coordinatable {
        let model = modelsFactory.createTaskAddModel()
        return TaskEditingViewController(model: model)
    }
    
    func makeEditTaskViewController(id: UUID) -> any Coordinatable {
        let model = modelsFactory.createTaskEditModel(id: id)
        return TaskEditingViewController(model: model)
    }
    
    func makeDatePickerViewController(startDate: Date, callback: @escaping (Date) -> Void) -> any Coordinatable {
        let controller = DatePickerViewController()
        controller.callback = callback
        controller.datePicker.date = startDate
        return controller
    }
    
}
