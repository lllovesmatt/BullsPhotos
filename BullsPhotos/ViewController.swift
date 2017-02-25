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
        // Do any additional setup after loading the view, typically from a nib.
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
        
        let urlString = "\(APIConstants.Flickr.APIBaseURL)?\(APIConstants.FlickrParameterKeys.Method)=\(APIConstants.FlickrParameterValues.GalleryPhotosMethod)&\(APIConstants.FlickrParameterKeys.APIKey)=\(APIConstants.FlickrParameterValues.APIKey)&\(APIConstants.FlickrParameterKeys.GalleryID)=\(APIConstants.FlickrParameterValues.GalleryID)&\(APIConstants.FlickrParameterKeys.Extras)=\(APIConstants.FlickrParameterValues.MediumURL)&\(APIConstants.FlickrParameterKeys.Format)=\(APIConstants.FlickrParameterValues.ResponseFormat)&\(APIConstants.FlickrParameterKeys.NoJSONCallback)=\(APIConstants.FlickrParameterValues.DisableJSONCallback)"
        let url = URL(string: urlString)!
        print(url)
        
        
    }


}

