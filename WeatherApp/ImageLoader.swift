//
//  ImageLoader.swift
//  WeatherApp
//
//  Created by Hafiz Amaduddin Ayub on 2/21/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImageFromURLString(_ urlString:String) {
        // Getting file URL from documents path directory.
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent((urlString as NSString).lastPathComponent)
        // Checking if the image has already exists at file path.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            self.image = UIImage(contentsOfFile: fileURL.path)
            return
        }
        
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: URL(string:urlString)!, completionHandler: {(data, response, error) -> Void in
                do {
                    // Saving image to documents directory.
                    try data?.write(to: fileURL, options: .atomic)
                } catch {
                    print("Error writing image to documents directory.")
                }
                if let image = UIImage(data: data!) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}
