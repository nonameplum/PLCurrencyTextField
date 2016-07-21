Pod::Spec.new do |spec|
    spec.name         = 'CurrencyTextField'
    spec.version      = '1.0.0'
    spec.license      = { :type => 'MIT' }
    spec.homepage     = 'https://github.com/nonameplum/CurrencyTextField'
    spec.authors      = { 'Łukasz Śliwiński' => 'sliwinski.lukas@gmail.com' }
    spec.summary      = 'UITextField that supports currency in friendly way.'
    spec.source       = { :git => 'https://github.com/nonameplum/CurrencyTextField.git', :tag => spec.version }
    spec.source_files = 'Sources/*.{swift}'
    spec.framework    = 'UIKit'
end