//
//  TaskViewModel.swift
//  MyTask
//
//  Created by Celestial on 19/02/24.
//

import Foundation
import Combine
final class TaskViewModel: ObservableObject
{
    private let taskRepository: TaskRepository
    @Published var tasks: [Task] = []
    @Published var errorMessage:String = ""
    @Published var showErrorAlert: Bool = false
    private var cancellable = Set<AnyCancellable>()
    private var isCompleted: Bool = false
    var shouldDissmiss = PassthroughSubject<Bool,Never>()
    init(taskRepository: TaskRepository)
    {
        self.taskRepository = taskRepository
    }
    deinit
    {
        cancellable.forEach({$0.cancel()})
    }
    func getTasks(isCompleted: Bool)
    {
        self.isCompleted = isCompleted
        taskRepository.get(isCompleted: !isCompleted)
            .sink {[weak self] fetchedOperationResult in
                switch fetchedOperationResult
                {
                case .success(let fetchedTask):
                    self?.tasks = fetchedTask
                    self?.errorMessage = ""
                case .failure(let error):
                    self?.processedError(error)
                }
            }.store(in: &cancellable)
    }
    
    func addTask(task:Task)
    {
        taskRepository.add(task: task).sink {[weak self] addOperationResult in
            self?.processOperationResult(operationResult: addOperationResult)
        }.store(in: &cancellable)
    }
    
    func updateTask(task:Task)
    {
        taskRepository.update(task: task).sink {[weak self] updateResult in
            
            self?.processOperationResult(operationResult: updateResult)
        }.store(in: &cancellable)
    }
    
    func deleteTask(task:Task)
    {
        taskRepository.delete(id: task.id)
            .sink {[weak self] deleteResult in
                
                self?.processOperationResult(operationResult: deleteResult)
            }.store(in: &cancellable)
    }
    private func processedError(_ error: TaskRepositoryError)
    {
        switch error {
        case .operationFailure(let errorMessage):
            self.showErrorAlert = true
            self.errorMessage = errorMessage
            shouldDissmiss.send(false)
        }
    }
    private func processOperationResult(operationResult: Result<Bool,TaskRepositoryError>)
    {
        switch operationResult
        {
        case .success(_):
            errorMessage = ""
            self.getTasks(isCompleted: self.isCompleted)
            shouldDissmiss.send(true)
//            return success
        case .failure(let failure):
            self.processedError(failure)
        }
//        return false
    }
}
