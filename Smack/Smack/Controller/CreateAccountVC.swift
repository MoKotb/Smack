import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarImage != "" {
            avatarName = UserDataService.instance.avatarImage
            userImage.image = UIImage(named: avatarName)
        }
    }

    @IBAction func ClosePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_CHANNEL_IDENTIFIER, sender: nil)
    }
    
    @IBAction func ChangeProfileImage(_ sender: Any) {
        performSegue(withIdentifier: AVATAR_PICKER_IDENTIFIER, sender: nil)
    }
    
    @IBAction func ChangeBackgroundColor(_ sender: Any) {
        
    }
    
    @IBAction func CreateAccount(_ sender: Any) {
        SendUserDataToServer()
    }
    
    private func SendUserDataToServer(){
        
        guard let name = usernameTextField.text , usernameTextField.text != "" else {
            return
        }
        guard let email = emailTextField.text , emailTextField.text != "" else {
            return
        }
        guard let password = passwordTextField.text , passwordTextField.text != "" else {
            return
        }
        
        let emailLower = email.lowercased()
        AuthService.instance.RegisterUser(userEmail: emailLower, userPassword: password) { (RegisterSuccess) in
            if RegisterSuccess {
                AuthService.instance.LoginUser(userEmail: emailLower, userPassword: password, completion: { (LoginSuccess) in
                    if LoginSuccess {
                        AuthService.instance.CreateUser(userEmail: emailLower, userName: name, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (CreateSuccess) in
                            if CreateSuccess {
                                print("User Created\(AuthService.instance.authToken)")
                                self.performSegue(withIdentifier: UNWIND_CHANNEL_IDENTIFIER, sender: nil)
                            }
                        })
                    }
                })
            }
        }
    }
}
