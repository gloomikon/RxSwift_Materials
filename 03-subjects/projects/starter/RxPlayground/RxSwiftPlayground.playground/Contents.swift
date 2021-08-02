import Foundation
import RxSwift
import RxRelay

example(of: "PublishSubject") {
    let subject = PublishSubject<String>()
    subject.onNext("Is anyone listening?")
    
    let subscriptionOne = subject
    .subscribe(onNext: { string in
        print(string)
    })
    
    subject.onNext("1")
    subject.onNext("2")
    

    let subscriptionTwo = subject
    .subscribe { event in
        print("2)", event.element ?? event)
    }
    
    subject.onNext("3")
    
    subscriptionOne.dispose()

    subject.onNext("4")
    
    // 1
    subject.onCompleted()

    // 2
    subject.onNext("5")

    // 3
    subscriptionTwo.dispose()

    let disposeBag = DisposeBag()

    // 4
    subject
    .subscribe {
        print("3)", $0.element ?? $0)
    }
    .disposed(by: disposeBag)
    
    subject.onNext("?")
}


