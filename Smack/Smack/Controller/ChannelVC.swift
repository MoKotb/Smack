import UIKit

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = view.frame.width - 60
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        performSegue(withIdentifier: LOGIN_IDENTIFIER, sender: nil)
    }
    
    @IBAction func PrepareForUnwind(segue : UIStoryboardSegue){
        
    }
}
