import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var unreadChannels = [String]()
    var selectedChannel:Channel?
    
    func GetAllChannels(completion: @escaping CompletionHandler){
        let header = ["Authorization":"Bearer \(AuthService.init().authToken)","Content-Type":"application/json; charset=utf-8"]
        Alamofire.request(CHANNELS_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else { return }
                do{
                    if let json = try JSON(data:data).array{
                        for item in json{
                            let id = item["_id"].stringValue
                            let name = item["name"].stringValue
                            let description = item["description"].stringValue
                            let channel = Channel(id: id, name: name, description: description)
                            self.channels.append(channel)
                        }
                        NotificationCenter.default.post(name: NOTIFICATION_RELOAD_CHANNELS, object: nil)
                        completion(true)
                    }else{
                        completion(false)
                    }
                }catch let error{
                    completion(false)
                    debugPrint(error.localizedDescription)
                }
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func GetMessagesByChannel(channelID:String,completion: @escaping CompletionHandler){
        let header = ["Authorization":"Bearer \(AuthService.init().authToken)","Content-Type":"application/json; charset=utf-8"]
        Alamofire.request("\(MESSAGES_URL)\(channelID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil{
                self.ClearMessages()
                guard let data = response.data else { return }
                do{
                    if let json = try JSON(data:data).array{
                        for item in json{
                            let id = item["_id"].stringValue
                            let messageBody = item["messageBody"].stringValue
                            let timeStamp = item["timeStamp"].stringValue
                            let channelId = item["channelId"].stringValue
                            let userName = item["userName"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColor = item["userAvatarColor"].stringValue
                            let message = Message(id: id, message: messageBody, time: timeStamp, channelID: channelId, username: userName, avatarName: userAvatar, avatarColor: userAvatarColor)
                            self.messages.append(message)
                        }
                        completion(true)
                    }else{
                        completion(false)
                    }
                }catch let error{
                    completion(false)
                    debugPrint(error.localizedDescription)
                }
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func ClearMessages(){
        self.messages.removeAll()
    }
    
    func ClearChannels(){
        self.channels.removeAll()
    }
}
