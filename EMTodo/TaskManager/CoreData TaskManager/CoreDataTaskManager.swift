
import CoreData

class CoreDataTaskManager: TaskManager {
    
    typealias ResultTask = Result<TodoTask?, Error>
    typealias ResultTaskArray = Result<[TodoTask], Error>
    typealias Completion = ((ResultTask) -> Void)?
    typealias CompletionArray = ((ResultTaskArray) -> Void)?
    
    var container: NSPersistentContainer!
    var context: NSManagedObjectContext { container.viewContext }
    private let queue = DispatchQueue(label: "CoreDataQueue", qos: .userInitiated)
    
    init(persistentStoreDescriptions: [NSPersistentStoreDescription]? = nil) {
        setupContainer(persistentStoreDescriptions: persistentStoreDescriptions)
    }
    
    private func setupContainer(persistentStoreDescriptions: [NSPersistentStoreDescription]? = nil) {
        container = NSPersistentContainer(name: "EMTodo")
        if let descriptions = persistentStoreDescriptions, descriptions.isEmpty == false {
            container.persistentStoreDescriptions = descriptions
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Failed To Load Persistent Stores: \(error)")
            }
        }
    }
    
    private func saveContext() {
        let context = self.context
        
        if context.hasChanges {
            do { try context.save() }
            catch { print("Failed To Save Context: \(error)") }
        }
    }
    
    func add(_ task: TodoTask, completion: Completion = nil) {
        asyncCompletionTask(completion) { [weak self] in
            guard let self else { return nil }
            let entity = NSEntityDescription.entity(forEntityName: "CDTodoTask", in: self.context)!
            self.context.perform {
                let managedTask = CDTodoTask(entity: entity, insertInto: self.context)
                managedTask.copyValues(from: task)
                self.saveContext()
            }
            return task
        }
    }
    
    func getAll(completion: CompletionArray) {
        asyncCompletionTask(completion) { [weak self] in
            guard let self else { return [] }
            
            var tasks: [TodoTask] = []
            for task in try self.getCDTasks() {
                tasks.append(task.toDoTask)
            }
            return tasks
        }
    }
    
    func update(id: UUID, task newTask: TodoTask, completion: Completion = nil) {
        asyncCompletionTask(completion) { [weak self] in
            guard let self else { return nil }
            
            let task = try self.getCDTasks().first(where: { $0.id == id })
            self.context.performAndWait {
                task?.copyValues(from: newTask, withoutID: true)
                self.saveContext()
            }
            return task?.toDoTask
            
        }
    }
    
    func get(id: UUID, completion: Completion = nil) {
        asyncCompletionTask(completion) { [weak self] in
            guard let self else { return nil }
            return try self.getCDTasks().first(where: { $0.id == id })?.toDoTask
        }
    }
    
    func remove(id: UUID, completion: Completion = nil) {
        asyncCompletionTask(completion) { [weak self] in
            guard let self else { return nil }
            
            guard let task = try self.getCDTasks().first(where: { $0.id == id } ) else { return nil }
            let taskToReturn = task.toDoTask
            self.context.performAndWait {
                self.context.delete(task)
                self.saveContext()
            }
            return taskToReturn
            
        }
    }

    func removeAll(completion: CompletionArray = nil) {
        asyncCompletionTask(completion) { [weak self] in
            guard let self else { return [] }
            
            let tasks = try self.getCDTasks()
            let deletedTasks: [TodoTask] = tasks.compactMap { $0.toDoTask }
            
            self.context.perform {
                for task in tasks {
                    self.context.delete(task)
                }
                self.saveContext()
            }
            return deletedTasks
        }

    }
    
    private func asyncCompletionTask<T>(_ completion: ((Result<T, Error>) -> ())? = nil, _ closure: @escaping (() throws -> T)) {
        queue.async {
            var result: Result<T, Error> = .failure(NSError(domain: "AsyncCompletionTaskResultError", code: 404, userInfo: nil))
            do {
                let data = try closure()
                result = .success(data)
            }
            catch { result = .failure(error) }
            
            DispatchQueue.main.sync {
                completion?(result)
            }
        }
    }
    
    private func getCDTasks() throws -> [CDTodoTask] {
        try context.performAndWait {
            let request = CDTodoTask.fetchRequest()
            return try context.fetch(request)
        }
    }
    
}

fileprivate extension CDTodoTask {
    var toDoTask: TodoTask {
        return TodoTask(id: id, title: title, taskDescription: taskDescription, isDone: isDone, date: date)
    }
}
