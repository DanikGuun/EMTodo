
import Foundation
@testable import EMTodo

class MockTaskManager: TaskManager {
    
    var tasks: [TodoTask]
    
    init(tasks: [TodoTask]) {
        self.tasks = tasks
    }
    
    func add(_ task: TodoTask, completion: Compelition) {
        tasks.append(task)
        completion?(.success(task))
    }
    
    func remove(id: UUID, completion: Compelition) {
        guard let task = tasks.first(where: { $0.id == id }) else { completion?(.failure(NSError())); return }
        tasks.removeAll(where: { $0.id == id })
        completion?(.success(task))
    }
    
    func update(id: UUID, task: TodoTask, completion: Compelition) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { completion?(.failure(NSError())); return }
        tasks[index] = task
        completion?(.success(tasks[index]))
    }
    
    func get(id: UUID, completion: Compelition) {
        guard let task = tasks.first(where: { $0.id == id }) else { completion?(.failure(NSError())); return }
        completion?(.success(task))
    }
    
    func getAll(completion: CompelitionArray) {
        completion?(.success(tasks))
    }
    
    
}
