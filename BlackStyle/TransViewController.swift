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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Failed to CIImage")
            }
            
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true)
        
    }
    
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Green(configuration: MLModelConfiguration()).model) else {
            fatalError("Loading CoreML Model Failed")
        }

        let request = VNCoreMLRequest(model: model) { request, _ in
            
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
    
    @IBAction func saveImage(_ sender: UIButton) {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
        
        imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image!)
        })
        
    }
    
    
}
