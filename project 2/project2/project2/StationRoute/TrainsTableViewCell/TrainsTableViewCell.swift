import UIKit

class TrainsTableViewCell: UITableViewCell {

    
    @IBOutlet var stack: UIStackView!
    
    @IBOutlet var trainsNo: UILabel!
    @IBOutlet var direction: UILabel!
    @IBOutlet var departureTime: UILabel!
    @IBOutlet var timeConsume: UILabel!
    @IBOutlet var arrivalTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    
    func setCell(number: String = "", northSouthSelected: Int = 0, depTime: String = "", arrTime: String = "") {
        stack.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        stack.layer.cornerRadius = 10
        
        trainsNo.text = number
        trainsNo.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        switch northSouthSelected {
        case 0:
            direction.text = "南下"
        case 1:
            direction.text = "北上"
        default:
            break
        }
        direction.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        departureTime.text = depTime
        arrivalTime.text = arrTime
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        if let startTime = timeFormatter.date(from: depTime),
           let endTime = timeFormatter.date(from: arrTime) {
            
            let calender = Calendar.current
            let timeComponents = calender.dateComponents([.hour, .minute], from: startTime, to: endTime)
            if timeComponents.hour == 0 {
                timeConsume.text = String(format: "%d分鐘", timeComponents.minute!)
            } else if timeComponents.minute == 0 {
                timeConsume.text = String(format: "%d時", timeComponents.hour!)
            } else {
                timeConsume.text = String(format: "%d時%d分鐘", timeComponents.hour!, timeComponents.minute!)
            }
        }
    }
    
}
