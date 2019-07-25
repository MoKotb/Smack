import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PrepareMenu()
        isLoggedIn()
        DownloadData()
    }
    
    private func DownloadData(){
        if AuthService.instance.isLoggedIn{
            MessageService.instance.GetAllChannels { (Success) in }
        }
    }
    
    private func PrepareMenu(){
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    private func isLoggedIn(){
        if AuthService.instance.isLoggedIn{
            AuthService.instance.FindUser { (FindSuccess) in
                NotificationCenter.default.post(name: USER_DATA_CHANGE_NAME, object: nil)
            }
        }
    }
}
