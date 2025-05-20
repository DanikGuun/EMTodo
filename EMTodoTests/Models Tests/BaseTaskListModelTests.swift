

import XCTest
@testable import EMTodo

final class BaseTaskListModelTests: XCTestCase {
    
    var model: BaseTaskListModel!
    let tasks: [TodoTask] = [
        TodoTask(id: UUID(), title: "Test 1", isDone: false),
        TodoTask(id: UUID(), title: "Test 2", isDone: true),
        TodoTask(id: UUID(), title: "Test 3", isDone: false)
    ]
    
    override func setUp() {
        let taskManager = MockTaskManager(tasks: tasks)
        model = BaseTaskListModel(taskManager: taskManager)
        super.setUp()
    }
    
    override func tearDown() {
        model = nil
        super.tearDown()
    }
    
    func testGetAllTasks() {
        var recivedTasks: [TodoTask] = []
        
        model.getAllTasks { recivedTasks = $0 }
        
        XCTAssertEqual(recivedTasks, tasks)
    }
    
    func testDeleteTask() {
        var tasks = self.tasks
        let droppedTask = tasks.removeFirst()
        var recivedTasks: [TodoTask] = []
        
        model.removeTask(droppedTask.id, completion: nil)
        model.getAllTasks { recivedTasks = $0 }
        
        XCTAssertEqual(recivedTasks, tasks)
    }
    
    func testUpdateTask() {
        let taskToUpdate = tasks[1]
        var taskCompletion = taskToUpdate.isDone
        
        model.updateTaskCompleted(taskToUpdate.id, isCompleted: !taskToUpdate.isDone, completion: nil)
        model.getAllTasks { tasks in
            guard let task = tasks.first(where: { $0.id == taskToUpdate.id }) else { XCTFail(); return}
            taskCompletion = task.isDone
        }
        
        XCTAssertNotEqual(taskCompletion, taskToUpdate.isDone)
    }
    
}
