
import Foundation

class InitialTaskLoader {
    
    func loadInitialTasks(completion: @escaping ([TodoTask]) -> Void) {

        let url = URL(string: "https://dummyjson.com/todos")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion([])
                return
            }
            
            let tasks = InitialTaskLoader.makeTodoTasks(data: data)
            completion(tasks)
        }
        
        task.resume()
    }
    
    private static func makeTodoTasks(data: Data?) -> [TodoTask] {
        guard let data = data else { return [] }
        guard let jsonTasks = try? JSONDecoder().decode(InitialTasksJson.self, from: data) else { return [] }
        return makeTodoTasks(jsonTasks)
    }
    
    private static func makeTodoTasks(_ jsonTasks: InitialTasksJson) -> [TodoTask] {
        var todoTasks: [TodoTask] = []
        for task in jsonTasks.todos {
            let todoTask = TodoTask(title: task.todo, isDone: task.completed)
            todoTasks.append(todoTask)
        }
        return todoTasks
    }
    
}

fileprivate struct InitialTasksJson: Decodable {
    let todos: [JsonTask]
}

fileprivate struct JsonTask: Decodable {
    let todo: String
    let completed: Bool
}
