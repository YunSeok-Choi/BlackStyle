//
//  TransViewController.swift
//  BlackStyle
//
//  Created by 최윤석 on 2022/08/30.
//

import UIKit
import CoreML
import Vision
import Photos


class TransViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var userCIImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = userPickedImage
            userCIImage = CIImage(image: userPickedImage)!
            //            userCIImage.orientationTransform(for: .down)
        }
        imagePicker.dismiss(animated: true)
    }
    
    func detect(image: CIImage, name: String) {
        var model: VNCoreMLModel?
        
        switch name {
        case "Stone":
            model = try? VNCoreMLModel(for: Stone(configuration: MLModelConfiguration()).model)
        case "Dezoomify1teration310":
            model = try? VNCoreMLModel(for: Dezoomify1teration310(configuration: MLModelConfiguration()).model)
        case "Pencil":
            model = try? VNCoreMLModel(for: Pencil(configuration: MLModelConfiguration()).model)
        case "Spring":
            model = try? VNCoreMLModel(for: Spring(configuration: MLModelConfiguration()).model)
        case "Dot":
            model = try? VNCoreMLModel(for: Dot(configuration: MLModelConfiguration()).model)
        case "Green":
            model = try? VNCoreMLModel(for: Green(configuration: MLModelConfiguration()).model)
        default:
            break
        }
        
        //        guard let model = try? VNCoreMLModel(for: Stone(configuration: MLModelConfiguration()).model) else {
        //            fatalError("Loading CoreML Model Failed")
        //        }
        
        let request = VNCoreMLRequest(model: model!) { request, _ in
            
            DispatchQueue.global(qos: .userInteractive).async {
                guard let results = request.results?.first as? VNPixelBufferObservation else {
                    fatalError("model failed to process image")
                }
                let pixelBuffer = results.pixelBuffer
                
                let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(ciImage: ciImage)
                }
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    @IBAction func albumTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func styleSegmented(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            detect(image: userCIImage, name: "Stone")
        case 1:
            detect(image: userCIImage, name: "Dezoomify1teration310")
        case 2:
            detect(image: userCIImage, name: "Pencil")
        case 3:
            detect(image: userCIImage, name: "Spring")
        case 4:
            detect(image: userCIImage, name: "Dot")
        case 5:
            detect(image: userCIImage, name: "Green")
        default:
            break
        }
    }
    
    @IBAction func saveImage(_ sender: UIButton) {
        //        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
        //
        //        imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        //
        //        let image = UIGraphicsGetImageFromCurrentImageContext()
        //
        //        PHPhotoLibrary.shared().performChanges({
        //            PHAssetChangeRequest.creationRequestForAsset(from: image!)
        //        })
        self.saveImage(view: imageView)
    }
    
}
