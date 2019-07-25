import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(HideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        GetUserData()
    }

    @IBAction func ClosePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CreateNewAccount(_ sender: Any) {
        performSegue(withIdentifier: CREATE_ACCOUNT_IDENTIFIER, sender: nil)
    }
    
    private func GetUserData(){
        guard let email = emailTextField.text , emailTextField.text != "" else { return }
        guard let password = passwordTextField.text , passwordTextField.text != "" else { return }
        let emailLower = email.lowercased()
        AuthService.instance.LoginUser(userEmail: emailLower, userPassword: password, completion: { (LoginSuccess) in
            if LoginSuccess {
                AuthService.instance.FindUser(completion: { (FindSuccess) in
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                    NotificationCenter.default.post(name: USER_DATA_CHANGE_NAME, object: nil)
                    self.dismiss(animated: true, completion: nil)
                })
            }
        })
    }
    
    @objc private func HideKeyboard(){
        self.view.endEditing(true)
    }
}
