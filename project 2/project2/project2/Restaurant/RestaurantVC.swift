import UIKit

class RestaurantVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
        
    private var shopName: [String] = []
    private var shopAddress: [String] = []
    private var shopRating: [Double] = []
    private var shopReviewsNumber: [Int] = []
    private var shopPicture: [String] = []
    private var distance: [Double] = []
    
    convenience init(shopName: [String], shopAddress: [String], shopRating: [Double], shopReviewsNumber: [Int], shopPicture: [String], distance: [Double]) {
        self.init()
        self.shopName = shopName
        self.shopAddress = shopAddress
        self.shopRating = shopRating
        self.shopReviewsNumber = shopReviewsNumber
        self.shopPicture = shopPicture
        self.distance = distance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        componentsInit()
    }
    
    private func componentsInit() {
        let cellNib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
}

extension RestaurantVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return shopName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RestaurantTableViewCell else {
            fatalError()
        }
        
        cell.setCell(shopName: shopName[indexPath.row], shopAddress: shopAddress[indexPath.row], shopDistance: distance[indexPath.row], shopRating: shopRating[indexPath.row], reviews: shopReviewsNumber[indexPath.row], picture: shopPicture[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
