//
//  CurrencyTextField.swift
//  CurrencyTextField
//
//  Created by Macbook on 20/07/16.
//  Copyright © 2016 Plum's organization. All rights reserved.
//

import UIKit

open class PLCurrencyTextField: UITextField {

    // MARK: - Types

    fileprivate enum InitMethod {
        case coder(NSCoder)
        case frame(CGRect)
    }

    // MARK: - Properties

    fileprivate let currencyFormatter: NumberFormatter
    fileprivate let internalNumberFormatter: NumberFormatter

    // MARK: Public

    /// Returns current number value
    open var numberValue: NSNumber? {
        guard let textValue = text,
            let numberValue = currencyFormatter.number(from: textValue) else { return nil }

        return numberValue
    }

    /// Configure the minium fraction digits count that will be used by the internal number formatter
    open var minimumFractionDigits: Int {
        didSet {
            currencyFormatter.minimumFractionDigits = minimumFractionDigits
            internalNumberFormatter.minimumFractionDigits = minimumFractionDigits
        }
    }

    /// Configure the maximum fraction digits count that will be used by the internal number formatter
    open var maximumFractionDigits: Int {
        didSet {
            currencyFormatter.maximumFractionDigits = maximumFractionDigits
            internalNumberFormatter.maximumFractionDigits = maximumFractionDigits
        }
    }

    /// Configure locale that will be used by the internal number formatter
    open var locale: Locale {
        didSet {
            currencyFormatter.locale = locale
            internalNumberFormatter.locale = locale
        }
    }

    // MARK: - Initialization

    fileprivate init(_ initMethod: InitMethod) {
        self.currencyFormatter = NumberFormatter()
        self.internalNumberFormatter = NumberFormatter()
        self.locale = self.currencyFormatter.locale

        currencyFormatter.numberStyle = .currency
        internalNumberFormatter.numberStyle = .decimal
        internalNumberFormatter.groupingSeparator = ""

        internalNumberFormatter.minimumFractionDigits = currencyFormatter.minimumFractionDigits
        internalNumberFormatter.maximumFractionDigits = currencyFormatter.maximumFractionDigits

        minimumFractionDigits = currencyFormatter.minimumFractionDigits
        maximumFractionDigits = currencyFormatter.maximumFractionDigits

        switch initMethod {
        case .coder(let coder): super.init(coder: coder)!
        case .frame(let frame): super.init(frame: frame)
        }

        keyboardType = .decimalPad

        addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: UIControlEvents.editingDidBegin)
        addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: UIControlEvents.editingChanged)
        addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: UIControlEvents.editingDidEnd)
    }

    override convenience public init(frame: CGRect) {
        self.init(.frame(frame))
    }

    required convenience public init?(coder aDecoder: NSCoder) {
        self.init(.coder(aDecoder))
    }

    // MARK: - Actions

    internal func textFieldEditingDidBegin(_ sender: UITextField) {
        guard let value = numberValue else { return }

        text = internalNumberFormatter.string(from: value)
    }

    internal func textFieldEditingChanged(_ sender: UITextField) {
        guard let textValue = text, textValue.contains(currencyFormatter.decimalSeparator) else { return }

        if currencyFormatter.maximumFractionDigits == 0 {
            text = textValue.replacingOccurrences(of: currencyFormatter.decimalSeparator, with: "")
        } else {
            let decimalFixedValue: String
            
            if textValue.components(separatedBy: currencyFormatter.decimalSeparator).count-1 > 1 {
                let lastSeparatorRange = textValue.range(
                    of: currencyFormatter.decimalSeparator,
                    options: NSString.CompareOptions.backwards,
                    range: textValue.startIndex..<textValue.endIndex,
                    locale: currencyFormatter.locale)

                decimalFixedValue = textValue.replacingOccurrences(
                    of: currencyFormatter.decimalSeparator,
                    with: "",
                    options: [NSString.CompareOptions.backwards],
                    range: lastSeparatorRange)
            } else {
                decimalFixedValue = textValue
            }

            let splittedNumberBySeparator = decimalFixedValue.components(separatedBy: currencyFormatter.decimalSeparator)

            if splittedNumberBySeparator.count > 1,
                let number = splittedNumberBySeparator.first,
                let fractionalDigits = splittedNumberBySeparator.last,
                case let removeCount = fractionalDigits.characters.count - currencyFormatter.maximumFractionDigits, removeCount > 0 {
                let removedFraction = fractionalDigits.substring(with: fractionalDigits.startIndex..<fractionalDigits.characters.index(fractionalDigits.endIndex, offsetBy: -removeCount))
                text = number + currencyFormatter.decimalSeparator + removedFraction
            } else {
                text = decimalFixedValue
            }
        }
    }

    internal func textFieldEditingDidEnd(_ sender: UITextField) {
        guard let textValue = text,
            let value = internalNumberFormatter.number(from: textValue) else { return }

        text = currencyFormatter.string(from: value)
    }

}
