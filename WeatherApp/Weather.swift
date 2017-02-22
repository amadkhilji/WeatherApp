//
//  Weather.swift
//  WeatherApp
//
//  Created by Hafiz Amaduddin Ayub on 2/21/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension Weather {
    init(json: [String: Any]) throws {
        
        guard let cityName = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        guard let sys = json["sys"] as? [String: Any] else {
            throw SerializationError.missing("sys")
        }
        
        guard let countryName = sys["country"] as? String else {
            throw SerializationError.missing("country")
        }
        
        guard let weather = json["weather"] as? [Any] else {
            throw SerializationError.missing("weather")
        }
        
        let weatherObj = weather.first as! [String: Any]
        
        guard let title = weatherObj["main"] as? String else {
            throw SerializationError.missing("main")
        }
        
        guard let description = weatherObj["description"] as? String else {
            throw SerializationError.missing("description")
        }
        
        guard let iconName = weatherObj["icon"] as? String else {
            throw SerializationError.missing("icon")
        }
        
        self.cityName = cityName
        self.countryName = countryName
        self.title = title
        self.description = description
        self.iconURL = "http://openweathermap.org/img/w/" + iconName + ".png"
    }
}

struct Weather {
    
    var cityName: String
    var countryName: String
    var title: String
    var description: String
    var iconURL: String
    
    init() {
        self.cityName = ""
        self.countryName = ""
        self.title = ""
        self.description = ""
        self.iconURL = ""
    }
    
    // Saving the existing data.
    func save() -> Void {
        let data = ["cityName": cityName, "countryName": countryName, "title": title, "description": description, "iconURL": iconURL]
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: "Weather")
        defaults.synchronize()
    }
    
    // Deleting the existing data.
    mutating func delete() -> Void {
        self.cityName = ""
        self.countryName = ""
        self.title = ""
        self.description = ""
        self.iconURL = ""
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Weather")
        defaults.synchronize()
    }
    
    // Loading the existing data.
    mutating func load() -> Void {
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "Weather") as? [String: String] {
            self.cityName = data["cityName"]!
            self.countryName = data["countryName"]!
            self.title = data["title"]!
            self.description = data["description"]!
            self.iconURL = data["iconURL"]!
        }
    }
}
