//
//  ViewController.swift
//  CurrencyTextField
//
//  Created by Macbook on 20/07/16.
//  Copyright © 2016 Plum's organization. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet weak var currencyTextField: CurrencyTextField!

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        currencyTextField.minimumFractionDigits = 2
        currencyTextField.maximumFractionDigits = 5
    }

}


extension ViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(textField: UITextField) {
        print("beginEditing", textField.text, currencyTextField.numberValue)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        print("endEditing", textField.text, currencyTextField.numberValue)
    }

}
