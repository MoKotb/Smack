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
    
    func GetAvatarBackground(RBGColor:String) -> UIColor{
        let defaultColor = UIColor.lightGray
        let scanner = Scanner(string: RBGColor)
        let skipCharacters = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipCharacters
        
        var redColor , greenColor , blueColor , alphaColor :NSString?
        scanner.scanUpToCharacters(from: comma, into: &redColor)
        scanner.scanUpToCharacters(from: comma, into: &greenColor)
        scanner.scanUpToCharacters(from: comma, into: &blueColor)
        scanner.scanUpToCharacters(from: comma, into: &alphaColor)
        
        guard let red = redColor else { return defaultColor }
        guard let green = greenColor else { return defaultColor }
        guard let blue = blueColor else { return defaultColor }
        guard let alpha = alphaColor else { return defaultColor }
        
        let redFloat = CGFloat(red.doubleValue)
        let greenFloat = CGFloat(green.doubleValue)
        let blueFloat = CGFloat(blue.doubleValue)
        let alphaFloat = CGFloat(alpha.doubleValue)
        
        let SelectedColor = UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: alphaFloat)
        return SelectedColor
    }
    
    func LogoutUser(){
        self.id = ""
        self.name = ""
        self.email = ""
        self.avatarImage = ""
        self.avatarColor = ""
        AuthService.instance.authToken = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        MessageService.instance.ClearChannels()
        MessageService.instance.ClearMessages()
    }
}
