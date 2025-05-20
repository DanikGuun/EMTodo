import Foundation

protocol ModelsFactory {
    
    func createTasksListModel() -> TaskListModel
    func createTaskAddModel() -> TaskEditingModel
    func createTaskEditModel(id: UUID) -> TaskEditingModel
    
}
