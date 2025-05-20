
protocol TaskEditingModel {
    typealias Completion = ((TodoTask) -> Void)?
    
    func perform(task: TodoTask)
    func loadInitialTask(completion: Completion)
}
