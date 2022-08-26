import UIKit

class StationRouteVC: UIViewController {
    
    var chooseTrainDataAPI: [ChooseTrain]?
    var Token: postToken?
    
    @IBOutlet var tableView: UITableView!
    
    private var alongURL = ""
    
    private var access_token = ""
    private var trainsNo: [String] = []
    private var direction: [Int] = []
    private var departureTime: [String] = []
    private var arrivalTime: [String] = []
    private var startStation: String = ""
    private var endStation: String = ""
    
    private var stationName: [String] = []
    private var time: [String] = []
    
    convenience init(access_token: String, trainsNo: [String], direction: [Int], departureTime: [String], arrivalTime: [String], startStation: String, endStation: String) {
        self.init()
        self.access_token = access_token
        self.trainsNo = trainsNo
        self.direction = direction
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.startStation = startStation
        self.endStation = endStation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        componentsInit()
    }
        
    private func componentsInit() {
        
        navigationItem.title = startStation+" ➝ "+endStation
                
        let cellNib = UINib(nibName: "TrainsTableViewCell", bundle: .main)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        tableView.reloadData()
    }
    
    private func getURL(trainNo: String) {
        alongURL = "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/DailyTimetable/Today/TrainNo/\(trainNo)?%24top=30&%24format=JSON"
    }
    
    private func getAlongAPI() {
        if let url: URL = URL(string: alongURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            request.setValue(access_token, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "accept")
            
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                if let error = error {
                    print("\nAPI未成功上傳, 原因是：\(error.localizedDescription)\n")
                    return
                } else if let data = data {
                    print("\n成功接收指定車次API資料\n")
                    DispatchQueue.main.async {
                        do {
                            let data = try JSONDecoder().decode([ChooseTrain].self, from: data)
//                            dump(data)
                            self.chooseTrainDataAPI = data
                            
                            self.setAlongData()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func setAlongData() {
        stationName.removeAll()
        time.removeAll()
        
        chooseTrainDataAPI?.forEach { content1 in
            content1.StopTimes.forEach { content2 in
                stationName.append(content2.StationName.Zh_tw)
                time.append(content2.DepartureTime)
            }
        }
    }
    
}

extension StationRouteVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainsNo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TrainsTableViewCell else {
            fatalError()
        }
        
        cell.setCell(number: trainsNo[indexPath.row], northSouthSelected: direction[indexPath.row], depTime: departureTime[indexPath.row], arrTime: arrivalTime[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let globalQueue = DispatchQueue.global()
        let mainQueue = DispatchQueue.main
        let groupQueue = DispatchGroup()

        globalQueue.async(group: groupQueue) {
            self.getURL(trainNo: self.trainsNo[indexPath.row])
            self.getAlongAPI()
            
            sleep(UInt32(1))
        }
        groupQueue.notify(queue: mainQueue) {
            self.getURL(trainNo: self.trainsNo[indexPath.row])
            self.getAlongAPI()
            let VC = StopAlongingVC(stationName: self.stationName, time: self.time, startStation: self.startStation, endStation: self.endStation, trainNo: self.trainsNo[indexPath.row],direction: self.direction[indexPath.row])

            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}
