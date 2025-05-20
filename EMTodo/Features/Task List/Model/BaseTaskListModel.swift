import Foundation

class BaseTaskListModel: TaskListModel {
    let taskManager: TaskManager
    
    init(taskManager: TaskManager) {
        self.taskManager = taskManager
    }
    
    func getAllTasks(completion: CompletionArray) {
        taskManager.getAll { result in
            switch result{
            case .success(let tasks): completion?(tasks)
            case .failure(_): completion?([])
            }
        }
    }
    
    func updateTaskCompleted(_ id: UUID, isCompleted: Bool, completion: Completion) {
        taskManager.get(id: id) { [weak self] result in
            switch result {
            case .success(let task): self?.updateTask(task: task, isCompleted: isCompleted, completion: completion)
            case .failure(_): completion?(nil)
            }
        }
    }
    
    private func updateTask(task: TodoTask?, isCompleted: Bool, completion: Completion) {
        guard var task = task else { completion?(nil); return }
        task.isDone = isCompleted
        
        taskManager.update(id: task.id, task: task) { result in
            switch result {
            case .success(let task): completion?(task)
            case .failure(_): completion?(nil)
            }
        }
    }
    
    func removeTask(_ id: UUID, completion: Completion) {
        taskManager.remove(id: id) { result in
            switch result {
            case .success(let task): completion?(task)
            case .failure(_): completion?(nil)
            }
        }
    }
    
    
}
