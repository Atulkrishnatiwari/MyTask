# MyTask App

**Screen Recording Of Application:**

https://github.com/Atulkrishnatiwari/MyTask/assets/151607237/1afea22e-4e2c-46c1-8dec-3560455eaf6d


This MyTask App is a Swift-based iOS application built on the MVVM (Model-View-ViewModel) architecture.
It follows the CRUD (Create, Read, Update, Delete) operations for MyTask List data.

## Screenshots

<img src="https://github.com/Atulkrishnatiwari/MyTask/assets/151607237/e276c25a-ca08-491f-b2f5-e38d4c66d5a9" alt="Image 1" width="200">
<img src="https://github.com/Atulkrishnatiwari/MyTask/assets/151607237/fa5385c9-6aca-4b0c-80ba-660e844ec142" alt="Image 2" width="200">
<img src="https://github.com/Atulkrishnatiwari/MyTask/assets/151607237/73b97c3b-561e-4c89-9dea-305f4311641e" alt="Image 3" width="200">
<img src="https://github.com/Atulkrishnatiwari/MyTask/assets/151607237/acc9fb28-66cc-4933-a811-f5b766e6fd86" alt="Image 4" width="200">

## Features

- **MVVM Architecture:** The application is structured following the MVVM pattern, promoting separation of concerns and maintainability.
  - **Repository**
    - **Task Repository Error**
      - 'TaskRepositoryError.swift'
    - 'TaskRepository.swift'
  - **Extensions:**
     - 'Date-Extensions.swift'
  - **Model:**
    - **Core Data Model**
       - 'TaskEntity+CoreDataClass.swift'
       - 'TaskEntity+CoreDataProperties.swift'
    - `Task`
  - **View Model:**
    - 'TaskViewModel.swift'
    - 'TaskViewModelFactory.swift' 
  - **View:**
    - **TaskDetailView:**
      - `TaskDetailView.swift`
    - **AddTaskView:**
    - 'AddTaskView.swift'
    - **HomeView**
    - 'HomeView.swift'
  - 'MyTaskApp.swift'
  - 'Persistence.swift'
  - 'MyTask.xcdatamodeld'

- **CRUD Operations:** Implements Create, Read, Update, and Delete operations for managing employee records. in this we can Add,Delete,Edit

- **CoreData** Utilizes a default data storage mechanism (e.g., UserDefaults) for simplicity. And I Have used my Own Model Object For Saving Data in
  With The Help Of UserDefaults 

- **Technology Uses:**
  - SwiftUI
  - CoreData

- **IDE:**
  - Xcode
## Getting Started

**Open in Xcode:**
  Open the project in Xcode.

**Build and Run:**
  Build and run the project in the Xcode simulator or on a physical device.

**Installation:**
  Open the Xcode project.
  Build and run the application on a simulator or a physical iOS device.

**Setup:**
  Follow on-screen instructions for initial setup.
  Provide necessary permissions if prompted.

**User Interactions:**
  Navigate through the app using the provided tabs and buttons.
  Interact with the Task Records, edit Task, and delete Task.

**Common Scenarios:**
  - Add a new Task .
  - Edit existing Task That is completed.
  - Delete unnecessary records.
  - View Completed Task
  - View Unfinished Task
