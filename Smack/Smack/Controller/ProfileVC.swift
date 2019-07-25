import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var userImage: CircleImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUserData()
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(CloseWhenTap))
        backgroundView.addGestureRecognizer(closeTouch)
    }

    private func SetUserData(){
        userName.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        userImage.image = UIImage(named: UserDataService.instance.avatarImage)
        userImage.backgroundColor = UserDataService.instance.GetAvatarBackground(RBGColor: UserDataService.instance.avatarColor)
    }
    
    @objc private func CloseWhenTap(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ClosePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func LogoutPressed(_ sender: Any) {
        UserDataService.instance.LogoutUser()
        NotificationCenter.default.post(name: USER_DATA_CHANGE_NAME, object: nil)
        dismiss(animated: true, completion: nil)
    }
}
