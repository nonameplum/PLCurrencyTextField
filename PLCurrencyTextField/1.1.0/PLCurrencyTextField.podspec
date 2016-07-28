Pod::Spec.new do |spec|
    spec.name         = 'PLCurrencyTextField'
    spec.version      = '1.1.0'
    spec.license      = { :type => 'MIT' }
    spec.homepage     = 'https://github.com/nonameplum/PLCurrencyTextField'
    spec.authors      = { 'Łukasz Śliwiński' => 'sliwinski.lukas@gmail.com' }
    spec.summary      = 'UITextField that provide simple and user friendly support for the amount in the currency.'
    spec.source       = { :git => 'https://github.com/nonameplum/PLCurrencyTextField.git', :tag => spec.version }
    spec.source_files = 'Sources/*.{swift}'
    spec.framework    = 'UIKit'
    spec.platform     = :ios, '8.0'
end