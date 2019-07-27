import UIKit

class ChatVC: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var messageTextField: TextFieldView!
    @IBOutlet weak var messagesTable: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typingText: UILabel!
    
    var isTyping:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupView()
        isLoggedIn()
        AddNotification()
        GetMessage()
        SetUserTyping()
    }
    
    private func SetupView(){
        messagesTable.dataSource = self
        messagesTable.delegate = self
        
        sendButton.isHidden = true
        view.bindToKeyboard()
        PrepareMenu()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CloseHandle))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func CloseHandle(){
        view.endEditing(true)
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
        }else{
            navigationItem.title = "Please Log in"
        }
    }
    
    private func AddNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateUserData(_:)), name: USER_DATA_CHANGE_NAME, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SelectedChannel(_:)), name: NOTIFICATION_SELECTED_CHANNEL, object: nil)
    }
    
    @objc private func UpdateUserData(_ notification:Notification){
        if AuthService.instance.isLoggedIn{
            GetChannels()
        }else{
            navigationItem.title = "Please Log in"
            messagesTable.reloadData()
        }
    }
    
    private func GetChannels(){
        MessageService.instance.GetAllChannels { (Success) in
            if Success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.ChangeChannelName()
                }else{
                    self.navigationItem.title = "No Channel Yet !"
                }
            }
        }
    }
    
    @objc private func SelectedChannel(_ notification:Notification){
        ChangeChannelName()
    }
    
    func ChangeChannelName(){
        navigationItem.title = "#\(MessageService.instance.selectedChannel?.name ?? "")"
        GetMessageByChannel()
    }
    
    private func GetMessageByChannel(){
        guard let channelID = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.GetMessagesByChannel(channelID: channelID) { (Success) in
            if Success{
                self.messagesTable.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(item: MessageService.instance.messages.count - 1, section: 0)
                    self.messagesTable.scrollToRow(at: endIndex, at: .bottom, animated: true)
                }
            }
        }
    }
    
    private func GetMessage(){
        SocketService.instance.GetMessages { (newMessage) in
            if AuthService.instance.isLoggedIn && MessageService.instance.selectedChannel?.id == newMessage.channelID {
                MessageService.instance.messages.append(newMessage)
                self.messagesTable.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(item: MessageService.instance.messages.count - 1, section: 0)
                    self.messagesTable.scrollToRow(at: endIndex, at: .bottom, animated: true)
                }
            }
        }
    }
    
    private func SetUserTyping(){
        SocketService.instance.GetTypingUsers { (UsersTyping) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = ""
            var numbersOfUsers = 0
            for ( userTyping , channel ) in UsersTyping{
                if userTyping != UserDataService.instance.name && channel == channelId{
                    if names == ""{
                        names = userTyping
                    }else{
                        names = "\(names), \(userTyping)"
                    }
                    numbersOfUsers += 1
                }
            }
            if numbersOfUsers > 0 && AuthService.instance.isLoggedIn{
                var verb = "is"
                if numbersOfUsers > 1{
                    verb = "are"
                }
                self.typingText.text = "\(names) \(verb) typing a message ..."
            }else{
                self.typingText.text = ""
            }
        }
    }
    
    @IBAction func SendMessage(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            PrepareMessageToSend()
        }
    }
    
    private func PrepareMessageToSend(){
        guard let message = messageTextField.text , messageTextField.text != "" else { return }
        guard let channelID = MessageService.instance.selectedChannel?.id else { return }
        SocketService.instance.AddNewMessage(message: message, channelId: channelID) { (Success) in
            if Success {
                self.messageTextField.text = ""
                self.messageTextField.resignFirstResponder()
                self.isTyping = false
                self.sendButton.isHidden = true
                SocketService.instance.StopTyping(channelID: channelID)
            }
        }
    }
    
    @IBAction func messageEditing(_ sender: Any) {
        guard let channelID = MessageService.instance.selectedChannel?.id else { return }
        if messageTextField.text == "" {
            isTyping = false
            sendButton.isHidden = true
            SocketService.instance.StopTyping(channelID: channelID)
        }else{
            if isTyping == false {
                sendButton.isHidden = false
                SocketService.instance.StartTyping(channelID: channelID)
            }
            isTyping = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MESSAGE_CELL, for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.SetupCell(message: message)
            return cell
        }else{
            return MessageCell()
        }
    }
}
