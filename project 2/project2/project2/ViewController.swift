import UIKit
import MapKit
import Toast

class ViewController: UIViewController {
    var stationAPIData: [Station]?
    var scheduleDataAPI: [Schedule]?
    var restaurantDataAPI: Restaurant?
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var startStationField: UISearchBar!
    @IBOutlet var endStationField: UISearchBar!
    
    @IBOutlet var startStack: UIStackView!
    @IBOutlet var endStack: UIStackView!
    
    @IBOutlet var myLocation: UIButton!
    
    let Authorization = "Bearer /(輸入終端機產生之access_token)"
    
    let stationURL = "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/Station?%24top=30&%24format=JSON"
    
    var routeURL = ""
    
    let restaurantURL = "https://api.bluenet-ride.com/v2_0/lineBot/restaurant/get"
            
    var stationName: [String] = []
    var stationAddress: [String] = []
    
    var trainsNo: [String] = []
    var direction: [Int] = []
    var departureTime: [String] = []
    var arrivalTime: [String] = []
    
    var shopName: [String] = []
    var shopAddress: [String] = []
    var shopRating: [Double] = []
    var shopReviewsNumber: [Int] = []
    var shopPicture: [String] = []
    var distanceMeter: [Double] = []
        
    static var location:CLLocationManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        componentsInit()
    }
    
    private func componentsInit() {
        
        getStationAPI()
    }
    
    private func getStationAPI() {
        if let url: URL = URL(string: stationURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            request.setValue(Authorization, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "accept")
            
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                if let error = error {
                    print("\nAPI未成功上傳, 原因是：\(error.localizedDescription)\n")
                    return
                } else if let data = data {
                    print("\n成功接收車站API資料\n")
                    DispatchQueue.main.async {
                        do {
                            let data = try JSONDecoder().decode([Station].self, from: data)
//                            dump(data)
                            self.stationAPIData = data
                            
                            self.setAnnotation()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func setAnnotation() {
        stationAPIData?.forEach { content in
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2DMake(content.StationPosition.PositionLat, content.StationPosition.PositionLon)
            
            annotation.title = String(format: "%@", content.StationName.Zh_tw)
            annotation.subtitle = String(format: "%@", content.StationAddress)
            
            mapView.addAnnotation(annotation)
            
            stationName.append(content.StationName.Zh_tw + "高鐵站")
            stationAddress.append(content.StationAddress)
            
        }
    }
    
    private func getURL(startID: String, endID: String) {
        let updateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: updateTime)
        
        routeURL = "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/DailyTimetable/OD/\(startID)/to/\(endID)/\(dateString)?%24top=30&%24format=JSON"
    }
    
    private func getRouteAPI() {
        if let url: URL = URL(string: routeURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            request.setValue(Authorization, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "accept")
            
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                if let error = error {
                    print("\nAPI未成功上傳, 原因是：\(error.localizedDescription)\n")
                    return
                } else if let data = data {
                    print("\n成功接收時程表API資料\n")
                    DispatchQueue.main.async {
                        do {
                            let data = try JSONDecoder().decode([Schedule].self, from: data)
//                            dump(data)
                            self.scheduleDataAPI = data
                            
                            self.setScheduleData()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func setScheduleData() {
        trainsNo.removeAll()
        direction.removeAll()
        departureTime.removeAll()
        arrivalTime.removeAll()
        
        scheduleDataAPI?.forEach { content in
            trainsNo.append(content.DailyTrainInfo.TrainNo)
            direction.append(content.DailyTrainInfo.Direction)
            departureTime.append(content.OriginStopTime.DepartureTime)
            arrivalTime.append(content.DestinationStopTime.ArrivalTime)
        }
    }

    private func getRestaurantAPI(latitude: Double, longitude: Double) {
        let data = restaurantDataModel()
        
        data.lastIndex = -1
        data.count = 15
        data.type = [7]
        data.lat = latitude
        data.lng = longitude
        data.range = String(2000)
        
        let jsonData = try? JSONEncoder().encode(data)
        
        if let url: URL = URL(string: restaurantURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                if let error = error {
                    print("\nAPI未成功上傳, 原因是：\(error.localizedDescription)\n")
                    return
                } else if let data = data {
                    print("\n成功接收餐廳資料\n")
                    DispatchQueue.main.async {
                        do {
                            let data = try JSONDecoder().decode(Restaurant.self, from: data)
//                            dump(data)
                            self.restaurantDataAPI = data
                            
                            self.setRestaurantData(stationLat: latitude, stationLng: longitude)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func setRestaurantData(stationLat: Double, stationLng: Double) {
        
        shopName.removeAll()
        shopAddress.removeAll()
        shopRating.removeAll()
        shopReviewsNumber.removeAll()
        shopPicture.removeAll()
        distanceMeter.removeAll()
        
        restaurantDataAPI?.results.content.forEach { content in
            shopName.append(content.name)
            shopAddress.append(content.vicinity)
            shopRating.append(content.rating)
            shopReviewsNumber.append(content.reviewsNumber)
            shopPicture.append(content.photo)
                            
            distanceMeter.append(getDistance(stationLat: stationLat, stationLng: stationLng, shopLat: content.lat, shopLng: content.lng)/1000)
        }
        print(distanceMeter)
    }
    
    private func getDistance(stationLat: Double, stationLng: Double, shopLat: Double, shopLng: Double) -> Double {
        let EARTH_RADIUS: Double = 6378137.0
        
        let radLat1: Double = self.radian(d: stationLat)
        let radLat2: Double = self.radian(d: shopLat)
        
        let radLng1: Double = self.radian(d: stationLng)
        let radLng2: Double = self.radian(d: shopLng)
        
        let disLat: Double = radLat1 - radLat2
        let disLng: Double = radLng1 - radLng2
        
        var s: Double = 2 * asin(sqrt(pow(sin(disLat/2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(disLng/2), 2)))
        s = s * EARTH_RADIUS
        return s
    }
    
    private func radian(d: Double) -> Double {
        //根據角度計算弧度
        return d * Double.pi/180.0
    }
    
    private func showAlertVC(strName: String, strVic: String, douLat: Double, douLng: Double) {
        let actionSheetController = UIAlertController(title: strName+"高鐵站", message: strVic, preferredStyle: .actionSheet)
        
        let setStartAction = UIAlertAction(title: "設置為起點站", style: .default, handler: {(action) in
            self.startStationField.text = strName + "高鐵站"
        })
        
        let setEndAction = UIAlertAction(title: "設置為終點站", style: .default, handler: {(action) in
            self.endStationField.text = strName + "高鐵站"
        })
        
        let findRestaurant = UIAlertAction(title: "附近餐廳", style: .default, handler: {(action) in
            
            let globalQueue = DispatchQueue.global()
            let mainQueue = DispatchQueue.main
            let groupQueue = DispatchGroup()

            globalQueue.async(group: groupQueue) {
                self.getRestaurantAPI(latitude: douLat, longitude: douLng)
                sleep(UInt32(1))
            }
            groupQueue.notify(queue: mainQueue) {
                let VC = RestaurantVC(shopName: self.shopName, shopAddress: self.shopAddress, shopRating: self.shopRating, shopReviewsNumber: self.shopReviewsNumber, shopPicture: self.shopPicture,distance: self.distanceMeter)
                
                self.present(VC, animated: true, completion: nil)
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {(action) in
            
        })
        
        actionSheetController.addAction(setStartAction)
        actionSheetController.addAction(setEndAction)
        actionSheetController.addAction(findRestaurant)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true, completion: nil)
    }
        
    @IBAction func searchStation(_ sender: Any) {
        let VC = StationTableVC(name: stationName, address: stationAddress, mode: .other)
        
        VC.delegate = self as StationTableVCDelegate
        VC.showOn(VC: self)
    }
    
    @IBAction func routeSearch(_ sender: Any) {
        let searchStart = startStationField.text?.components(separatedBy: "高鐵") ?? []
        let searchEnd = endStationField.text?.components(separatedBy: "高鐵") ?? []
        
        if !searchStart[0].isEmpty && !searchEnd[0].isEmpty {
            let startField = startStationField.text ?? ""
            let endField = endStationField.text ?? ""
            if searchStart[0].trimmingCharacters(in: .whitespacesAndNewlines) == searchEnd[0].trimmingCharacters(in: .whitespacesAndNewlines) {
                view.makeToast("車站相同，請重新選擇")
            } else if !startField.contains("高鐵站") || !endField.contains("高鐵站") {
                view.makeToast("請不要把關鍵字詞『高鐵站』刪除")
            } else {
                let startId: String = stationAPIData?.filter({ $0.StationName.Zh_tw == searchStart[0] }).first?.StationID ?? ""
                let endId: String = stationAPIData?.filter({ $0.StationName.Zh_tw == searchEnd[0] }).first?.StationID ?? ""
//                let temp = stationAPIData?.filter({ station in
//                    station.StationName.Zh_tw == searchStart
//                })
                
                let globalQueue = DispatchQueue.global()
                let mainQueue = DispatchQueue.main
                let groupQueue = DispatchGroup()

                globalQueue.async(group: groupQueue) {
                    self.getURL(startID: startId, endID: endId)
                    self.getRouteAPI()
                    sleep(UInt32(1))
                }
                groupQueue.notify(queue: mainQueue) {
                    let VC = StationRouteVC(authorization: self.Authorization, trainsNo: self.trainsNo, direction: self.direction, departureTime: self.departureTime, arrivalTime: self.arrivalTime, startStation: searchStart[0], endStation: searchEnd[0])

                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
        } else {
            view.makeToast("起屹站有空，請重新選擇")
        }
    }
    
    @IBAction func transField(_ sender: Any) {
        let resigter = startStationField.text ?? ""
        startStationField.text = endStationField.text ?? ""
        endStationField.text = resigter
    }
    
    @IBAction func userLocation(_ sender: Any) {
        if ViewController.location == nil {
            ViewController.location = CLLocationManager()
            ViewController.location?.requestWhenInUseAuthorization()
            ViewController.location?.startUpdatingLocation()
        }
        myLocation.setImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        
        let center = mapView.userLocation.coordinate
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        switch searchBar {
        case startStationField:
            let VC = StationTableVC(name: stationName, address: stationAddress, mode: .start)
            
            VC.delegate = self as StationTableVCDelegate
            VC.showOn(VC: self)
        case endStationField:
            let VC = StationTableVC(name: stationName, address: stationAddress, mode: .end)
            
            VC.delegate = self as StationTableVCDelegate
            VC.showOn(VC: self)
        default:
            break
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        let strName = ((view.annotation?.title) ?? "") ?? ""
        let strVic = ((view.annotation?.subtitle) ?? "") ?? ""
        let douLat = view.annotation?.coordinate.latitude ?? 0.0
        let douLng = view.annotation?.coordinate.longitude ?? 0.0
        showAlertVC(strName: strName, strVic: strVic, douLat: douLat, douLng: douLng)
    }
}

extension ViewController: StationTableVCDelegate {
    
    func setStationData(address: String) {
        
        let regLat: Double = stationAPIData?.filter({$0.StationAddress == address}).first?.StationPosition.PositionLat ?? 0.0
        
        let regLon: Double = stationAPIData?.filter({$0.StationAddress == address}).first?.StationPosition.PositionLon ?? 0.0

        let latLng = CLLocationCoordinate2D(latitude: regLat, longitude: regLon)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = mapView.regionThatFits(MKCoordinateRegion(center: latLng, span: span))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func StationSelected(address: String, startEndChecked: Bool) {
        let regName: String = stationAPIData?.filter({$0.StationAddress == address}).first?.StationName.Zh_tw ?? ""
        
        guard !startEndChecked else {
            startStationField.text = regName + "高鐵站"
            return
        }
        endStationField.text = regName + "高鐵站"
    }
}
