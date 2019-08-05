import UIKit
import Combine
var str = "Hello, playground"

let subject = PassthroughSubject<String, Never>()
var publisher = subject.eraseToAnyPublisher()
//let subscriber = publisher.sink(receiveValue: { stringValue in
//    print("Subject value is \(stringValue)")
//})


let subscriber2 = publisher.sink(receiveCompletion: { _ in
    print("finished")
}) { stringValue in
    print("Subject value is \(stringValue)")
}

subject.send("Tintash")
subject.send("iOS Team")



 let publisher2 = Just("Testing Just")
let subscriber3 = publisher2.sink(receiveValue: { stringValue in
    print("Subject value is \(stringValue)")
})


Publishers.Sequence(sequence: [3,4,5,6,8,9,10,11,12, 12, 13, 15])
    .map { $0 * 2 }
    .flatMap { Just($0) }
    .filter { $0.isMultiple(of: 3) }
    //    .dropFirst(3)
    //    .removeDuplicates()
    
