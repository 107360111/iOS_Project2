import Foundation

class Station: Codable {
//    var StationUID: String
    var StationID: String
//    var StationCode: String
    var StationName: Name
    var StationAddress: String
//    var OperatorID: String
//    var UpdateTime: String
//    var VersionID: Int
    var StationPosition: Position
//    var LocationCity: String
//    var LocationCityCode: String
//    var LocationTown: String
//    var LocationTownCode: String
}
class Name: Codable {
    var Zh_tw: String
//    var En: String
}
class Position: Codable {
    var PositionLon: Double
    var PositionLat: Double
//    var GeoHash: String
}
