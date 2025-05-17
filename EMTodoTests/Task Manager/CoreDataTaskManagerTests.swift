

import XCTest
import CoreData
@testable import EMTodo

final class CoreDataTaskManagerTests: XCTestCase {
    
    var coreDataTM: CoreDataTaskManager!
    
    override func setUp() {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        coreDataTM = CoreDataTaskManager(persistentStoreDescriptions: [description])
        super.setUp()
    }
    
    override func tearDown() {
        coreDataTM = nil
        super.tearDown()
    }
    
    func testAddGet() {
        let expectation = expectation(description: "AddTask")
        let task = ToDoTask(id: UUID(), title: "", taskDescription: "", isDone: true, date: Date())
        var count = -1
        
        coreDataTM.add(task)
        coreDataTM.getAll { result in
            switch result{
            case .success(let tasks): count = tasks.count
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(count, 1)
    }
    
    func testGetById() {
        let task = ToDoTask(id: UUID(), title: "task", taskDescription: "", isDone: true, date: Date())
        let expectation = expectation(description: "GetTask")
        var fetchedTask: ToDoTask?
        
        for _ in 0..<10 {
            let t = ToDoTask(id: UUID(), title: "", taskDescription: "", isDone: true, date: Date())
            coreDataTM.add(t)
        }
        coreDataTM.add(task)
        coreDataTM.get(id: task.id) { result in
            switch result{
            case .success(let findTask): fetchedTask = findTask
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(task, fetchedTask)
        
    }
    
    func testUpdate() {
        let oldTask = ToDoTask(id: UUID(), title: "OldTask")
        let newTask = ToDoTask(title: "NewTask")
        var fetchedTask: ToDoTask?
        let expextation = expectation(description: "UpdateTask")
        
        coreDataTM.add(oldTask)
        coreDataTM.update(oldTask.id, with: newTask)
        coreDataTM.get(id: oldTask.id) { result in
            switch result{
            case .success(let task): fetchedTask = task
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expextation.fulfill()
        }
        
        wait(for: [expextation], timeout: 1)
        XCTAssertEqual(fetchedTask?.title, newTask.title)
        
    }

    func testDelete() {
        let task = ToDoTask(id: UUID(), title: "TestTask")
        var fetchedTask: ToDoTask?
        let expection = expectation(description: "DeleteTask")
        
        coreDataTM.add(task)
        coreDataTM.delete(id: task.id)
        coreDataTM.get(id: task.id) { result in
            switch result{
            case .success(let task): fetchedTask = task
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expection.fulfill()
        }
        
        wait(for: [expection], timeout: 1)
        XCTAssertNil(fetchedTask)
    }
    
    func testRemoveAll() {
        let expection = expectation(description: "RemoveAll")
        var count = -1
        
        for _ in 0..<10 {
            let t = ToDoTask(id: UUID(), title: "", taskDescription: "", isDone: true, date: Date())
            coreDataTM.add(t)
        }
        
        coreDataTM.removeAll()
        coreDataTM.getAll { result in
            switch result{
            case .success(let tasks): count = tasks.count
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expection.fulfill()
        }
        
        wait(for: [expection], timeout: 1)
        XCTAssertEqual(count, 0)
    }
    
}
