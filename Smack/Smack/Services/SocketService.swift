import UIKit
import SocketIO

class SocketService: NSObject {

    override init() {
        super.init()
    }
    
    static let instance = SocketService()
    let socketManager = SocketManager(socketURL: URL(string: BASE_URL)!)
    lazy var socket = socketManager.defaultSocket
    
    func GetManager() -> SocketManager{
        return socketManager
    }
    
    func EstablishConnection(){
        socket.connect()
    }
    
    func CloseConnection() {
        socket.disconnect()
    }
    
    func AddChannel(channelName:String,channelDescription:String,completion: @escaping CompletionHandler){
        socket.emit("newChannel", channelName , channelDescription)
        completion(true)
    }
    
    func GetChannels(completion: @escaping CompletionHandler){
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDescription = dataArray[1] as? String else { return }
            guard let channelID = dataArray[2] as? String else { return }
            let newChannel = Channel(id: channelID, name: channelName, description: channelDescription)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func AddNewMessage(message:String,channelId:String,completion: @escaping CompletionHandler){
        let user = UserDataService.instance
        socket.emit("newMessage", message , user.id , channelId , user.name , user.avatarImage , user.avatarColor )
        completion(true)
    }
    
    func GetMessages(completion: @escaping (_ newMessage:Message) -> Void){
        socket.on("messageCreated") { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let avatarName = dataArray[4] as? String else { return }
            guard let avatarColor = dataArray[5] as? String else { return }
            guard let messageId = dataArray[6] as? String else { return }
            guard let time = dataArray[7] as? String else { return }
            let newMessage = Message(id: messageId, message: messageBody, time: time, channelID: channelId, username: userName, avatarName: avatarName, avatarColor: avatarColor)
            completion(newMessage)
        }
    }
    
    func GetTypingUsers(completion: @escaping (_ typingUser : [String:String]) -> Void){
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let usersTyping = dataArray[0] as? [String:String] else { return }
            completion(usersTyping)
        }
    }
    
    func StopTyping(channelID:String){
        socket.emit("stopType", UserDataService.instance.name,channelID)
    }
    
    func StartTyping(channelID:String){
        socket.emit("startType", UserDataService.instance.name,channelID)
    }
}
