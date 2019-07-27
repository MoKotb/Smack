import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImage: CircleImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var messageText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func SetupCell(message : Message){
        userImage.image = UIImage(named: message.avatarName)
        userImage.backgroundColor = UserDataService.instance.GetAvatarBackground(RBGColor: message.avatarColor)
        userName.text = message.username
        messageText.text = message.message
        if let isoData = message.time {
            timeText.text = SetTime(time: isoData)
        }
    }
    
    func SetTime(time:String) -> String{
        let endIndex = time.index(time.endIndex, offsetBy: -5)
        let newTime = String(time[..<endIndex])
        
        let isoFormatter = ISO8601DateFormatter()
        let isoData = isoFormatter.date(from: newTime.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d,h:mm a"
        if let finalData = isoData {
            let finalData = newFormatter.string(from: finalData)
            return finalData
        }
        return ""
    }
}
