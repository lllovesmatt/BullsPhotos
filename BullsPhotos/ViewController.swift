//
//  ViewController.swift
//  BullsPhotos
//
//  Created by Matthew Ramsden on 2/24/17.
//  Copyright © 2017 Matthew Ramsden. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var photoTitleLabel: UILabel!
    
    @IBOutlet weak var grabImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions

    @IBAction func grabNewImage(_ sender: Any) {
        setUIEnabled(false)
        getImageFromFlickr()
    }

    // MARK: Configure UI

    private func setUIEnabled(_ enabled: Bool) {
        photoTitleLabel.isEnabled = enabled
        grabImage.isEnabled = enabled
        
        if enabled {
            grabImage.alpha = 1.0
        } else {
            grabImage.alpha = 0.5
        }
    }
    
    // MARK: Make Network Request

    private func getImageFromFlickr() {
        
//        let urlString = "\(APIConstants.Flickr.APIBaseURL)?\(APIConstants.FlickrParameterKeys.Method)=\(APIConstants.FlickrParameterValues.GalleryPhotosMethod)&\(APIConstants.FlickrParameterKeys.APIKey)=\(APIConstants.FlickrParameterValues.APIKey)&\(APIConstants.FlickrParameterKeys.GalleryID)=\(APIConstants.FlickrParameterValues.GalleryID)&\(APIConstants.FlickrParameterKeys.Extras)=\(APIConstants.FlickrParameterValues.MediumURL)&\(APIConstants.FlickrParameterKeys.Format)=\(APIConstants.FlickrParameterValues.ResponseFormat)&\(APIConstants.FlickrParameterKeys.NoJSONCallback)=\(APIConstants.FlickrParameterValues.DisableJSONCallback)"
//        let url = URL(string: urlString)!
//        print(url)
//        
        let methodParameters = [
            APIConstants.FlickrParameterKeys.Method:APIConstants.FlickrParameterValues.GalleryPhotosMethod,
            APIConstants.FlickrParameterKeys.APIKey:APIConstants.FlickrParameterValues.APIKey,
            APIConstants.FlickrParameterKeys.GalleryID:APIConstants.FlickrParameterValues.GalleryID,
            APIConstants.FlickrParameterKeys.Extras:APIConstants.FlickrParameterValues.MediumURL,
            APIConstants.FlickrParameterKeys.Format:APIConstants.FlickrParameterValues.ResponseFormat,
            APIConstants.FlickrParameterKeys.NoJSONCallback:APIConstants.FlickrParameterValues.DisableJSONCallback
        
        ]
        
        let urlString = APIConstants.Flickr.APIBaseURL + escapedParameters(parameters: methodParameters as [String : AnyObject])
        
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(url: url as URL)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func displayError(error: String) {
                print(error)
                print("URL at time of error: \(url)")
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                }
            }
            
            guard (error == nil) else {
                displayError(error: "There was an error with the request \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    displayError(error: "Your status code returned something other than 2XX")
                    return
            }
            
            guard let data = data else {
                displayError(error: "No Data returned by request")
                return
            }
            
            
            
            
//            if error == nil {
//                if let data = data {
                    let parsedResult: Any!
                    do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    } catch {
                        displayError(error: "Could not Parse the JSON: \(data)")
                        return
                    }
                    
                    //print(parsedResult)
                
                    let parsedResultAnyObject: AnyObject = parsedResult as AnyObject
            
            guard let stat = parsedResultAnyObject[APIConstants.FlickrResponseKeys.Status] as? String, stat == APIConstants.FlickrResponseValues.OKStatus else {
                displayError(error: "Flickr API returned an error. See error code and message in \(parsedResultAnyObject)")
                return
            }
            
            guard let photosDictionary = parsedResultAnyObject[APIConstants.FlickrResponseKeys.Photos] as? [String: AnyObject], let photoArray = photosDictionary[APIConstants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                displayError(error: "Cannot find Photos \(APIConstants.FlickrResponseKeys.Photos) nor Photo \(APIConstants.FlickrResponseKeys.Photo) in \(parsedResultAnyObject)")
                return
            }
            
//                    if let photosDictionary = parsedResultAnyObject[APIConstants.FlickrResponseKeys.Photos] as? [String: AnyObject], let photoArray = photosDictionary[APIConstants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] {
                        //print(photosDictionary)
                        //print(photoArray[5])
                        
                        let randomIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
                        let photoDictionary = photoArray[randomIndex]
            
            guard let urlImageString = photoDictionary[APIConstants.FlickrResponseKeys.MediumURL] as? String, let urlImageTitle = photoDictionary[APIConstants.FlickrResponseKeys.Title] as? String else {
                displayError(error: "Cannot find MediumPhoto \(APIConstants.FlickrResponseKeys.MediumURL) nor Title \(APIConstants.FlickrResponseKeys.Title) in \(photoDictionary)")
                return
            }
                        
//                        if let urlImageString = photoDictionary[APIConstants.FlickrResponseKeys.MediumURL] as? String, let urlImageTitle = photoDictionary[APIConstants.FlickrResponseKeys.Title] as? String {
//                            print(urlImageString)
//                            print(urlImageTitle)
                            
                            let imageURL = URL(string: urlImageString)
                            if let imageData = NSData(contentsOf: imageURL!) {
                                
                                performUIUpdatesOnMain {
                                    self.photoImageView.image = UIImage(data: imageData as Data)
                                    self.photoTitleLabel.text = urlImageTitle
                                    self.setUIEnabled(true)
                                }
                                
                                
                                
                            }
//                        }
            

//                    }
            
//                }
//            }
            
            
        }
        
        task.resume()
        

//        let session = URLSession.shared
//        
//        let dataTask = session.dataTask(with: request as URLRequest) {data,response,error in
//            let httpResponse = response as? HTTPURLResponse
//            
//            if (error != nil) {
//                print(error!)
//            } else {
//                print(httpResponse!)
//            }
//            
//            DispatchQueue.main.async {
//                //Update your UI here
//            }
//            
//        }
//        dataTask.resume()
        
        
        
        
    }

    
    
    
    private func escapedParameters(parameters: [String: AnyObject]) -> String {
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                let stringValue = "\(value)"
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
        
        
    }

}

