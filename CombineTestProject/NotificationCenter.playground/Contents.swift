import UIKit
import Combine


extension Notification.Name {
    static let notification_key = Notification.Name("notification_testing")
}

struct TestObject {
    let title   : String
    let id      : Int
}

let publisher = NotificationCenter.Publisher(center: .default, name: .notification_key, object: nil)
    .map { (notification) -> String? in
        return (notification.object as? TestObject)?.title ?? ""
}.sink(receiveValue: { value in
    print(value)
})

let testObject = TestObject(title: "Testing Combine with Notification Center", id:1)
NotificationCenter.default.post(name: .notification_key, object: testObject)
