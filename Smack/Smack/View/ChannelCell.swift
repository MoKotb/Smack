import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.15).cgColor
        }else{
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func SetupCell(channel:Channel){
        channelName.text = "#\(channel.name ?? "")"
        channelName.font = UIFont(name: "AvenirNext-Regular", size: 18)
        for id in MessageService.instance.unreadChannels{
            if id == channel.id{
                channelName.font = UIFont(name: "AvenirNext-Bold", size: 24)
            }
        }
    }
}
