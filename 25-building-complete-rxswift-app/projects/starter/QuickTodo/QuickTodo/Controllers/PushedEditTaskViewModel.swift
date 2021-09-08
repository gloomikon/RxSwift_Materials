import Foundation
import RxSwift
import Action

struct PushedEditTaskViewModel {

    let itemTitle: String
    let onUpdate: Action<String, Void>
    let disposeBag = DisposeBag()

    init(task: TaskItem, coordinator: SceneCoordinatorType, updateAction: Action<String, Void>) {
        itemTitle = task.title
        onUpdate = updateAction
    }
}
