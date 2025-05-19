
import UIKit

struct TaskListTableContentConfiguration: UIContentConfiguration {
    
    var title: String?
    var taskDescription: String?
    var subtitle: String?
    var isDone: Bool = false
    
    func makeContentView() -> any UIView & UIContentView {
        return TaskListTableContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> TaskListTableContentConfiguration {
        return self
    }
    
    
}
