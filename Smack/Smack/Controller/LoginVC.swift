import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func ClosePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CreateNewAccount(_ sender: Any) {
        performSegue(withIdentifier: CREATE_ACCOUNT_IDENTIFIER, sender: nil)
    }
}
