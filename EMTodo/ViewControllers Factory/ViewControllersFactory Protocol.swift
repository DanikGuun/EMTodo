
import UIKit
import Foundation

protocol ViewControllersFactory {
    func makeTaskListViewController() -> Coordinatable
    func makeAddTaskViewController() -> Coordinatable
    func makeEditTaskViewController(id: UUID) -> Coordinatable
    func makeDatePickerViewController(startDate: Date, callback: @escaping (Date) -> Void) -> Coordinatable
}
