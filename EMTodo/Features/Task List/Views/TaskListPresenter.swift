
import UIKit

protocol TaskListPresenter: UIView {
    
    func setTasks(_ tasks: [TaskListItem])
    var isDoneUpdated: ((UUID) -> Void)? { get set }
    
}

struct TaskListItem: Identifiable {
    var id: UUID
    var title: String
    var taskDescription: String
    var isDone: Bool
    var subTitle: String
    
    init(id: UUID = UUID(), title: String = "", taskDescription: String = "", isDone: Bool = false, subtitle: String = "") {
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
        self.isDone = isDone
        self.subTitle = subtitle
    }
}
