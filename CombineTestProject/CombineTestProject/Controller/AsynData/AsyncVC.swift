//
//  AsyncVC.swift
//  CombineTestProject
//
//  Created by Rizwan Ahmed on 05/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import UIKit
import Combine
class AsyncVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var user1UpdateLabel     : UILabel!
    @IBOutlet weak var user2UpdateLabel     : UILabel!
    @IBOutlet weak var user3UpdateLabel     : UILabel!
    @IBOutlet weak var user4UpdateLabel     : UILabel!
    
    @IBOutlet weak var signUpButton         : UIButton!
    
    // MARK: - viewmodel
    var viewModel = SignUpViewModel()
    
    // MARK: - Published properties
    @Published var userName1                : String = ""
    @Published var userName2                : String = ""
    @Published var userName3                : String = ""
    @Published var userName4                : String = ""
    
    private var cancellableSet              : Set<AnyCancellable> = []
    
    // MARK: - IBAction
    @IBAction func clickOnSignUpButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userName1Changed(_ sender: UITextField) {
        userName1 = sender.text ?? ""
    }
    @IBAction func userName2Changed(_ sender: UITextField) {
        userName2 = sender.text ?? ""
    }
    @IBAction func userName3Changed(_ sender: UITextField) {
        userName3 = sender.text ?? ""
    }
    @IBAction func userName4Changed(_ sender: UITextField) {
        userName4 = sender.text ?? ""
    }
    
    // MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signUpButton.setTitleColor(.red, for: .disabled)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.isEnabled = false
        setupAsyncPublishers()
    }
}

// MARK: - Class methods
extension AsyncVC {
    func updateLable(label: UILabel, isValid: Bool) {
        label.text = (isValid) ? "User Found" : "User is not Found"
        label.textColor = (isValid) ? .green : .red
    }
}

// MARK: - Combine methods
extension AsyncVC {
    func setupAsyncPublishers() {
        createPublisherForTextField(username: $userName1, statusLabel: user1UpdateLabel)
            .flatMap {  flatMapInValue -> AnyPublisher<Bool, Never> in
                let pub2 = self.createPublisherForTextField(username: self.$userName2, statusLabel: self.user2UpdateLabel)
                let pub3 = self.createPublisherForTextField(username: self.$userName3, statusLabel: self.user3UpdateLabel)
                let pub4 = self.createPublisherForTextField(username: self.$userName4, statusLabel: self.user4UpdateLabel)
                return Publishers.Zip3(pub2, pub3, pub4)
                    //                    return Publishers.CombineLatest3(pub2, pub3, pub4)
                    .map{ (result1, result2, result3) ->Bool in
                        return result1 && result2 && result3
                }.eraseToAnyPublisher()
        }
        .receive(on: RunLoop.main)
            //            .replaceError(with: false) // If there is Publisher type is <Bool, Error> instead of <Bool, Never>
            //            .sink { (valid) in
            //                print("CombineLatest: Are the credentials valid: \(valid)")
            //        }
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: &cancellableSet)
    }
    
    func  createPublisherForTextField(username: Published<String>.Publisher, statusLabel: UILabel,textField :UITextField? = nil ) -> AnyPublisher<Bool, Never> {
        return username
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { stringValue  in return stringValue != ""}
            .flatMap { userName   in
                return Future { promise in //(Result<Output, Failure>) -> Void
                    self.viewModel.findUserIDFor(userId: userName) { available in
                        promise(.success(available ? userName : nil))
                    }
                }
        }.receive(on: RunLoop.main)
            .map { inValue -> Bool in
                // Update UI respective element for the call
                self.updateLable(label: statusLabel, isValid: (inValue != nil))
                return (inValue != nil)
        }
        .eraseToAnyPublisher()
    }
    
}
