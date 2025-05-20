
import Foundation

class BaseModelsFactory: ModelsFactory {
    
    let taskManager: TaskManager
    
    init(taskManager: TaskManager) {
        self.taskManager = taskManager
    }
    
    func createTasksListModel() -> any TaskListModel {
        return BaseTaskListModel(taskManager: taskManager)
    }
    
    func createTaskAddModel() -> any TaskEditingModel {
        return TaskAddModel(taskManager: taskManager)
    }
    
    func createTaskEditModel(id: UUID) -> any TaskEditingModel {
        return TaskEditModel(taskId: id, taskManager: taskManager)
    }
    
    
}
