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
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.creationRequestForAsset(from: self.imageView.image!)
//        }, completionHandler: nil)
        
        imagePicker.sourceType = .photoLibrary
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // 사용자가 이미지를 선택해옴
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // 뷰를 선택된 이미지로 변경
            self.imageView.image = userPickedImage
            // CIImage로 변경
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Failed to CIImage")
            }
            // ML로 분석
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true)
        
    }
    
    
    // 선택한 이미지를 ML을 통해 분석
    func detect(image: CIImage) {
        
        // Model을 VisionModel로 변환
        guard let model = try? VNCoreMLModel(for: Pencil(configuration: MLModelConfiguration()).model) else {
            fatalError("Loading CoreML Model Failed")
        }
        // Vision ML 요청값
        let request = VNCoreMLRequest(model: model) { request, _ in
            // 요청한 결과 값 저장
            
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
        //        print(request)
        // 핸들러를 통해 이미지를 분석
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
    
}
