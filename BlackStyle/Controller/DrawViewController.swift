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
    // 캔버스 뷰를 만들어줌
    @IBOutlet weak var canvasView: PKCanvasView!
//    var drawing = PKDrawing()
    // Tool Picker를 만들어줄 변수 생성
    var toolPicker: PKToolPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        canvasView.delegate = self
//        canvasView.drawing = drawing
        // Tool Picker 인스턴스 생성
        toolPicker = PKToolPicker()
        // Tool Picker를 사용자에게 보여줄 수 있게 설정
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        // Tool Picker에 Canvas View가 인식할 수 있게 설정
        toolPicker.addObserver(canvasView)
        // 해당 뷰 컨트롤러에도 같은 설정
        toolPicker.addObserver(self)
        // Tool Picker 위치 설정
        updateLayout(for: toolPicker)
        // Canvas View가 처음 인식할 수 있게 설정
        canvasView.becomeFirstResponder()
        
    }
    // 툴피커가 변경될 때
    func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {
        updateLayout(for: toolPicker)
    }
    // 툴피커가 숨겨지거나 안보이게할 때
    func toolPickerVisibilityDidChange(_ toolPicker: PKToolPicker) {
        updateLayout(for: toolPicker)
    }
    // 툴피커는 적당한 크기의 캔버스위에 표시 되지만 작은 크기의 혹은 조정된 크기의 캔버스에는 화면 일부에 표시될 수 있게 함
    func updateLayout(for toolPicker: PKToolPicker) {
        let obscuredFrame = toolPicker.frameObscured(in: view)
        // 툴피커가 캔버스 위에 표시될 때는 실행 취소 및 다시 실행 버튼이 추가.
        if obscuredFrame.isNull {
            canvasView.contentInset = .zero
            navigationItem.leftBarButtonItems = []
        } else {        // 그렇지 않다면 캔버스 뷰의 상단에 툴피커를 위치시키고, 실행 취소 및 다시 실행 버튼이 사라짐
            canvasView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.bounds.maxY - obscuredFrame.minY, right: 0)
        }

        canvasView.scrollIndicatorInsets = canvasView.contentInset
    }
    
    @IBAction func saveDrawImage(_ sender: Any) {
        self.saveImage(view: canvasView)
    }
    
}
