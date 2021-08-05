import UIKit
import RxSwift

extension UIViewController {
    func alert(title: String, description: String? = nil) -> Completable {
        return Completable.create { [weak self] comp in
            let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(
                    title: "Close",
                    style: .default,
                    handler: { _ in
                        comp(.completed)
                    }
                )
            )
            
            self?.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
