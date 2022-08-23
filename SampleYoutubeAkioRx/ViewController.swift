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
    @IBOutlet private weak var errorTextView: UITextView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorTextView.layer.borderColor = UIColor.red.cgColor
        errorTextView.layer.borderWidth = 1
        input()
    }
    
    private func input() {
        
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
        let inputs = Observable
            .combineLatest(
                emailTextField.rx.text.map { $0 ?? "" },
                password1TextField.rx.text.map { $0 ?? "" },
                password2TextField.rx.text.map { $0 ?? "" }
            )
        
        inputs
            .map { email, pass1, pass2 in
                email.isValidEmail
                && pass1.isValidPassword
                && pass1 == pass2
            }
            .bind(to: signupButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        inputs
            .map { email, pass1, pass2 in
                return makeErrorMessages(email: email, pass1: pass1, pass2: pass2)
                    .map { "・\($0)" }
                    .joined(separator: "\n")
            }
            .bind(to: errorTextView.rx.text)
            .disposed(by: disposeBag)
    }
}

private func makeErrorMessages(email: String, pass1: String, pass2: String) -> [String] {
    
    var messages: [String] = []
    
    if email.isEmpty {
        messages.append("メールアドレスを入力してください")
    } else if !email.isValidEmail {
        messages.append("メールアドレスの形式が正しくありません")
    }
    
    if pass1.isEmpty {
        messages.append("パスワードを入力してください")
    } else if !pass1.isValidPassword {
        messages.append("パスワードの形式が正しくありません")
    }
    
    if pass2.isEmpty {
        messages.append("確認用パスワードを入力してください")
    } else if pass1 != pass2 {
        messages.append("確認用パスワードが一致しません")
    }
    return messages
}

private extension String {
    var isValidEmail: Bool {
        self.contains("@gmail.com")
    }
    
    var isValidPassword: Bool {
        count >= 8
    }
}
