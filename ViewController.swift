//
//  ViewController.swift
//  nasaproject
//
//  Created by Zumran Nain on 2023-12-11.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var NASAImage: UIImageView!
    
    struct NASAData: Codable {
        let date, explanation, mediaType, serviceVersion: String
        let title: String
        let url: String

        enum CodingKeys: String, CodingKey {
            case date, explanation
            case mediaType = "media_type"
            case serviceVersion = "service_version"
            case title, url
        }
    }
    
    func fetchDataFromAPI() {
        // API URL
        guard let apiUrl = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2023-12-10") else {
            print("invalid url")
            return
        }
        
        guard let jsonData = try? Data(contentsOf: apiUrl) else {
            print("no data received")
            return
        }
    
        do {
            let decoder = JSONDecoder()
            let NASAModel = try decoder.decode(NASAData.self, from: jsonData)
            
            //once have image url, load and set the image
            
            if let imageUrl = URL(string: NASAModel.url) {
                self.downloadImage(from: imageUrl)
            }
            
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    
    func downloadImage(from url: URL) {
        
        guard let imageData = try? Data(contentsOf: url) else {
            print("no data received")
            return
        }
        
        if let image = UIImage(data: imageData) {
            DispatchQueue.main.async {
                self.NASAImage.image = image
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromAPI()
        // Do any additional setup after loading the view.
    }
}

