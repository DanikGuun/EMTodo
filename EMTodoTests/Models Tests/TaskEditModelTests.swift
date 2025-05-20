

import XCTest
@testable import EMTodo

final class TaskEditModelTests: XCTestCase {
    
    var model: TaskEditModel!
    var taskManager: MockTaskManager!
    let tasks: [TodoTask] = [
        TodoTask(id: UUID(), title: "Test 1", isDone: false),
        TodoTask(id: UUID(), title: "Test 2", isDone: true),
        TodoTask(id: UUID(), title: "Test 3", isDone: false)
    ]
    
    override func setUp() {
        taskManager = MockTaskManager(tasks: tasks)
        model = TaskEditModel(taskId: tasks[0].id, taskManager: taskManager)
        super.setUp()
    }
    
    override func tearDown() {
        taskManager = nil
        model = nil
        super.tearDown()
    }
    
    func testInitialTask() {
        let task = tasks[0]
        var initialTask: TodoTask?
        
        model.loadInitialTask { initialTask = $0 }
        
        XCTAssertNotNil(initialTask)
        XCTAssertEqual(initialTask!.title, task.title)
        XCTAssertEqual(initialTask!.taskDescription, task.taskDescription)
        XCTAssertEqual(initialTask!.isDone, task.isDone)
    }
    
    func testEditPerform() {
        let id = tasks[2].id
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
