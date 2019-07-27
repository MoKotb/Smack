import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var nameTextField: TextFieldView!
    @IBOutlet weak var descriptionTextField: TextFieldView!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(CloseWhenTap))
        backgroundView.addGestureRecognizer(closeTouch)
        let tap = UITapGestureRecognizer(target: self, action: #selector(HideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func CloseWhenTap(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func HideKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func CreateNewChannel(_ sender: Any) {
        GetChannelData()
    }
    
    @IBAction func ClosePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func GetChannelData(){
        guard let name = nameTextField.text , nameTextField.text != "" else { return }
        guard let description = descriptionTextField.text , descriptionTextField.text != "" else { return }
        SocketService.instance.AddChannel(channelName: name, channelDescription: description) { (Success) in
            if Success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
