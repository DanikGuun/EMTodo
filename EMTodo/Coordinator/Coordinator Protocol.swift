
import UIKit

protocol Coordinator {
    var mainViewController: UIViewController { get }
    var currentViewController: Coordinatable { get }
    func popToRoot(animated: Bool)
    func goToAddTaskViewController(animated: Bool)
    func goToEditTaskViewController(task: ToDoTask, animated: Bool)
}

protocol Coordinatable: UIViewController {
    var coordinator: Coordinator? { get set }
}
