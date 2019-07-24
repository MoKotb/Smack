import Foundation

//Seques
let LOGIN_IDENTIFIER = "toLoginVC"
let CREATE_ACCOUNT_IDENTIFIER = "toCreateAccountVC"
let UNWIND_CHANNEL_IDENTIFIER = "unwindToChannels"
let AVATAR_PICKER_IDENTIFIER = "toAvatarPicker"
let AVATAR_CELL = "AvatarCell"

//User Defaults
let USER_EMAIL_KEY = "userEmail"
let USER_TOKEN_KEY = "userToken"
let USER_LOGGED_IN_KEY = "userLogin"

//Typealias
typealias CompletionHandler = (_ Success:Bool) -> ()

//URLS
let BASE_URL = "https://smackappchatyyy.herokuapp.com/v1/"
let REGISTER_URL = "\(BASE_URL)account/register"
let LOGIN_URL = "\(BASE_URL)account/login"
let ADD_USER_URL = "\(BASE_URL)user/add"

// Notification Names
let USER_DATA_CHANGE_NAME = Notification.Name("UserDataChanged")
