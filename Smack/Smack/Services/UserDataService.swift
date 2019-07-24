import Foundation

class UserDataService{
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var name = ""
    public private(set) var email = ""
    public private(set) var avatarImage = ""
    public private(set) var avatarColor = ""
    
    func setUserData(id:String,name:String,email:String,avatarImage:String,avatarColor:String){
        self.id = id
        self.name = name
        self.email = email
        self.avatarImage = avatarImage
        self.avatarColor = avatarColor
    }
    
    func setAvatarImage(avatarImage:String){
        self.avatarImage = avatarImage
    }
}
