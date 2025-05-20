
class TaskAddModel: TaskEditingModel {
    
    let taskManager: TaskManager
    
    init(taskManager: TaskManager) {
        self.taskManager = taskManager
    }
    
    func perform(task: TodoTask) {
        if task.title.isEmpty, task.taskDescription.isEmpty { return }
        taskManager.add(task, completion: nil)
    }
    
    func loadInitialTask(completion: Completion) {
        completion?(TodoTask())
    }
}
