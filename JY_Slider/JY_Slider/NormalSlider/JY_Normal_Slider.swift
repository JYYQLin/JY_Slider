//
//  JY_Normal_Slider.swift
//  JY_Slider
//
//  Created by JY_Slider on 2025/3/13.
//

import UIKit

class JY_Normal_Slider: UIView {

    private lazy var yq_scale: CGFloat = 1.0
    func yq_set(scale: CGFloat) {
        yq_scale = scale
        layoutSubviews()
    }

    func yq_set(progress: Float) {
        yq_progress_view.progress = progress
        yq_slider_view.center.x = yq_progress_view.frame.width * CGFloat(progress) + yq_progress_view.frame.minX
    }
    
    var yq_progress: Float {
        get {
            return yq_progress_view.progress
        }
    }
    
    private lazy var yq_progress_view: UIProgressView = UIProgressView()
    
    private lazy var yq_slider_view: UIView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        yq_progress_view.frame.origin = {
            
            yq_progress_view.frame.size = CGSize(width: frame.width, height: frame.height)
            yq_progress_view.progressTintColor = yq_progress_config.progressTintColor
            yq_progress_view.trackTintColor = yq_progress_config.trackTintColor
            
            yq_progress_view.layer.cornerRadius = yq_progress_view.frame.height * 0.5
            yq_progress_view.layer.masksToBounds = true
            
            return CGPoint(x: (frame.width - yq_progress_view.frame.width) * 0.5, y: (frame.height - yq_progress_view.frame.height) * 0.5)
        }()
        
        yq_slider_view.frame.origin = {
            yq_slider_view.frame.size = CGSize(width: yq_slider_config.size.width * yq_scale, height: yq_slider_config.size.height * yq_scale)
            yq_slider_view.backgroundColor = yq_slider_config.color
            
            if yq_slider_config.isCorners == true {
                yq_slider_view.layer.cornerRadius = yq_slider_view.frame.height * 0.5
                yq_slider_view.layer.masksToBounds = true
            }
            
            return CGPoint(x: (yq_progress_view.frame.width) * CGFloat(yq_progress_view.progress) - yq_slider_view.frame.width * 0.5, y: yq_progress_view.frame.midY - yq_slider_view.frame.height * 0.5)
        }()
    }
    
   fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(yq_progress_view)
        addSubview(yq_slider_view)
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(yq_progress_tap_click(tap:)))
        addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(yq_progress_pan_click(pan:)))
        addGestureRecognizer(pan)
    }
    
    private lazy var yq_progress_config: (progressTintColor: UIColor, trackTintColor: UIColor, isCorners: Bool) = (progressTintColor: UIColor.systemBlue, trackTintColor: UIColor.systemGray2, isCorners: true)
    private lazy var yq_slider_config: (size: CGSize, color: UIColor, isCorners: Bool) = (size: CGSize(width: 15, height: 15), color: UIColor.systemOrange, isCorners: true)
    
    convenience init(frame: CGRect = .zero, progressConfig: (progressTintColor: UIColor, trackTintColor: UIColor, isCorners: Bool)? = nil, sliderConfig: (size: CGSize, color: UIColor, isCorners: Bool)? = nil) {
        
        self.init(frame: frame)
        
        if progressConfig != nil {
            yq_progress_config = progressConfig!
        }
        
        if sliderConfig != nil {
            yq_slider_config = sliderConfig!
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    var yq_slider_value_change_block: ((_ progress: Float) -> Void)?
    var yq_slider_value_cancel_block: (() -> Void)?
}


extension JY_Normal_Slider {
    @objc private func yq_progress_tap_click(tap: UITapGestureRecognizer) {
        let pointX = tap.location(in: self).x
        
        var progress = Float(pointX / frame.width)
        
        if progress <= 0 {
            progress = 0
        }
        
        if progress >= 1 {
            progress = 1
        }
        
        if yq_slider_value_change_block != nil {
            yq_slider_value_change_block!(progress)
        }
        
        yq_set(progress: progress)
    }
    
    @objc private func yq_progress_pan_click(pan: UIPanGestureRecognizer) {
        let pointX = pan.location(in: self).x
        
        var progress = Float(pointX / frame.width)
        
        if progress <= 0 {
            progress = 0
        }
        
        if progress >= 1 {
            progress = 1
        }
        
        if pan.state == .changed {
            if yq_slider_value_change_block != nil {
                yq_slider_value_change_block!(progress)
            }
        }
        
        if pan.state == .ended {
            if yq_slider_value_cancel_block != nil {
                yq_slider_value_cancel_block!()
            }
        }
        
        yq_set(progress: progress)
    }
}
