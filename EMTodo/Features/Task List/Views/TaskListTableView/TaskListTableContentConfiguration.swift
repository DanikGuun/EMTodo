
import UIKit

struct TaskListTableContentConfiguration: UIContentConfiguration {
    
    func makeContentView() -> any UIView & UIContentView {
        return TaskListTableContentView()
    }
    
    func updated(for state: any UIConfigurationState) -> TaskListTableContentConfiguration {
        return self
    }
    
    
}
