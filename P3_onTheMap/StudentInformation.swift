//
//  StudentsData.swift
//

//import Foundation

struct StudentInformation {
    
    // constants
    private struct const {
        static let noData = "No data available"
    }
    
    var objectId: String = const.noData
    var uniqueKey = const.noData
    var firstName = const.noData
    var lastName = const.noData
    var mapString = const.noData
    var mediaURL = const.noData
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var updateAt: String = const.noData
    
    
    init() { }
    
    // Construct a StudentsData from a dictionary
    // unwrap all optionals, 
    init(dictionary: [String : AnyObject]) {

        if let objectId = dictionary["objectId"] as? String {
            self.objectId = objectId
        }
        
        if let uniqueKey = dictionary["uniqueKey"] as? String {
            self.uniqueKey = uniqueKey
        }
        if let firstName = dictionary["firstName"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = dictionary["lastName"] as? String {
            self.lastName = lastName
        }
        
        if let mapString = dictionary["mapString"] as? String {
            self.mapString = mapString
        }
        
        if let mediaURL = dictionary["mediaURL"] as? String {
            self.mediaURL = mediaURL
        }
        
        if let latitude = dictionary["latitude"] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = dictionary["longitude"] as? Double   {
            self.longitude = longitude
        }
        
        if let updateAt = dictionary["updateAt"] as? String {
            self.updateAt = updateAt
        }

        
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of Student objects */
    static func studentsFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
        var students = [StudentInformation]() 
       
        for result in results {
            students.append( StudentInformation(dictionary: result) )
        }
        
        return students
    }
    
}
