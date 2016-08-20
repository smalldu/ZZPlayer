//
//  ZZPlayerView.swift
//  ZZPlayer
//
//  Created by duzhe on 16/8/19.
//  Copyright © 2016年 dz. All rights reserved.

import UIKit
import AVFoundation

protocol ZZPlayerViewDelegate:NSObjectProtocol {
    
    func zzplayer(playerView:ZZPlayerView,sliderTouchUpOut slider:UISlider)
    func zzplayer(playerView:ZZPlayerView,playAndPause playBtn:UIButton)
}

class ZZPlayerView: UIView {
    var playerLayer:AVPlayerLayer?
    var slider:UISlider!
    var progressView:UIProgressView!
    var playBtn:UIButton!
    
    var timeLabel:UILabel!
    var sliding = false
    var playing = true
    weak var delegate:ZZPlayerViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        slider = UISlider()
        self.addSubview(slider)
        slider.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).inset(5)
            make.left.equalTo(self).offset(50)
            make.right.equalTo(self).inset(100)
            make.height.equalTo(15)
        }
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        // 从最大值滑向最小值时杆的颜色
        slider.maximumTrackTintColor = UIColor.clearColor()
        // 从最小值滑向最大值时杆的颜色
        slider.minimumTrackTintColor = UIColor.whiteColor()
        // 在滑块圆按钮添加图片
        slider.setThumbImage(UIImage(named:"slider_thumb"), forState: UIControlState.Normal)
        
        progressView = UIProgressView()
        progressView.backgroundColor = UIColor.lightGrayColor()
        self.insertSubview(progressView, belowSubview: slider)
        progressView.snp_makeConstraints { (make) in
            make.left.right.equalTo(slider)
            make.centerY.equalTo(slider)
            make.height.equalTo(2)
        }
        
        progressView.tintColor = UIColor.redColor()
        progressView.progress = 0
        
        timeLabel = UILabel()
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.font = UIFont.systemFontOfSize(12)
        self.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self)
            make.left.equalTo(slider.snp_right).offset(10)
            make.bottom.equalTo(self).inset(5)
        }
        playBtn = UIButton()
        self.addSubview(playBtn)
        playBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(slider)
            make.left.equalTo(self).offset(10)
            make.width.height.equalTo(30)
        }
        playBtn.setImage(UIImage(named: "player_pause"), forState: UIControlState.Normal)
        playBtn.addTarget(self, action: #selector(playAndPause( _:)) , forControlEvents: UIControlEvents.TouchUpInside)
        
        // 按下的时候
        slider.addTarget(self, action: #selector(sliderTouchDown( _:)), forControlEvents: UIControlEvents.TouchDown)
        // 弹起的时候
        slider.addTarget(self, action: #selector(sliderTouchUpOut( _:)), forControlEvents: UIControlEvents.TouchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut( _:)), forControlEvents: UIControlEvents.TouchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut( _:)), forControlEvents: UIControlEvents.TouchCancel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }
    
    
    func sliderTouchDown(slider:UISlider){
        self.sliding = true
    }
    func sliderTouchUpOut(slider:UISlider){
        delegate?.zzplayer(self, sliderTouchUpOut: slider)
    }
    
    func playAndPause(btn:UIButton){
        let tmp = !playing
        playing = tmp
        if playing {
            playBtn.setImage(UIImage(named: "player_pause"), forState: UIControlState.Normal)
        }else{
            playBtn.setImage(UIImage(named: "player_play"), forState: UIControlState.Normal)
        }
        delegate?.zzplayer(self, playAndPause: btn)
    }
    
    
}

//MARK: - 延时执行
func delay(seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

