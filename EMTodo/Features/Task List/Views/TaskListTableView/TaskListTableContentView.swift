
import UIKit

class TaskListTableContentView: UIView, UIContentView {
    var configuration: any UIContentConfiguration = TaskListTableContentConfiguration() { didSet { updateConfiguration() } }
    
    private func updateConfiguration() {
        self.backgroundColor = .blue
    }
    
    private func getConfiguration() -> TaskListTableContentConfiguration {
        if let conf = configuration as? TaskListTableContentConfiguration { return conf }
        return TaskListTableContentConfiguration()
    }
}
