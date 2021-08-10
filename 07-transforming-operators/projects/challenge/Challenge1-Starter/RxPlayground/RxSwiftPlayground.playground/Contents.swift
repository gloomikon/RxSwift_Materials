import Foundation
import RxSwift

example(of: "Challenge 1") {
    let disposeBag = DisposeBag()

    let contacts = [
        "603-555-1212": "Florent",
        "212-555-1212": "Shai",
        "408-555-1212": "Marin",
        "617-555-1212": "Scott"
    ]

    let convert: (String) -> Int? = { value in
        if let number = Int(value),
           number < 10 {
            return number
        }

        let keyMap: [String: Int] = [
            "abc": 2, "def": 3, "ghi": 4,
            "jkl": 5, "mno": 6, "pqrs": 7,
            "tuv": 8, "wxyz": 9
        ]

        let converted = keyMap
            .filter { $0.key.contains(value.lowercased()) }
            .map(\.value)
            .first

        return converted
    }

    let format: ([Int]) -> String = {
        var phone = $0.map(String.init).joined()

        phone.insert("-", at: phone.index(
                        phone.startIndex,
                        offsetBy: 3)
        )

        phone.insert("-", at: phone.index(
                        phone.startIndex,
                        offsetBy: 7)
        )

        return phone
    }

    let dial: (String) -> String = {
        if let contact = contacts[$0] {
            return "Dialing \(contact) (\($0))..."
        } else {
            return "Contact not found"
        }
    }

    let input = PublishSubject<String>()

    input.asObservable()
        .map(convert)
        .compactMap { $0 }
        .skipWhile { $0 == 0 }
        .take(10)
        .toArray()
        .map(format)
        .map(dial)
        .subscribe(
            onSuccess: {
                print($0)
            }
        )
        .disposed(by: disposeBag)

    input.onNext("")
    input.onNext("0")
    input.onNext("408")

    input.onNext("6")
    input.onNext("")
    input.onNext("0")
    input.onNext("3")

    "JKL1A1B".forEach {
        input.onNext("\($0)")
    }

    input.onNext("9")
}
