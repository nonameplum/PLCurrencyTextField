//
//  CurrencyTextField.swift
//  CurrencyTextField
//
//  Created by Macbook on 20/07/16.
//  Copyright © 2016 Plum's organization. All rights reserved.
//

import UIKit

public class PLCurrencyTextField: UITextField {

    // MARK: - Types

    private enum InitMethod {
        case Coder(NSCoder)
        case Frame(CGRect)
    }

    // MARK: - Properties

    private let currencyFormatter: NSNumberFormatter
    private let internalNumberFormatter: NSNumberFormatter

    // MARK: Public

    /// Returns current number value
    public var numberValue: NSNumber? {
        guard let textValue = text,
            numberValue = currencyFormatter.numberFromString(textValue) else { return nil }

        return numberValue
    }

    /// Configure the minium fraction digits count that will be used by the internal number formatter
    public var minimumFractionDigits: Int {
        didSet {
            currencyFormatter.minimumFractionDigits = minimumFractionDigits
            internalNumberFormatter.minimumFractionDigits = minimumFractionDigits
        }
    }

    /// Configure the maximum fraction digits count that will be used by the internal number formatter
    public var maximumFractionDigits: Int {
        didSet {
            currencyFormatter.maximumFractionDigits = maximumFractionDigits
            internalNumberFormatter.maximumFractionDigits = maximumFractionDigits
        }
    }

    /// Configure locale that will be used by the internal number formatter
    public var locale: NSLocale {
        didSet {
            currencyFormatter.locale = locale
            internalNumberFormatter.locale = locale
        }
    }

    // MARK: - Initialization

    private init(_ initMethod: InitMethod) {
        self.currencyFormatter = NSNumberFormatter()
        self.internalNumberFormatter = NSNumberFormatter()
        self.locale = self.currencyFormatter.locale

        currencyFormatter.numberStyle = .CurrencyStyle
        internalNumberFormatter.numberStyle = .DecimalStyle
        internalNumberFormatter.groupingSeparator = ""

        internalNumberFormatter.minimumFractionDigits = currencyFormatter.minimumFractionDigits
        internalNumberFormatter.maximumFractionDigits = currencyFormatter.maximumFractionDigits

        minimumFractionDigits = currencyFormatter.minimumFractionDigits
        maximumFractionDigits = currencyFormatter.maximumFractionDigits

        switch initMethod {
        case .Coder(let coder): super.init(coder: coder)!
        case .Frame(let frame): super.init(frame: frame)
        }

        keyboardType = .DecimalPad

        addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        addTarget(self, action: #selector(textFieldEditingChanged(_:)), forControlEvents: UIControlEvents.EditingChanged)
        addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
    }

    override convenience public init(frame: CGRect) {
        self.init(.Frame(frame))
    }

    required convenience public init?(coder aDecoder: NSCoder) {
        self.init(.Coder(aDecoder))
    }

    // MARK: - Actions

    internal func textFieldEditingDidBegin(sender: UITextField) {
        guard let value = numberValue else { return }

        text = internalNumberFormatter.stringFromNumber(value)
    }

    internal func textFieldEditingChanged(sender: UITextField) {
        guard let textValue = text where textValue.containsString(currencyFormatter.decimalSeparator) else { return }

        if currencyFormatter.maximumFractionDigits == 0 {
            text = textValue.stringByReplacingOccurrencesOfString(currencyFormatter.decimalSeparator, withString: "")
        } else {
            let decimalFixedValue: String
            if textValue.componentsSeparatedByString(currencyFormatter.decimalSeparator).count-1 > 1 {
                let lastSeparatorRange = textValue.rangeOfString(
                    currencyFormatter.decimalSeparator,
                    options: NSStringCompareOptions.BackwardsSearch,
                    range: textValue.startIndex..<textValue.endIndex,
                    locale: currencyFormatter.locale)

                decimalFixedValue = textValue.stringByReplacingOccurrencesOfString(
                    currencyFormatter.decimalSeparator,
                    withString: "",
                    options: [NSStringCompareOptions.BackwardsSearch],
                    range: lastSeparatorRange)
            } else {
                decimalFixedValue = textValue
            }

            let splittedNumberBySeparator = decimalFixedValue.componentsSeparatedByString(currencyFormatter.decimalSeparator)

            if splittedNumberBySeparator.count > 1,
                let number = splittedNumberBySeparator.first,
                fractionalDigits = splittedNumberBySeparator.last,
                case let removeCount = fractionalDigits.characters.count - currencyFormatter.maximumFractionDigits where removeCount > 0 {
                let removedFraction = fractionalDigits.substringWithRange(fractionalDigits.startIndex..<fractionalDigits.endIndex.advancedBy(-removeCount))
                text = number + currencyFormatter.decimalSeparator + removedFraction
            } else {
                text = decimalFixedValue
            }
        }
    }

    internal func textFieldEditingDidEnd(sender: UITextField) {
        guard let textValue = text,
            value = internalNumberFormatter.numberFromString(textValue) else { return }

        text = currencyFormatter.stringFromNumber(value)
    }

}
