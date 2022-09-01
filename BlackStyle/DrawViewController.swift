//
//  DrawViewController.swift
//  BlackStyle
//
//  Created by 최윤석 on 2022/09/01.
//

import UIKit
import PencilKit
import PhotosUI

class DrawViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

    @IBOutlet weak var canvasView: PKCanvasView!
    var drawing = PKDrawing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasView.delegate = self
        canvasView.drawing = drawing
        canvasView.drawingPolicy = .anyInput

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let toolPicker = PKToolPicker()
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        
    }
    
    @IBAction func saveDrawImage(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, UIScreen.main.scale)
        
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        if image != nil {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image!)
            }) { success, error in
                //error
            }
        }
    }
    
}
