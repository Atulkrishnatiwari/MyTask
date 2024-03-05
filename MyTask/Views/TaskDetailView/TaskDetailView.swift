//
//  TaskDetailView.swift
//  MyTask
//
//  Created by Celestial on 19/02/24.
//

import SwiftUI

struct TaskDetailView: View 
{
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var showDetailView: Bool
    @Binding var selectedTask: Task
    @State private var showDeleteAlert: Bool = false
    var body: some View
    {
        NavigationStack
        {
            List{
                Section(header: Text("Task details")) {
                    TextField("Task name",text: $selectedTask.name)
                    TextEditor(text: $selectedTask.description)
                    Toggle(isOn: $selectedTask.isCompleted) {
                        
                        Text("Mark complete")
                    }
                }
                Section(header: Text("Task date/time")) {
                    DatePicker("Task date", selection: $selectedTask.finishDate)
                }
                Section {
                    Button(action: {
                        showDeleteAlert.toggle()
                    }, label: {
                        Text("Delete")
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity,alignment:.center)
                    }).alert("Delete Task?", isPresented: $showDeleteAlert) {
                        Button(action: {
                            showDetailView.toggle()
                        }, label: {
                            
                            Text("No")
                        })
                        Button(role: .destructive,action: {
                            taskViewModel.deleteTask(task: selectedTask)
                        }, label: {
                            
                            Text("Yes")
                        })
                    } message: {
                        Text("Would you like to delete the task!!")
                    }

                }
            }
            .onReceive(taskViewModel.shouldDissmiss, perform: { shouldDismiss in
                
                if(shouldDismiss)
                {
                    showDetailView.toggle()
//                    refreshTaskList.toggle()
                }
            })
            .navigationTitle("Task Details")
            .toolbar{
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        showDetailView = false
                    },label: {
                        
                        Text("Cancel")
                    })
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        taskViewModel.updateTask(task: selectedTask)
                      
                    },label: {
                        
                        Text("Update Task")
                    }).disabled(selectedTask.name.isEmpty)
                }
            }
            .alert("Task Error",
                   isPresented: $taskViewModel.showErrorAlert,
                     actions: {
                Button("Ok") {
                    
                }
                     },
                     message: {
                Text(taskViewModel.errorMessage)
            })
        }
    }
}

#Preview 
{
    TaskDetailView(
        taskViewModel: TaskViewModelFactory.createTaskViewModel(),
        showDetailView: .constant(false),
        selectedTask: .constant(Task.createEmptyTask()))
}
