//
//  SwiftUIView.swift
//  MyTask
//
//  Created by Celestial on 19/02/24.
//

import SwiftUI

struct HomeView: View
{
    @StateObject var taskViewModel: TaskViewModel = TaskViewModelFactory.createTaskViewModel()
    @State private var pickerFilters: [String] = ["Active", "Completed"]
    @State private var defaultPickerSelectedItem: String = "Active"
    @State private var showAddtaskview: Bool = false
    @State private var showTaskDetailsView: Bool = false
    @State private var selectedTask: Task = Task.createEmptyTask()
    
    var body: some View
    {
        NavigationStack 
        {
            Picker("Picker filter",selection: $defaultPickerSelectedItem) {
                ForEach(pickerFilters,id:\.self){
                    Text($0)
                }
            }.pickerStyle(.segmented)
                .onChange(of: defaultPickerSelectedItem) { _,_ in
                    taskViewModel.getTasks(isCompleted: defaultPickerSelectedItem == "Active")
                   }
            List(taskViewModel.tasks,id: \.id) {task in
                VStack(alignment: .leading)
                {
                    Text(task.name).font(.title)
                    HStack
                    {
                        Text(task.description).font(.body)
                        Spacer()
                        Text("\(task.finishDate.toString())")
                            .fontWeight(.bold)
                    }
                }
                .onTapGesture {
                    selectedTask = task
                    showTaskDetailsView.toggle()
                }
            }
            .listStyle(.grouped)
            .onAppear
            {
                taskViewModel.getTasks(isCompleted: true)
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
            .navigationTitle("Home")
            .toolbar{
                ToolbarItem(placement: .automatic)
                {
                    Button(action: {
                        showAddtaskview = true
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title)
                    })
                }
            }
        }
        .sheet(isPresented: $showAddtaskview, content: {
            
            AddTaskView(
                taskViewModel: taskViewModel,
                showaddTaskView: $showAddtaskview)
        })
        .sheet(isPresented: $showTaskDetailsView, content: {
            
            TaskDetailView(
                taskViewModel: taskViewModel,
                showDetailView: $showTaskDetailsView,
                selectedTask: $selectedTask)
        })
    }
}

#Preview {
    HomeView()
}
