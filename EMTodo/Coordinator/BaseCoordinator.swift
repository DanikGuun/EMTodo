
import UIKit

class BaseCoordinator: NSObject, Coordinator, UIAdaptivePresentationControllerDelegate {
    
    var currentViewController: Coordinatable { return getModalOrSelfController(for: navigationViewController.topViewController as! Coordinatable) }
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
    
    func presentDatePickerViewController(startDate: Date, callback: @escaping (Date) -> Void, sourceView: UIView, animated: Bool = true) {
        let controller = viewControllersFabric.makeDatePickerViewController(startDate: startDate, callback: callback)
        controller.coordinator = self
        controller.preferredContentSize = CGSize(width: controller.view.frame.width, height: 350)
        controller.modalPresentationStyle = .popover
        controller.presentationController?.delegate = self
        controller.popoverPresentationController?.sourceView = sourceView
        controller.popoverPresentationController?.sourceRect = sourceView.bounds
        controller.popoverPresentationController?.permittedArrowDirections = [.up]
        currentViewController.present(controller, animated: animated)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    private func push(_ viewController: Coordinatable, animated: Bool) {
        viewController.coordinator = self
        navigationViewController.pushViewController(viewController, animated: animated)
    }
    
    private func getModalOrSelfController(for controller: Coordinatable) -> Coordinatable {
        if controller.presentedViewController == nil { return controller }
        return controller.presentedViewController! as! Coordinatable
    }
    
}
