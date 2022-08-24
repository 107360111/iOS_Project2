import UIKit
protocol StationTableVCDelegate: AnyObject {
    func setStationData(address: String)
    
    func StationSelected(address: String, startEndChecked: Bool)
}

class StationTableVC: UIViewController {

    @IBOutlet var popupView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    weak var delegate: StationTableVCDelegate?
    private var name: [String] = []
    private var address: [String] = []
    private var mode: StationMode = .start
    
    private var newName: [String] = []
    private var newAddress: [String] = []
    
    private var DataAPI: [Station]?
    
    private var stationAddress: String = ""
    
    enum StationMode {
        case start
        case end
        case other
    }
    
    convenience init(name: [String] = [], address: [String] = [], mode: StationMode = .start) {
        self.init()
        self.name = name
        self.address = address
        self.mode = mode
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

        componentsInit()
    }

    private func componentsInit() {
        switch mode {
        case .start:
            searchBar.placeholder = "請輸入起點車站"
        case .end:
            searchBar.placeholder = "請輸入終點車站"
        case .other:
            searchBar.placeholder = "請輸入車站名或地址"
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
    }
    
    func showOn(VC: UIViewController) {
        self.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.1
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window?.layer.add(transition, forKey: kCATransition)
        VC.present(self, animated: false) {
            self.popupView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.popupView.alpha = 0
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0.0, animations: {
                self.popupView.alpha = 1
                self.popupView.transform = CGAffineTransform.identity
            })
        }
    }
        
    private func dismissPopupView() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func dismissView() {
        dismissPopupView()
    }
}

extension StationTableVC: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text ?? ""
        newName.removeAll()
        newAddress.removeAll()
//        for array in arrays {           //矩陣arrays取array值
//            if arrays.contains(searchText) {
//
//            }
//        }
        
        
//        for (index, array) in arrays.enumerated() {      //用於矩陣arrays取array值與index
//            arrays[index] = array
//            if index == 5 {
//
//            }
//        }
        for index in 0..<name.count where name[index].contains(searchText) || address[index].contains(searchText) {
            newName.append(name[index])
            newAddress.append(address[index])
        }

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let searchText = searchBar.text ?? ""
        
        if !searchText.isEmpty {
            return newName.count
        } else {
            return name.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.backgroundColor = .clear
        
        let searchText = searchBar.text ?? ""
        if searchText.isEmpty {
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                //設定主標題為name，字體顏色為黑(black)，字體大小為18.0
                content.attributedText = NSAttributedString(string: name[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)])
                //設定副標題為vic，字體顏色為青綠(systemGreen)，字體大小為14.0
                content.secondaryAttributedText = NSAttributedString(string: address[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)])
                
                content.textProperties.adjustsFontSizeToFitWidth = true
                content.textProperties.minimumScaleFactor = 0.85
                content.textProperties.alignment = .natural
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = name[indexPath.row]
                cell.textLabel?.textColor = .black
                
                cell.detailTextLabel?.text = address[indexPath.row]
                cell.detailTextLabel?.textColor = .systemGreen
                
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                cell.textLabel?.minimumScaleFactor = 0.85
                cell.textLabel?.textAlignment = .natural
            }
            return cell
        } else {
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                //設定主標題為name，字體顏色為黑(black)，字體大小為18.0
                content.attributedText = NSAttributedString(string: newName[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)])
                //設定副標題為vic，字體顏色為青綠(systemGreen)，字體大小為14.0
                content.secondaryAttributedText = NSAttributedString(string: newAddress[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)])
                
                content.textProperties.adjustsFontSizeToFitWidth = true
                content.textProperties.minimumScaleFactor = 0.85
                content.textProperties.alignment = .natural
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = newName[indexPath.row]
                cell.textLabel?.textColor = .black
                
                cell.detailTextLabel?.text = newAddress[indexPath.row]
                cell.detailTextLabel?.textColor = .systemGreen
                
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                cell.textLabel?.minimumScaleFactor = 0.85
                cell.textLabel?.textAlignment = .natural
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissView()
        let searchText = searchBar.text ?? ""
        
        if !searchText.isEmpty {
            guard newAddress.indices.contains(indexPath.row) else { return }
//            if !.indices.contains(indexPath.row) { return }
            
            stationAddress = newAddress[indexPath.row]
        } else {
            guard address.indices.contains(indexPath.row) else { return }
//            if !.indices.contains(indexPath.row) { return }
            
            stationAddress = address[indexPath.row]
        }
        
        switch mode {
        case .start:
            delegate?.StationSelected(address: stationAddress, startEndChecked: true)
        case .end:
            delegate?.StationSelected(address: stationAddress, startEndChecked: false)
        case .other:
            delegate?.setStationData(address: stationAddress)
        }
    }
}
