import UIKit

class StopAlongingVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var stationName: [String] = []
    private var time: [String] = []
    private var startStation: String = ""
    private var endStation: String = ""
    private var trainNo: String = ""
    private var direction: Int = 0
    
    convenience init(stationName: [String] = [], time: [String] = [],startStation: String = "",endStation: String = "",trainNo: String = "", direction: Int = 0) {
        self.init()
        self.stationName = stationName
        self.time = time
        self.startStation = startStation
        self.endStation = endStation
        self.trainNo = trainNo
        self.direction = direction
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        componentsInit()
    }

    private func componentsInit() {
        if direction == 0 {
            navigationItem.title = "車次 : "+trainNo+"     (南下)"
        } else {
            navigationItem.title = "車次 : "+trainNo+"     (北上)"
        }
        let cellNib = UINib(nibName: "AlongingTableViewCell", bundle: .main)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
}

extension StopAlongingVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AlongingTableViewCell else {
            fatalError()
        }
        
        cell.setCell(number: indexPath.row+1, stationName: stationName[indexPath.row], time: time[indexPath.row])
        
        if stationName[indexPath.row] == startStation {
            cell.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
        if stationName[indexPath.row] == endStation {
            cell.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
