//
//  TaskViewModelFactory.swift
//  MyTask
//
//  Created by Celestial on 20/02/24.
//

import Foundation
final class TaskViewModelFactory
{
    static func createTaskViewModel() -> TaskViewModel
    {
        return TaskViewModel(taskRepository: TaskRepositoryImplementation())
    }
}
