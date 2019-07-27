import Foundation

//Seques
let LOGIN_IDENTIFIER = "toLoginVC"
let CREATE_ACCOUNT_IDENTIFIER = "toCreateAccountVC"
let UNWIND_CHANNEL_IDENTIFIER = "unwindToChannels"
let AVATAR_PICKER_IDENTIFIER = "toAvatarPicker"
let AVATAR_CELL = "AvatarCell"
let CHANNEL_CELL = "ChannelCell"
let MESSAGE_CELL = "MessageCell"

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
let FIND_USER_URL = "\(BASE_URL)user/byEmail/"
let CHANNELS_URL = "\(BASE_URL)channel/"
let MESSAGES_URL = "\(BASE_URL)message/byChannel/"

// Notification Names
let USER_DATA_CHANGE_NAME = Notification.Name("UserDataChanged")
let NOTIFICATION_RELOAD_CHANNELS = Notification.Name("reloadChannel")
let NOTIFICATION_SELECTED_CHANNEL = Notification.Name("selectedChannel")
