
import UIKit

protocol ViewControllersFabric {
    func makeTaskListViewController() -> Coordinatable
    func makeAddTaskViewController() -> Coordinatable
    func makeEditTaskViewController(task: TodoTask) -> Coordinatable
    func makeDatePickerViewController(startDate: Date, callback: @escaping (Date) -> Void) -> Coordinatable
}
