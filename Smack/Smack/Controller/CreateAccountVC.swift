import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]"
    var backgroundColor:UIColor?
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(HideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarImage != "" {
            avatarName = UserDataService.instance.avatarImage
            userImage.image = UIImage(named: avatarName)
            if backgroundColor == nil && avatarName.contains("light") {
                userImage.backgroundColor = UIColor.lightGray
            }
        }
    }

    @objc private func HideKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func ClosePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_CHANNEL_IDENTIFIER, sender: nil)
    }
    
    @IBAction func ChangeProfileImage(_ sender: Any) {
        performSegue(withIdentifier: AVATAR_PICKER_IDENTIFIER, sender: nil)
    }
    
    @IBAction func ChangeBackgroundColor(_ sender: Any) {
        let radColor = CGFloat(arc4random_uniform(255)) / 255
        let greenColor = CGFloat(arc4random_uniform(255)) / 255
        let blueColor = CGFloat(arc4random_uniform(255)) / 255
        avatarColor = "[\(radColor),\(greenColor),\(blueColor),1]"
        backgroundColor = UIColor(red: radColor, green: greenColor, blue: blueColor, alpha: 1)
        UIView.animate(withDuration: 0.3) {
            self.userImage.backgroundColor = self.backgroundColor
        }
    }
    
    @IBAction func CreateAccount(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        SendUserDataToServer()
    }
    
    private func SendUserDataToServer(){
        guard let name = usernameTextField.text , usernameTextField.text != "" else { return }
        guard let email = emailTextField.text , emailTextField.text != "" else { return }
        guard let password = passwordTextField.text , passwordTextField.text != "" else { return }
        let emailLower = email.lowercased()
        
        AuthService.instance.RegisterUser(userEmail: emailLower, userPassword: password) { (RegisterSuccess) in
            if RegisterSuccess {
                AuthService.instance.LoginUser(userEmail: emailLower, userPassword: password, completion: { (LoginSuccess) in
                    if LoginSuccess {
                        AuthService.instance.CreateUser(userEmail: emailLower, userName: name, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (CreateSuccess) in
                            if CreateSuccess {
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                NotificationCenter.default.post(name: USER_DATA_CHANGE_NAME, object: nil)
                                self.performSegue(withIdentifier: UNWIND_CHANNEL_IDENTIFIER, sender: nil)
                            }
                        })
                    }
                })
            }
        }
    }
}
