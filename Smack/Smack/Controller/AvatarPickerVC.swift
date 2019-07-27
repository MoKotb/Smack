import UIKit

class AvatarPickerVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var avatarType: UISegmentedControl!
    @IBOutlet weak var avatarCollection: UICollectionView!
    var type:AvatarType = AvatarType.Dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarCollection.delegate = self
        avatarCollection.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AVATAR_CELL, for: indexPath) as? AvatarCell{
            cell.ConfigureCell(index: indexPath.item, type: type)
            return cell
        }
        return AvatarCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == .Dark{
            UserDataService.instance.setAvatarImage(avatarImage: "dark\(indexPath.item)")
        }else{
            UserDataService.instance.setAvatarImage(avatarImage: "light\(indexPath.item)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfColumns : CGFloat = 3
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 4
        }
        let spaceBetweenCells : CGFloat = 10
        let padding : CGFloat = 40
        let CellDimension = ((avatarCollection.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        return CGSize(width: CellDimension, height: CellDimension)
    }
    
    @IBAction func ChangeAvatarType(_ sender: Any) {
        if avatarType.selectedSegmentIndex == 0{
            type = AvatarType.Dark
        }else{
            type = AvatarType.Light
        }
        avatarCollection.reloadData()
    }
    
    @IBAction func BackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
