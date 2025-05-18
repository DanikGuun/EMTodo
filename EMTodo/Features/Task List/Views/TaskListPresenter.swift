
import UIKit

protocol TaskListPresenter: UIView {
    
    func setTasks(_ tasks: [TaskListItem])
    
}

struct TaskListItem: Identifiable {
    var id: UUID = UUID()
}
