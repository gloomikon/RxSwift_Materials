import RxSwift
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// Start coding here!
example(of: "scan") {
    let source = Observable.of(1, 3, 5, 7, 9)

    let currentSum = source.scan(0, accumulator: +)

    _ = Observable.zip(source, currentSum)
        .subscribe(
            onNext: { elem, sum in
                print(elem, sum)
            }
        )
}

example(of: "scan2") {
    let source = Observable.of(1, 3, 5, 7, 9)
    let observable = source.scan((0, 0)) { acc, current in
        return (current, acc.1 + current)
    }

    _ = observable.subscribe(onNext: { tuple in
        print("\(tuple.0) \(tuple.1)")
    })
}
