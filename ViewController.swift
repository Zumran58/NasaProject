//
//  ViewController.swift
//  nasaproject
//
//  Created by Zumran Nain on 2023-12-11.
//

import UIKit

class ViewController: UIViewController {
        
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
        let apiUrl = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2023-12-08")!

        // Create a URLSession
        let session = URLSession.shared

        // Create a data task to make the request
        let task = session.dataTask(with: apiUrl) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                return
            }

            // Check if data is available
            guard let jsonData = data else {
                print("No data received.")
                return
            }

            do {
                // Decode JSON using Codable
                let decoder = JSONDecoder()
                let NASAModel = try decoder.decode(NASAData.self, from: jsonData)

                // Once you have the image URL, load and set the image
                if let imageUrl = URL(string: NASAModel.url) {
                    self.downloadImage(from: imageUrl)
                }

            } catch {
                print("Error decoding JSON: \(error)")
            }
        }

        // Start the data task
        task.resume()
    }
    
    @IBOutlet weak var NASAImage: UIImageView!
    
    func downloadImage(from url: URL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let imageData = data else {
                    print("No image data received.")
                    return
                }
                // Create UIImage from imageData
                if let image = UIImage(data: imageData) {
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        self.NASAImage.image = image
                    }
                }
            }
            task.resume()
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromAPI()
        // Do any additional setup after loading the view.
    }
}

