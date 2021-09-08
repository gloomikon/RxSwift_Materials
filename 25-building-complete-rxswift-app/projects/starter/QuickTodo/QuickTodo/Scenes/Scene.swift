import Foundation

enum Scene {
    case tasks(TasksViewModel)
    case editTask(EditTaskViewModel)
    case pushedEditTask(PushedEditTaskViewModel)
}

