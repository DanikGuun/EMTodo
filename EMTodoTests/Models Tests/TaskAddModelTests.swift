

import XCTest
@testable import EMTodo

final class TaskAddModelTests: XCTestCase {
    
    var model: TaskAddModel!
    var taskManager: MockTaskManager!
    let tasks: [TodoTask] = [
        TodoTask(id: UUID(), title: "Test 1", isDone: false),
        TodoTask(id: UUID(), title: "Test 2", isDone: true),
        TodoTask(id: UUID(), title: "Test 3", isDone: false)
    ]
    
    override func setUp() {
        taskManager = MockTaskManager(tasks: tasks)
        model = TaskAddModel(taskManager: taskManager)
        super.setUp()
    }
    
    override func tearDown() {
        taskManager = nil
        model = nil
        super.tearDown()
    }
    
    func testEmptyInitialTask() {
        let task = TodoTask()
        var initialTask: TodoTask?
        
        model.loadInitialTask { initialTask = $0 }
        
        XCTAssertNotNil(initialTask)
        XCTAssertEqual(initialTask!.title, task.title)
        XCTAssertEqual(initialTask!.taskDescription, task.taskDescription)
        XCTAssertEqual(initialTask!.isDone, task.isDone)
    }
    
    func testAddPerform() {
        let id = UUID()
        let newTask = TodoTask(id: id, title: "NewTask")
        var fetchedNewTask: TodoTask?
        
        model.perform(task: newTask)
        taskManager.get(id: id) { result in
            switch result {
            case .success(let task): fetchedNewTask = task
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            
        }
        XCTAssertNotNil(fetchedNewTask)
        XCTAssertEqual(fetchedNewTask!.title, newTask.title)
    }
    
}
