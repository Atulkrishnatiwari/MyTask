//
//  AddTaskView.swift
//  MyTask
//
//  Created by Celestial on 19/02/24.
//

import SwiftUI

struct AddTaskView: View 
{
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var taskToAdd: Task = Task.createEmptyTask()
    
    @Binding var showaddTaskView: Bool
    @State private var showDirtyCheckalert: Bool = false
//    /////
    var pickerDateRange: ClosedRange<Date>
    {
        let calender = Calendar.current
        let currentDateComponent = calender.dateComponents([.day, .month, .year, .hour, .minute], from: Date())
        
        let startingDateComponent = DateComponents(
            year: currentDateComponent.year,
            month: currentDateComponent.month,
            day: currentDateComponent.day,
            hour: currentDateComponent.hour,
            minute: currentDateComponent.minute)
        let endingDateComponent = DateComponents(year: 2024,month: 12,day: 31)
        
        return calender.date(from: startingDateComponent)! ... calender.date(from: endingDateComponent)!
    }
//    ///////
    var body: some View
    {
        NavigationStack {
            List{
                Section(header: Text("Task details")) {
                    TextField("Task name",text: $taskToAdd.name)
                    TextEditor(text: $taskToAdd.description)
                }
                Section(header: Text("Task date/time")) {
                    DatePicker("Task date", selection: $taskToAdd.finishDate, in:pickerDateRange)
                }
            }
            .onReceive(taskViewModel.shouldDissmiss, perform: { shouldDismiss in
                
                if(shouldDismiss)
                {
                    showaddTaskView.toggle()
                }
            })
            .navigationTitle("Add task")
            .alert("Task Error",
                   isPresented: $taskViewModel.showErrorAlert,
                     actions: {
                Button("Ok") {
                    
                }
                     },
                     message: {
                Text(taskViewModel.errorMessage)
            })
            .toolbar{
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        if(!taskToAdd.name.isEmpty)
                        {
                            showDirtyCheckalert.toggle()
                        }
                        else
                        {
                            showaddTaskView = false
                        }
                    },label: {
                        
                        Text("Cancel")
                    }).alert("Save Task", isPresented: $showDirtyCheckalert) {
                        Button(action: {
                            showaddTaskView.toggle()
                        }, label: {
                            Text("Cancel")
                        })
                        Button(action: {
                            addTask()
                        }, label: {
                            Text("Save")
                        })
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        addTask()
                    },label: {
                        
                        Text("Add")
                    }).disabled(taskToAdd.name.isEmpty)
                }
            }
        }
    }
    private func addTask()
    {
        taskViewModel.addTask(task: taskToAdd)
    }
}

#Preview 
{
    AddTaskView(taskViewModel: TaskViewModelFactory.createTaskViewModel(), showaddTaskView: .constant(false))
}
