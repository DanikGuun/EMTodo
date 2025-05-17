
import Foundation

protocol TaskManager {
    typealias Compelition = ((Result<ToDoTask, Error>) -> Void)?
    
    func add(_ task: ToDoTask, compeletion: Compelition)
    func remove(id: UUID, compelition: Compelition)
    func update(id: UUID, task: ToDoTask, compelition: Compelition)
    func get(id: UUID, compelition: Compelition)
    func getAll(compeletion: ((Result<[ToDoTask], Error>) -> Void)?)
}

struct ToDoTask: Equatable {
    var id: UUID
    var title: String
    var taskDescription: String
    var isDone: Bool
    var date: Date
    
    init(id: UUID = UUID(), title: String = "", taskDescription: String = "", isDone: Bool = false, date: Date = Date()) {
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
        self.isDone = isDone
        self.date = date
    }
}
