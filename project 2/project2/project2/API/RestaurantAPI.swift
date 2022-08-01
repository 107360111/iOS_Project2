import Foundation

class Restaurant: Codable {
    var results: results
}
class results: Codable {
    var content: [content]
}
class content: Codable {
    var lat : Double
    var lng : Double
    var name : String
    var rating : Double
    var vicinity : String   // Address
    var photo : String
    var phone: String
    var reviewsNumber : Int
    var index : Int
    var reviews: [review]
}
class review: Codable {
    var name : String
    var rating : Double
    var photo : String
    var text : String
    var time : Int
}


class restaurantDataModel : Codable {
    var lastIndex = -1
    var count = 0
    var type = [7]
    var lat = Double()
    var lng = Double()
    var range = String()
}
