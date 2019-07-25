import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    
    func GetAllChannels(completion: @escaping CompletionHandler){
        let header = ["Authorization":"Bearer \(AuthService.init().authToken)","Content-Type":"application/json; charset=utf-8"]
        Alamofire.request(CHANNELS_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {
                    return
                }
                do{
                    if let json = try JSON(data:data).array{
                        for item in json{
                            let id = item["_id"].stringValue
                            let name = item["name"].stringValue
                            let description = item["description"].stringValue
                            let channel = Channel(id: id, name: name, description: description)
                            self.channels.append(channel)
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
    
}
