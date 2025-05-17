
import Foundation

protocol TaskManager {
    typealias Compelition = ((Result<ToDoTask?, Error>) -> Void)?
    typealias CompelitionArray = ((Result<[ToDoTask], Error>) -> Void)?
    
    func add(_ task: ToDoTask, completion: Compelition)
    func remove(id: UUID, completion: Compelition)
    func update(id: UUID, task: ToDoTask, completion: Compelition)
    func get(id: UUID, completion: Compelition)
    func getAll(completion: ((Result<[ToDoTask], Error>) -> Void)?)
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
