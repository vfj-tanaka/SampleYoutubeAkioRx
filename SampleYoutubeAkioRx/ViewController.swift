//
//  ViewController.swift
//  SampleYoutubeAkioRx
//
//  Created by mtanaka on 2022/08/15.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var password1TextField: UITextField!
    @IBOutlet private weak var password2TextField: UITextField!
    @IBOutlet private weak var signupButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        input()
    }
    
    func input() {
        
        //        emailTextField.rx.text
        //            .map { $0 ?? "" }
        //            .map { $0.isValidEmail }
        //            .subscribe(onNext: { [weak self] in
        //                self?.signupButton.isEnabled = $0
        //            })
        //            .disposed(by: disposeBag)
        
        //        emailTextField.rx.text
        //            .map { $0 ?? "" }
        //            .map { $0.isValidEmail }
        //            .bind(to: signupButton.rx.isEnabled)
        //            .disposed(by: disposeBag)
        
        //        Observable
        //            .combineLatest(password1TextField.rx.text, password2TextField.rx.text)
        //            .map { pass1, pass2 in pass1 == pass2 }
        //            .subscribe(onNext: {
        //                print($0)
        //            })
        //            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                emailTextField.rx.text.map { $0 ?? "" },
                password1TextField.rx.text.map { $0 ?? "" },
                password2TextField.rx.text.map { $0 ?? "" }
            )
            .map { email, pass1, pass2 in
                email.isValidEmail
                && pass1.isValidPassword
                && pass1 == pass2
            }
            .bind(to: signupButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
}

private extension String {
    var isValidEmail: Bool {
        self.contains("@gmail.com")
    }
    
    var isValidPassword: Bool {
        count >= 8
    }
}
