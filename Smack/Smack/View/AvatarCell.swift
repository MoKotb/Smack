import UIKit

enum AvatarType{
    case Dark
    case Light
}

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SetupView()
    }
    
    private func SetupView(){
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func ConfigureCell(index:Int,type:AvatarType){
        if type == .Dark{
            self.layer.backgroundColor = UIColor.lightGray.cgColor
            avatarImage.image = UIImage(named: "dark\(index)")
        }else{
            self.layer.backgroundColor = UIColor.gray.cgColor
            avatarImage.image = UIImage(named: "light\(index)")
        }
    }
    
}
