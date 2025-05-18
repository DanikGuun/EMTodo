
import UIKit

protocol ViewControllersFabric {
    func makeTaskListViewController() -> Coordinatable
    func makeAddTaskViewController() -> Coordinatable
    func makeEditTaskViewController(task: ToDoTask) -> Coordinatable
}
