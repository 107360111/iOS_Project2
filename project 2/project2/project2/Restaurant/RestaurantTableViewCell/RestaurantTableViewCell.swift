import UIKit
import SDWebImage

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet var pictureView: UIImageView!
    
    @IBOutlet var name: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var ranking: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCell(shopName: String, shopAddress: String, shopDistance: Double, shopRating: Double, reviews: Int, picture: String) {
                
        name.text = shopName
        
        address.text = shopAddress
        address.textColor = UIColor.lightGray
        
        distance.text = String(format: "距離 : %.2f 公里",shopDistance)
        distance.textColor = UIColor.lightGray
        
        ranking.text = String(format: "評價 : %.1f (%d則評論) ",shopRating,reviews)
        
        
        showImage(url: picture)
    }
    
    private func showImage(url: String) {
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.main.async {
            self.pictureView.sd_setImage(with: url)
        }
    }
    
}
