
import CoreData

class CoreDataTaskManager {
    typealias ResultTask = Result<ToDoTask?, Error>
    typealias ResultTaskArray = Result<[ToDoTask], Error>
    typealias Compeletion = ((ResultTask) -> Void)?
    typealias CompeletionArray = ((ResultTaskArray) -> Void)?
    
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
    
    func add(_ task: ToDoTask, completion: Compeletion = nil) {
        let entity = NSEntityDescription.entity(forEntityName: "CDTodoTask", in: self.context)!
        queue.async { [weak self] in
            guard let self else { return }
            self.context.perform {
                let managedTask = CDTodoTask(entity: entity, insertInto: self.context)
                managedTask.copyValues(from: task)
                self.saveContext()
            }
            DispatchQueue.main.sync {
                completion?(.success(task))
            }
        }
    }
    
    func getAll(completion: CompeletionArray) {
        queue.async { [weak self] in
            guard let self else { return }
            var result: Result<[ToDoTask], Error>;
            
            do{
                var tasks: [ToDoTask] = []
                for task in try getCDTasks() {
                    let toDoTask = ToDoTask(task: task)
                    tasks.append(toDoTask)
                }
                result = .success(tasks)
            }
            catch { result = .failure(error) }
            
            DispatchQueue.main.sync {
                completion?(result)
            }
        }
    }
    
    func update(_ id: UUID, with newTask: ToDoTask, completion: Compeletion = nil) {
        queue.async { [weak self] in
            var result: ResultTask = .success(nil)
            guard let self else { return }
            do {
                for task in try self.getCDTasks() {
                    if task.id == id {
                        context.perform {
                            task.copyValues(from: newTask, withoutID: true)
                            self.saveContext()
                        }
                        let todoTask = ToDoTask(task: task)
                        result = .success(todoTask)
                        break
                    }
                }
            }
            catch { result = .failure(error) }
            DispatchQueue.main.sync {
                completion?(result)
            }
        }
    }
    
    func get(id: UUID, completion: Compeletion = nil) {
        queue.async { [weak self] in
            guard let self else { return }
            var result: Result<ToDoTask?, Error> = .success(nil)
            
            do{
                if let task = try getCDTasks().first(where: { $0.id == id }) {
                    let todoTask = ToDoTask(task: task)
                    result = .success(todoTask)
                }
            }
            catch { result = .failure(error) }
            
            DispatchQueue.main.sync {
                completion?(result)
            }
        }
    }
    
    func delete(id: UUID, completion: Compeletion = nil) {
        queue.async { [weak self] in
            guard let self else { return }
            var result: ResultTask = .success(nil)
            do {
                if let task = try getCDTasks().first(where: { $0.id == id } ) {
                    context.perform {
                        self.context.delete(task)
                        result = .success(ToDoTask(task: task))
                        self.saveContext()
                    }
                }
            }
            catch { result = .failure(error) }
            DispatchQueue.main.sync {
                completion?(result)
            }
        }
    }

    func removeAll(completion: CompeletionArray = nil) {
        queue.async { [weak self] in
            guard let self else { return }
            var result: ResultTaskArray = .success([])
            context.perform {
                do {
                    var deletedTasks: [ToDoTask] = []
                    let tasks = try self.getCDTasks()
                    for task in tasks {
                        self.context.delete(task)
                        let todoTsak = ToDoTask(task: task)
                        deletedTasks.append(todoTsak)
                    }
                    result = .success(deletedTasks)
                }
                catch { result = .failure(error) }
            }
            self.saveContext()
            DispatchQueue.main.sync {
                completion?(result)
            }
        }
    }
    
    private func getCDTasks() throws -> [CDTodoTask] {
        let request = CDTodoTask.fetchRequest()
        return try context.fetch(request)
    }
    
}

fileprivate extension ToDoTask {
    init(task: CDTodoTask) {
        self.id = task.id
        self.title = task.title
        self.taskDescription = task.taskDescription
        self.isDone = task.isDone
        self.date = task.date
    }
}
