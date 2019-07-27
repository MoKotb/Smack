import Foundation
import Alamofire
import SwiftyJSON

class AuthService{
    
    static let instance = AuthService()
    private let userDefaults = UserDefaults.standard
 
    var isLoggedIn: Bool{
        get{
            return userDefaults.bool(forKey: USER_LOGGED_IN_KEY)
        }
        set{
            userDefaults.set(newValue, forKey: USER_LOGGED_IN_KEY)
        }
    }
    
    var authToken: String{
        get{
            return userDefaults.value(forKey: USER_TOKEN_KEY) as! String
        }
        set{
            userDefaults.set(newValue, forKey: USER_TOKEN_KEY)
        }
    }
    
    var userEmail: String{
        get{
            return userDefaults.value(forKey: USER_EMAIL_KEY) as! String
        }
        set{
            userDefaults.set(newValue, forKey: USER_EMAIL_KEY)
        }
    }
    
    func RegisterUser(userEmail:String,userPassword:String, completion:@escaping CompletionHandler){
        let header = ["Content-Type":"application/json; charset=utf-8"]
        let body:[String:Any] = ["email":userEmail,"password":userPassword]
        Alamofire.request(REGISTER_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (response) in
            if response.result.error == nil{
                completion(true)
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func LoginUser(userEmail:String,userPassword:String, completion:@escaping CompletionHandler){
        let header = ["Content-Type":"application/json; charset=utf-8"]
        let body:[String:Any] = ["email":userEmail,"password":userPassword]
        Alamofire.request(LOGIN_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {
                    return
                }
                do{
                    let json = try JSON(data:data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    self.isLoggedIn = true
                    completion(true)
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
    
    func CreateUser(userEmail:String,userName:String,avatarName:String,avatarColor:String, completion:@escaping CompletionHandler){
        let header = ["Authorization":"Bearer \(self.authToken)","Content-Type":"application/json; charset=utf-8"]
        let body:[String:Any] = ["name":userName,"email":userEmail,"avatarName":avatarName,"avatarColor":avatarColor]
        Alamofire.request(ADD_USER_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {
                    return
                }
                self.SetUserData(data: data)
                completion(true)
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func FindUser(completion:@escaping CompletionHandler){
        let header = ["Authorization":"Bearer \(self.authToken)","Content-Type":"application/json; charset=utf-8"]
        Alamofire.request("\(FIND_USER_URL)\(self.userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else {
                    return
                }
                self.SetUserData(data: data)
                completion(true)
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    private func SetUserData(data:Data){
        do{
            let json = try JSON(data:data)
            let id = json["_id"].stringValue
            let avatarColor = json["avatarColor"].stringValue
            let avatarName = json["avatarName"].stringValue
            let email = json["email"].stringValue
            let name = json["name"].stringValue
            UserDataService.instance.setUserData(id: id, name: name, email: email, avatarImage: avatarName, avatarColor: avatarColor)
        }catch let error{
            debugPrint(error.localizedDescription)
        }
    }
}
