//
//  ViewController.swift
//  CoreML-RDC
//
//  Created by Pragatha on 2/25/19.
//  Copyright © 2019 Santander. All rights reserved.
//

import UIKit
import Vision
import SwiftOCR
import TesseractOCR

class ViewController: UIViewController {
    
    var selectedPhoto: UIImage?
    var markedImage: UIImage?
    var textImages = [UIImage]()
    
    let operationQueue = OperationQueue()
    
     @IBOutlet weak var photoView: UIImageView!
     @IBOutlet weak var markedView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let localImage = UIImage(named: "Check_front2_66_cents.JPG", in: Bundle(for: type(of: self)), compatibleWith: nil)
        
        processImage(photo: localImage!)
      //  handleWithTesseract(image: localImage!)
    }

    func processImage(photo : UIImage) {
        
        //Load image here
        detectAndDisplayText(forImage: photo)
    }

     func detectAndDisplayText(forImage image: UIImage) {
        
        // Create the Vision request handler
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [VNImageOption:Any]())
        
        // Setup text recognition tequest
        let request = VNDetectTextRectanglesRequest(completionHandler: { (request, error) in
            if error != nil {
                print("Error in text detection: \(String(describing: error?.localizedDescription))")
            } else {
                
                // add rectangale and add to textImage array
                // detect text method
                
                self.markedImage = self.mixImage(topImage: self.drawRectangleForTextDectect(image: image,
                                                                                            results: request.results as! Array<VNTextObservation>),
                                                 bottomImage: image)
                DispatchQueue.main.async {
                    self.photoView.image = self.markedImage
                }
                
                // Run room number detection functions
                self.detectText()
                
            }
        })
        
        request.reportCharacterBoxes = true
        
        do {
            try handler.perform([request])
        } catch {
            print("Unable to detect text")
        }
    }
    
    func drawRectangleForTextDectect(image: UIImage, results:Array<VNTextObservation>) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        var transform = CGAffineTransform.identity;
        transform = transform.scaledBy( x: image.size.width, y: -image.size.height);
        transform = transform.translatedBy(x: 0, y: -1 );
        
        let img = renderer.image { ctx in
            for item in results {
                ctx.cgContext.setFillColor(UIColor.clear.cgColor)
                ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
                ctx.cgContext.setLineWidth(2)
                ctx.cgContext.addRect(item.boundingBox.applying(transform))
                ctx.cgContext.drawPath(using: .fillStroke)
                
                addScreenShotToTextImages(sourceImage: image, boundingBox: item.boundingBox.applying(transform))
            }
        }
        return img
    }
    
    func addScreenShotToTextImages(sourceImage image: UIImage, boundingBox: CGRect) {
        // Increase the bounding box around the letters by 10% to improve OCR
        let pct = 0.1 as CGFloat
        let newRect = boundingBox.insetBy(dx: -boundingBox.width*pct/2, dy: -boundingBox.height*pct/2)
        
        let imageRef = image.cgImage!.cropping(to: newRect)
        let croppedImage = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
        textImages.append(croppedImage)
    }
    
    func mixImage(topImage: UIImage, bottomImage: UIImage, topImagePoint: CGPoint = CGPoint.zero, isHaveBackground: Bool = true) -> UIImage {
        let newSize = bottomImage.size
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        if(isHaveBackground==true){
            bottomImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        }
        topImage.draw(in: CGRect(origin: topImagePoint, size: newSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
    }
    
  
    
    func detectText() {
        var textStrings = [String]()
        var imageCnt = 0
        
        for item in textImages {
            let swiftOCRInstance = SwiftOCR()
            
            swiftOCRInstance.recognize(item) { recognizedString in
                print("text: \(recognizedString)")
                textStrings.append(recognizedString)
                imageCnt += 1
                
                // Select the room number once all strings are processed
                if imageCnt == self.textImages.count {
                   // self.selectRoomNumber(fromStrings: textStrings)
                     print("processed string : \(textStrings)")
                }
            }
        }
    }
    
    
    // Tesseract image code
    
    private func handleWithTesseract(image: UIImage) {
        
      /*  let tesseract = G8Tesseract(language: "eng")!
        
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .singleBlock
        
        tesseract.image = image
        tesseract.recognize()
        let text = tesseract.recognizedText ?? ""
         print("processed string : \(text)") */
        
//        guard let operation = G8RecognitionOperation(language: "eng") else { return }
//        operation.tesseract.engineMode = .tesseractOnly
//        operation.tesseract.pageSegmentationMode = .autoOnly
//        operation.tesseract.image = image;
//
//         operation.recognitionCompleteBlock =  { (tesseract : G8Tesseract?) in
//
//            let recognizedText = tesseract?.recognizedText
//            print("processed string : \(String(describing: recognizedText))")
//        };
//
//         self.markedView.image = operation.tesseract.thresholdedImage
//         self.operationQueue.addOperation(operation)
        
        
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.engineMode = .tesseractCubeCombined
            tesseract.pageSegmentationMode = .auto
            tesseract.image = image
            tesseract.recognize()
            let recognizedText = tesseract.recognizedText
            print("processed string : \(String(describing: recognizedText))")
        }
    }
    
}

