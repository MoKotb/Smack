import UIKit

class ChannelVC: UIViewController {

    @IBOutlet weak var channelsTableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImage: CircleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = view.frame.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateUserData(_:)), name: USER_DATA_CHANGE_NAME, object: nil)
    }
    
    @objc private func UpdateUserData(_ notification:Notification){
        if AuthService.instance.isLoggedIn{
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataService.instance.avatarImage)
            userImage.backgroundColor = UserDataService.instance.GetAvatarBackground(RBGColor: UserDataService.instance.avatarColor)
        }else{
            loginButton.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }else{
            performSegue(withIdentifier: LOGIN_IDENTIFIER, sender: nil)
        }
    }
    
    @IBAction func AddNewChannel(_ sender: Any) {
        
    }
    
    @IBAction func PrepareForUnwind(segue : UIStoryboardSegue){
        
    }
}
