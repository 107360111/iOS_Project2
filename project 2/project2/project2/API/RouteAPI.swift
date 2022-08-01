import Foundation

class Schedule: Codable {
//    var TranDate: String
    var DailyTrainInfo: TrainInfo
    var OriginStopTime: OriginStop
    var DestinationStopTime: DestinationStop
//    var UpdateTime: String
//    var VersionID: Int
}
class TrainInfo: Codable {
    var TrainNo: String
    var Direction: Int
//    var StartingStationID: String
//    var StartingStationName: StartingName
//    var EndingStationID: String
//    var EndingStationName: EndingName
//    var Note: Note
}
class OriginStop: Codable {
//    var StopSequence: Int
//    var StationID: String
//    var StationName: OriginName
//    var ArrivalTime: String
    var DepartureTime: String
}
class DestinationStop: Codable {
//    var StopSequence: Int
//    var StationID: String
//    var StationName: DestinationName
    var ArrivalTime: String
//    var DepartureTime: String
}
class StartingName: Codable {
    var Zh_Tw: String
//    var En: String
}
class EndingName: Codable {
    var Zh_Tw: String
//    var En: String
}
class OriginName: Codable {
    var Zh_Tw: String
//    var En: String
}
class DestinationName: Codable {
    var Zh_Tw: String
//    var En: String
}
class Note: Codable {
    var Zh_Tw: String
//    var En: String
}
