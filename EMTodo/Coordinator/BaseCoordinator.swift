
import UIKit

class BaseCoordinator: NSObject, Coordinator{
    
    var currentViewController: Coordinatable { navigationViewController.topViewController as! Coordinatable }
    var viewControllersFabric: ViewControllersFabric
    var mainViewController: UIViewController { return self.navigationViewController }
    private let navigationViewController: UINavigationController
    
    init(viewControllersFabric: ViewControllersFabric) {
        self.viewControllersFabric = viewControllersFabric
        let rootViewController: Coordinatable = viewControllersFabric.makeTaskListViewController()
        navigationViewController = UINavigationController(rootViewController: rootViewController)
        super.init()
        rootViewController.coordinator = self
    }
    
    func popToRoot(animated: Bool = true) {
        navigationViewController.popToRootViewController(animated: animated)
    }
    
    func goToAddTaskViewController(animated: Bool = true) {
        let controller = viewControllersFabric.makeAddTaskViewController()
        push(controller, animated: animated)
    }
    
    func goToEditTaskViewController(task: ToDoTask, animated: Bool = true) {
        let controller = viewControllersFabric.makeEditTaskViewController(task: task)
        push(controller, animated: animated)
    }
    
    private func push(_ viewController: Coordinatable, animated: Bool) {
        viewController.coordinator = self
        navigationViewController.pushViewController(viewController, animated: animated)
    }
    
}
