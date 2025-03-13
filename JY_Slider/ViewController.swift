//
//  ViewController.swift
//  JY_Slider
//
//  Created by JY_Slider on 2025/3/13.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let slider1 = UISlider()
        view.addSubview(slider1)
        
        slider1.frame = CGRect(x: 0, y: 100, width: 250, height: 50)
        
        
        let slider2 = JY_Normal_Slider()
        view.addSubview(slider2)
        slider2.yq_slider_value_change_block = { [weak self] (progress) in
            print("slider2 = \(progress)")
        }
        
        slider2.frame = CGRect(x: 10, y: slider1.frame.maxY, width: 250, height: 50)
        slider2.yq_set(progress: 0.5)
        
        
        let slider3 = JY_Normal_Slider(progressConfig: (progressTintColor: UIColor.systemRed, trackTintColor: UIColor.systemYellow, isCorners: true), sliderConfig: (size: CGSize(width: 100, height: 100), color: UIColor.systemGreen, isCorners: true))
        view.addSubview(slider3)
        slider3.yq_slider_value_change_block = { [weak self] (progress) in
            print("slider3 = \(progress)")
        }
        
        slider3.frame = CGRect(x: 30, y: slider2.frame.maxY * 2, width: 250, height: 50)
        slider3.yq_set(progress: 0.68)
    }


}

