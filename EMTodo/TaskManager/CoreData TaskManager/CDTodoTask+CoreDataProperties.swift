//
//  CDTodoTask+CoreDataProperties.swift
//  EMTodo
//
//  Created by Данила Бондарь on 16.05.2025.
//
//

import Foundation
import CoreData


extension CDTodoTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTodoTask> {
        return NSFetchRequest<CDTodoTask>(entityName: "CDTodoTask")
    }

    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var isDone: Bool
    @NSManaged public var taskDescription: String
    @NSManaged public var title: String
    
    func copyValues(from task: TodoTask, withoutID: Bool = false) {
        self.id = withoutID ? self.id : task.id
        self.title = task.title
        self.taskDescription = task.taskDescription
        self.date = task.date
        self.isDone = task.isDone
    }

}

extension CDTodoTask : Identifiable {

}
