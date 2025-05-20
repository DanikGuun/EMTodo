
import UIKit

protocol TaskListPresenter: UIView {
    
    var taskDelegate: TaskListPresenterDelegate? { get set }
    func setTasks(_ tasks: [TaskListItem])
    
}

protocol TaskListPresenterDelegate {
    func taskListPresenter(didChangeCompletion task: TaskListItem)
    func taskListPresenter(didDelete task: TaskListItem)
    func taskListPresenter(requestToEdit task: TaskListItem)
    func taskListPresenter(requestToShare task: TaskListItem)
}

extension TaskListPresenterDelegate {
    func taskListPresenter(didChangeCompletion task: TaskListItem) {}
    func taskListPresenter(didDelete task: TaskListItem) {}
    func taskListPresenter(requestToEdit task: TaskListItem) {}
    func taskListPresenter(requestToShare task: TaskListItem) {}
}

struct TaskListItem: Identifiable, Equatable {
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
