
import UIKit
import Foundation

protocol Coordinator {
    var mainViewController: UIViewController { get }
    var currentViewController: Coordinatable { get }
    
    func popToRoot(animated: Bool)
    func goToAddTaskViewController(animated: Bool)
    func goToEditTaskViewController(id: UUID, animated: Bool)
    func presentDatePickerViewController(startDate: Date, callback: @escaping (Date) -> Void, sourceView: UIView, animated: Bool)
}

protocol Coordinatable: UIViewController {
    var coordinator: Coordinator? { get set }
}
