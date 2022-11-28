//
//  ViewController.swift
//  StyleChanger
//
//  Created by 최윤석 on 2022/11/24.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    private let drawingButton: UIButton = {
        var button = UIButton()
        button.setTitle("그림 그리기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nanum GangInHanWiRo", size: 36)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let transButton: UIButton = {
        var button = UIButton()
        button.setTitle("이미지 변환", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nanum GangInHanWiRo", size: 36)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawingButton.addTarget(self, action: #selector(tapDrawButton), for: .touchUpInside)
        transButton.addTarget(self, action: #selector(tapTransButton), for: .touchUpInside)
        
        view.backgroundColor = .black
        view.addSubview(drawingButton)
        view.addSubview(transButton)
        
        setConstraints()
        
    }
    
    @objc private func tapDrawButton() {
        navigationController?.pushViewController(DrawViewController(), animated: true)
    }
    
    @objc private func tapTransButton() {
        navigationController?.pushViewController(TransViewController(), animated: true)
    }
    
    private func setConstraints() {
        let drawingButtonConstraints = [
            drawingButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 656),
            drawingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 312),
            drawingButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let transButtonConstraints = [
            transButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 656),
            transButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -312),
            transButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(drawingButtonConstraints)
        NSLayoutConstraint.activate(transButtonConstraints)
    }
    
}
