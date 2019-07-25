import UIKit

class ChannelVC: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var channelsTableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImage: CircleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelsTableView.delegate = self
        channelsTableView.dataSource = self
        
        self.revealViewController().rearViewRevealWidth = view.frame.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateUserData(_:)), name: USER_DATA_CHANGE_NAME, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SetUserData()
    }
    
    @objc private func UpdateUserData(_ notification:Notification){
        SetUserData()
    }
    
    private func SetUserData(){
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
        if AuthService.instance.isLoggedIn{
            let channel = AddChannelVC()
            channel.modalPresentationStyle = .custom
            present(channel, animated: true, completion: nil)
        }
    }
    
    @IBAction func PrepareForUnwind(segue : UIStoryboardSegue){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CHANNEL_CELL, for: indexPath) as? ChannelCell{
            let channel = MessageService.instance.channels[indexPath.row]
            cell.SetupCell(channel: channel)
            return cell
        }else{
            return ChannelCell()
        }
    }
    
}
