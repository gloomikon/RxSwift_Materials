import Foundation
import RxSwift
import RxRelay

example(of: "toArray") {
    let disposeBag = DisposeBag()

    // 1
    Observable.of("A", "B", "C")
        // 2
        .toArray()
        .subscribe(onSuccess: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "map") {
    let disposeBag = DisposeBag()

    // 1
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    formatter.locale = Locale(identifier: "uk")

    // 2
    Observable<Int>.of(123, 4, 56)
        // 3
        .map {
            formatter.string(for: $0) ?? ""
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "enumerated and map") {
    let disposeBag = DisposeBag()

    // 1
    Observable.of(1, 2, 3, 4, 5, 6)
        // 2
        .enumerated()
        // 3
        .map { index, integer in
            index > 2 ? integer * 2 : integer
        }
        // 4
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "compactMap") {
    let disposeBag = DisposeBag()
    
    // 1
    Observable.of("To", "be", nil, "or", "not", "to", "be", nil)
        // 2
        .compactMap { $0 }
        // 3
        .toArray()
        // 4
        .map { $0.joined(separator: " ") }
        // 5
        .subscribe(onSuccess: {
            print($0)
        })
        .disposed(by: disposeBag)
}


struct Student {
    let score: BehaviorSubject<Int>
}

example(of: "flatMap") {
    let disposeBag = DisposeBag()

    // 1
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 90))

    // 2
    let student = PublishSubject<Student>()

    // 3
    student
        .flatMap {
            $0.score
        }
        // 4
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)

    student.onNext(laura)
    laura.score.onNext(85)

    student.onNext(charlotte)

    laura.score.onNext(95)

    charlotte.score.onNext(100)
}

example(of: "flatMapLatest") {
    let disposeBag = DisposeBag()

    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 90))

    let student = PublishSubject<Student>()

    student
        .flatMapLatest {
            $0.score
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)

    student.onNext(laura)
    laura.score.onNext(85)
    student.onNext(charlotte)

    // 1
    laura.score.onNext(95)
    charlotte.score.onNext(100)
}

example(of: "materialize and dematerialize") {
    // 1
    enum MyError: Error {
        case anError
    }

    let disposeBag = DisposeBag()

    // 2
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 100))

    let student = BehaviorSubject(value: laura)

    // 1
    let studentScore = student
        .flatMapLatest {
            $0.score.materialize()
        }

    // 2
    studentScore
        .filter {
            if let error = $0.error {
                print(error)
                return false
            }

            return true
        }
        .dematerialize()
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)

    // 3
    laura.score.onNext(85)

    laura.score.onError(MyError.anError)

    laura.score.onNext(90)

    // 4
    student.onNext(charlotte)
}
