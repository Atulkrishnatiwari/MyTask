//
//  TaskRepository.swift
//  MyTask
//
//  Created by Celestial on 19/02/24.
//

import Foundation
import CoreData.NSManagedObjectContext
import Combine
protocol TaskRepository
{
    func get(isCompleted: Bool) -> AnyPublisher<Result<[Task],TaskRepositoryError>,Never>
    func update(task:Task) -> AnyPublisher<Result<Bool,TaskRepositoryError>,Never>
    func add(task:Task) -> AnyPublisher<Result<Bool,TaskRepositoryError>,Never>
    func delete(id:UUID) -> AnyPublisher<Result<Bool,TaskRepositoryError>,Never>
}
final class TaskRepositoryImplementation:TaskRepository
{
    
    private let managedObjectContext: NSManagedObjectContext = PersistenceController.shared.viewContext
    func get(isCompleted: Bool) -> AnyPublisher<Result<[Task],TaskRepositoryError>,Never>
    {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isCompleted = %@", NSNumber(value: isCompleted))
        do{
            let result = try managedObjectContext.fetch(fetchRequest)
            if(!result.isEmpty)
            {
                let clientContract = result.map ({Task(id: $0.id!,
                                         name: $0.name ?? "",
                                         description: $0.taskDescription ?? "",
                                         isCompleted: $0.isCompleted,
                                         finishDate: $0.finishDate ?? Date())})
                return Just(.success(clientContract)).eraseToAnyPublisher()
            }
            return Just(.success([])).eraseToAnyPublisher()
        }catch{
            //For Firebase Lo in here
            return Just(.failure(.operationFailure("Unable To fetch"))).eraseToAnyPublisher()
        }
    }
    
    func update(task: Task) -> AnyPublisher<Result<Bool,TaskRepositoryError>,Never>{
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", task.id as CVarArg)
        do{
            if let result = try managedObjectContext.fetch(fetchRequest).first{
                result.name = task.name
                result.taskDescription = task.description
                result.finishDate = task.finishDate
                result.isCompleted = task.isCompleted
                try managedObjectContext.save()
                return Just(.success(true)).eraseToAnyPublisher()
            }
            else
            {
                return Just(.failure(.operationFailure("Not Found With The id: \(task.id)"))).eraseToAnyPublisher()
            }
        }
        catch{
            managedObjectContext.rollback()
            return Just(.failure(.operationFailure("unable to Update"))).eraseToAnyPublisher()
        }
    }
    
    func add(task: Task) -> AnyPublisher<Result<Bool,TaskRepositoryError>,Never>
    {
        let taskEntity = TaskEntity(context: managedObjectContext)
        taskEntity.id = UUID()
        taskEntity.isCompleted = false
        taskEntity.name = task.name
        taskEntity.taskDescription = task.description
        taskEntity.finishDate = task.finishDate
        do{
            try managedObjectContext.save()
            return Just(.success(true)).eraseToAnyPublisher()
        }
        catch{
            managedObjectContext.rollback()
            return Just(.failure(.operationFailure("Unable to add task Please try again"))).eraseToAnyPublisher()
        }
    }
    
    func delete(id: UUID) -> AnyPublisher<Result<Bool,TaskRepositoryError>,Never>
    {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do{
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first
            {
                managedObjectContext.delete(existingTask)
                try managedObjectContext.save()
                return Just(.success(true)).eraseToAnyPublisher()
            }
            else
            {
                return Just(.failure(.operationFailure("Record Not found Of Id: \(id)"))).eraseToAnyPublisher()
            }
        }catch{
            return Just(.failure(.operationFailure("could not delete"))).eraseToAnyPublisher()
        }
    }
    
    
}
