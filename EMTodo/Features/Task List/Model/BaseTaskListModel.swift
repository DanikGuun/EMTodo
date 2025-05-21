import Foundation

class BaseTaskListModel: TaskListModel {
    
    let taskManager: TaskManager
    
    init(taskManager: TaskManager) {
        self.taskManager = taskManager
    }
    
    func getAllTasks(completion: CompletionArray) {
        taskManager.getAll { result in
            switch result{
            case .success(let tasks): completion?(tasks.sorted(by: { $0.date < $1.date } ))
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
    
    func getTaskShareText(_ task: TodoTask) -> String {
        var text = "Привет! Это моё новое задание - \(task.title)"
        if task.taskDescription.isEmpty == false {
            text.append("\nКонкретно надо \(task.taskDescription)")
        }
        text.append("\nКрайний срок: \(task.date.formatted(date: .long, time: .omitted))")
        text.append("\nЯ его \(task.isDone ? "уже" : "ещё не") сделал))")
        return text
    }
    
    func getTasksCountTitle(_ count: Int) -> String {
        var text = "\(count) Задач"
        let lastNumber = count % 10
        switch lastNumber {
        case 1: text += "а"
        case 2, 3, 4: text += "и"
        default: break
        }
        return text
    }
    
    func getFilteredTasks(word: String, filterType: TaskFilterType, tasks: [TodoTask]) -> [TodoTask] {
        let tasks = tasks.filter {
            switch filterType {
            case .all: return true
            case .completed: return $0.isDone
            case .uncompleted: return !$0.isDone
            }
        }
        if word.isEmpty { return tasks }
        return tasks.filter { task in
            let title = task.title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let description = task.taskDescription.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let word = word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            return title.contains(word) || description.contains(word)
        }
    }
    
}
