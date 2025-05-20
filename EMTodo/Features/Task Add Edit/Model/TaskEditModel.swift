
import Foundation

class TaskEditModel: TaskEditingModel {
    
    let taskManager: TaskManager
    let taskId: UUID
    
    init(taskId: UUID, taskManager: TaskManager) {
        self.taskManager = taskManager
        self.taskId = taskId
    }
    
    func perform(task: TodoTask) {
        taskManager.update(id: taskId, task: task, completion: nil)
    }
    
    func loadInitialTask(completion: Completion) {
        taskManager.get(id: taskId) { result in
            switch result {
            case .success(let task): completion?(task ?? TodoTask())
            case .failure: completion?(TodoTask())
            }
        }
    }
    
    
}
