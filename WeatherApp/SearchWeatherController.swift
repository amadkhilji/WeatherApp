//
//  SearchWeatherController.swift
//  WeatherApp
//
//  Created by Hafiz Amaduddin Ayub on 2/21/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

import UIKit

extension SearchWeatherController: UISearchBarDelegate {
    // UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.global().async {
            searchBar.resignFirstResponder()
            self.searchWeatherForCity(name: searchBar.text!)
        }
    }
}

class SearchWeatherController: UIViewController {

    // IBOutlet Properties
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    
    // Properties
    let searchController = UISearchController(searchResultsController: nil)
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weather Search"
        
        // Setup the Search Controller        
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Enter City Name"
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = self.searchController.searchBar
        
        self.definesPresentationContext = true
        
        // Loading last saved weather result, if haven't already
        self.appDelegate.weather.load()
        self.loadWeatherData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Loading weather data
    func loadWeatherData() -> Void {
        
        let weather = self.appDelegate.weather
        
        self.cityName.text = weather.cityName
        self.countryName.text = weather.countryName
        self.titleLabel.text = weather.title
        self.descriptionLabel.text = weather.description
        self.iconImage.downloadImageFromURLString(weather.iconURL)
    }
    
    // Clearing weather data
    func clearWeatherData() -> Void {
        //
    }

    // Search weather request on the basis of city name method.
    func searchWeatherForCity(name cityName:String) {
        
        if !cityName.isEmpty {
            if dataTask != nil {
                dataTask?.cancel()
            }
            let searchTerm = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let urlString  = "http://api.openweathermap.org/data/2.5/weather?appid=781c39a62d1f11505ed99f962493cf41&q=" + searchTerm!
            let url = URL(string: urlString)
            dataTask = defaultSession.dataTask(with: url!, completionHandler: {(data, response, error) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if data != nil {
                            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                            if jsonData != nil {
                                let weather = try? Weather(json: jsonData!)
                                if weather != nil {
                                    self.appDelegate.weather = weather!
                                    self.appDelegate.weather.save()
                                    DispatchQueue.main.async {
                                        self.loadWeatherData()
                                    }
                                }
                            }
                        }
                    }
                }
            })
            dataTask?.resume()
        } else {
            // We can reset all values to nil or something
            // Based on our requirement.
//            DispatchQueue.main.async {
//                self.clearWeatherData()
//            }
        }
    }
}

