//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by Sergey Gorokhovich on 7/24/16.
//  Copyright © 2016 Sergey Gorokhovich. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift


extension String {
    func isEmail() -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        
        var isEmail = false
        
        do {
            let regex = try NSRegularExpression(pattern: emailPattern, options: .CaseInsensitive)
            isEmail = regex.firstMatchInString(self, options: [], range: NSMakeRange(0, characters.count)) != nil
        }
        catch {
            print(error)
        }
        
        return isEmail
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let emailTextFieldValid = emailTextField.rx_text.map { text in
            text.isEmail()
        }.shareReplay(1)
        
        let passwordTextFieldValid = passwordTextField.rx_text.map { text in
            text.characters.count > 5
        }.shareReplay(1)
        
        let infoValid = Observable.combineLatest(emailTextFieldValid, passwordTextFieldValid) { (email, pass) -> Bool in
            return email && pass
        }.shareReplay(1)
        
        infoValid.bindTo(submitButton.rx_enabled).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

