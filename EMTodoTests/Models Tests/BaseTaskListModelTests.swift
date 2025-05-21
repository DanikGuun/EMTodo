

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
    
    func testGetFilteredTasks_AllFilter() {
        let filteredTasks = model.getFilteredTasks(word: "", filterType: .all, tasks: tasks)
        XCTAssertEqual(filteredTasks, tasks)
    }
    
    func testGetFilteredTasks_CompletedFilter() {
        let filteredTasks = model.getFilteredTasks(word: "", filterType: .completed, tasks: tasks)
        let expectedTasks = tasks.filter { $0.isDone }
        XCTAssertEqual(filteredTasks, expectedTasks)
    }
    
    func testGetFilteredTasks_UncompletedFilter() {
        let filteredTasks = model.getFilteredTasks(word: "", filterType: .uncompleted, tasks: tasks)
        let expectedTasks = tasks.filter { !$0.isDone }
        XCTAssertEqual(filteredTasks, expectedTasks)
    }
    
    func testGetFilteredTasks_WithSearchWord() {
        let filteredTasks = model.getFilteredTasks(word: "test 1", filterType: .all, tasks: tasks)
        let expectedTasks = tasks.filter { $0.title.lowercased().contains("test 1") }
        XCTAssertEqual(filteredTasks, expectedTasks)
    }
    
    func testGetFilteredTasks_WithSearchWordAndCompletedFilter() {
        let filteredTasks = model.getFilteredTasks(word: "test", filterType: .completed, tasks: tasks)
        let expectedTasks = tasks.filter { $0.isDone && $0.title.lowercased().contains("test") }
        XCTAssertEqual(filteredTasks, expectedTasks)
    }
    
}
