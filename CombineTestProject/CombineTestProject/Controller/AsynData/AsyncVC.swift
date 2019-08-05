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
    
    
    @IBOutlet weak var user1UpdateLabel    : UILabel!
    @IBOutlet weak var user2UpdateLabel    : UILabel!
    @IBOutlet weak var user3UpdateLabel    : UILabel!
    @IBOutlet weak var user4UpdateLabel    : UILabel!
    
    @IBOutlet weak var signUpButton         : UIButton!
    
    var viewModel = SignUpViewModel()
    
    @Published var userName1             : String = ""
    @Published var userName2             : String = ""
    @Published var userName3             : String = ""
    @Published var userName4             : String = ""
    
    private var cancellableSet          : Set<AnyCancellable> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signUpButton.setTitleColor(.red, for: .disabled)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.isEnabled = false
        createPublisherForTextField(textField: UITextField(), statusLabel: user1UpdateLabel, username: $userName1)
            .flatMap {  flatMapInValue -> AnyPublisher<Bool, Never> in
                let pub2 = self.createPublisherForTextField(textField: UITextField(), statusLabel: self.user2UpdateLabel, username: self.$userName2)
                let pub3 = self.createPublisherForTextField(textField: UITextField(), statusLabel: self.user3UpdateLabel, username: self.$userName3)
                let pub4 = self.createPublisherForTextField(textField: UITextField(), statusLabel: self.user4UpdateLabel, username: self.$userName4)
                return Publishers.Zip3(pub2, pub3, pub4)
                    //                    return Publishers.CombineLatest3(pub2, pub3, pub4)
                    .map{ (result1, result2, result3) ->Bool in
                        return result1 && result2 && result3
                }.eraseToAnyPublisher()
        }//.eraseToAnyPublisher()
            
            
            //        self.readyToSubmit
            //            .map { $0 != nil }
            .receive(on: RunLoop.main)
            ////            .replaceError(with: false)
            //            .sink { (valid) in
            //                print("CombineLatest: Are the credentials valid: \(valid)")
            //        }
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: &cancellableSet)
    }
    
    func  createPublisherForTextField(textField :UITextField, statusLabel: UILabel, username: Published<String>.Publisher ) -> AnyPublisher<Bool, Never> {
        //        var validatedUsername: AnyPublisher<String?, Never> {
        //            return
        return username
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { stringValue  in return stringValue != ""}
            .flatMap { userName   in
                return Future { promise in //(Result<Output, Failure>) -> Void
                    self.viewModel.findUserIDFor(userId: userName) { available in
                        //                            self.userNotFoundLabel.isHidden = available
                        promise(.success(available ? userName : nil))
                    }
                }
        }.receive(on: RunLoop.main)
            // so that we can update UI elements to show the "completion"
            // of this step
            .map { inValue -> Bool in
                // intentially side effecting here to show progress of pipeline
                //                seld
                self.updateLable(label: statusLabel, isValid: (inValue != nil))
                return (inValue != nil)
        }
        .eraseToAnyPublisher()
        //        }
    }
    func updateLable(label: UILabel, isValid: Bool) {
        label.text = (isValid) ? "User Found" : "User is not Found"
        label.textColor = (isValid) ? .green : .red
    }
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
}
