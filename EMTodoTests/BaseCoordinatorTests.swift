

import XCTest
@testable import EMTodo

final class BaseCoordinatorTests: XCTestCase {
    
    var coordinator: BaseCoordinator!
    fileprivate var currentMockVC: MockViewController { coordinator.currentViewController as! MockViewController }
    fileprivate let fabric = MockViewControllersFabric()
    
    override func setUp() {
        coordinator = BaseCoordinator(viewControllersFabric: fabric)
        super.setUp()
    }
    
    override func tearDown() {
        coordinator = nil
        super.tearDown()
    }
    
    func testStartVC() {
        let type = currentMockVC.type
        XCTAssertEqual(type, .taskList)
    }
    
    func testGoToAddVC() {
        coordinator.goToAddTaskViewController()
        let type = currentMockVC.type
        XCTAssertEqual(type, .addTask)
    }
    
    func testGoToEditVC() {
        coordinator.goToEditTaskViewController(task: TodoTask())
        let type = currentMockVC.type
        XCTAssertEqual(type, .editTask)
    }
    
    func testPopToRootVC() {
        coordinator.goToAddTaskViewController()
        coordinator.goToAddTaskViewController()
        coordinator.goToAddTaskViewController()
        coordinator.popToRoot(animated: false)
        let type = currentMockVC.type
        XCTAssertEqual(type, .taskList)
    }
    
}

fileprivate class MockViewControllersFabric: ViewControllersFabric {
    
    func makeTaskListViewController() -> any EMTodo.Coordinatable {
        return MockViewController(type: .taskList)
    }
    
    func makeAddTaskViewController() -> any EMTodo.Coordinatable {
        return MockViewController(type: .addTask)
    }
    
    func makeEditTaskViewController(task: EMTodo.TodoTask) -> any EMTodo.Coordinatable {
        return MockViewController(type: .editTask)
    }
    
    func makeDatePickerViewController(startDate: Date, callback: @escaping (Date) -> Void) -> any EMTodo.Coordinatable {
        return MockViewController(type: .datePicker)
    }
}

fileprivate enum ViewControllerType: String {
    case taskList
    case addTask
    case editTask
    case datePicker
}

fileprivate class MockViewController: UIViewController, Coordinatable {
    var coordinator: (any Coordinator)?
    var type: ViewControllerType?
    
    convenience init(type: ViewControllerType) {
        self.init(nibName: nil, bundle: nil)
        self.type = type
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
