import UIKit

class AlongingTableViewCell: UITableViewCell {

    @IBOutlet var stopAlonging: UILabel!
    @IBOutlet var departureTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCell(number: Int, stationName: String, time: String) {
        stopAlonging.text = String(format: "%d. %@高鐵站", number, stationName)
        departureTime.text = time
    }
}
