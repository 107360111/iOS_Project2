import UIKit

class TrainsTableView: UITableViewCell {
    
    @IBOutlet var stack: UIStackView!
    
    @IBOutlet var trainsNo: UILabel!
    @IBOutlet var direction: UILabel!
    @IBOutlet var departureTime: UILabel!
    @IBOutlet var timeConsume: UILabel!
    @IBOutlet var arrivalTime: UILabel!
    
    enum DirectionMode {
    case north
    case south
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        
    }
    
    func setCell(number: String = "", northSouthSelected: DirectionMode = .north, depTime: String = "", arrTime: String = "") {
        stack.backgroundColor = UIColor.init(red: 255/255.0, green: 213/255.0, blue: 128/255.0, alpha: 1)
        stack.layer.cornerRadius = 15
        
        trainsNo.text = number
        
        switch northSouthSelected {
        case .north:
            direction.text = "北上"
        case .south:
            direction.text = "南下"
        }
        
        departureTime.text = depTime
        arrivalTime.text = arrTime
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        if let startTime = timeFormatter.date(from: depTime),
           let endTime = timeFormatter.date(from: arrTime) {
            
            let calender = Calendar.current
            let timeComponents = calender.dateComponents([.hour, .minute], from: startTime, to: endTime)
            let costTime: Int = Int(timeComponents.hour!) * 60 + Int(timeComponents.minute!)
            
            timeConsume.text = String(format: "%d分鐘", costTime)
        }
    }
}

