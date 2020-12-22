//
//  ViewController.swift
//  ForFaceDetect
//
//  Created by Zhaoyang Li on 12/16/20.
//

import UIKit
import Vision

class ImageCapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialImageViewSettings()
        initialFaceDetector()
    }
        
    private func initialImageViewSettings() {
        let image = UIImage(imageLiteralResourceName: "mount")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        let scale = image.size.width / view.frame.size.width
        
        let scaleHeight = image.size.height / scale
        
        imageView.frame = CGRect(x: 0, y: (view.frame.height - scaleHeight) / 2, width: self.view.frame.width, height: scaleHeight)
    }
    
    private func initialFaceDetector() {

        let request = VNDetectFaceRectanglesRequest { (request, error) in
            if error != nil {
                print("error in request")
            }
            request.results?.forEach({ result in
                guard let faceObservation = result as? VNFaceObservation else { return }
                print(faceObservation.boundingBox)
                // add views
                
                let h = self.imageView.frame.height * faceObservation.boundingBox.height
                let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                let y = self.imageView.frame.height * (1 - faceObservation.boundingBox.origin.y) - h
                let w = self.imageView.frame.width * faceObservation.boundingBox.width
                
                let redView = UIView()
                redView.backgroundColor = .red
                redView.alpha = 0.4
                redView.frame = CGRect(x: x, y: y, width: w, height: h)
                self.imageView.addSubview(redView)
                
            })
        }
        
        guard let cgImage = imageView.image?.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("error in handler", error.localizedDescription)
        }
    }
}

