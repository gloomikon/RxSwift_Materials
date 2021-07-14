import Foundation
import RxSwift

example(of: "never") {
    let disposeBag = DisposeBag()
    let observable = Observable<Any>.never()
    
    observable.do(
        onSubscribe: {
            print("Received a subscriber")
        }
    )
    .subscribe(
        onNext: { element in
            print(element)
        },
        onCompleted: {
            print("Completed")
        },
        onDisposed: {
            print("Disposed")
        }
    )
    .disposed(by: disposeBag)
}
