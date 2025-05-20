
import Foundation

protocol TaskListModel {
    typealias Completion = ((TodoTask?) -> Void)?
    typealias CompletionArray = (([TodoTask]) -> Void)?
    
    func getAllTasks(completion: CompletionArray)
    func updateTaskCompleted(_ id: UUID, isCompleted: Bool, completion: Completion)
    func removeTask(_ id: UUID, completion: Completion)
    func getTaskShareText(_ task: TodoTask) -> String
    func getTasksCountTitle(_ count: Int) -> String
}
