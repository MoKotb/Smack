import UIKit

@IBDesignable
class TextFieldView: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        SetupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        SetupView()
    }
    
    private func SetupView(){
        let color = #colorLiteral(red: 0.3631127477, green: 0.4045833051, blue: 0.8775706887, alpha: 1)
        if let place = placeholder{
            let placeholder = NSAttributedString(string: place, attributes: [NSAttributedString.Key.foregroundColor:color])
            attributedPlaceholder = placeholder
        }
    }
    
}
