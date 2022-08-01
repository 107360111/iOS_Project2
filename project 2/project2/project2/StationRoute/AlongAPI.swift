import Foundation

class ChooseTrain: Codable {
    var StopTimes: [StopTimes]
}
class StopTimes: Codable {
    var StopSequence: Int = 0
    var StationName: stationName
    var DepartureTime: String = ""
}
class stationName: Codable {
    var Zh_tw: String
}
