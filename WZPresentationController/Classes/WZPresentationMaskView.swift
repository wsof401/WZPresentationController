//
//  WZPresentationMaskView.swift
//
//  Created by 吴哲 on 2018/5/3.
//  Copyright © 2018年 arcangelw. All rights reserved.
//  图层遮罩

import UIKit

open class WZPresentationMaskView: UIView {
    /// 指定允许用户与之交互的UIView实例数组 默认为空
    public var passthroughViews: [UIView] = [] {
        willSet{
            ///有可以交互UIView实例 默认打开dismissPresentedOnTap
            guard !newValue.isEmpty else { return }
            self.dismissPresentedOnTap = true
        }
    }
    
    /// 点击遮罩dismiss presentedViewController 默认不可以
    public var dismissPresentedOnTap = false
    
    /// 是否模糊
    public fileprivate(set) var isBlur = false
    
    weak var presentedViewController: WZPresentedViewController!
    
    required public init(presentedViewController: WZPresentedViewController) {
        self.presentedViewController = presentedViewController
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        //        //presentedViewController.view 事件并不会传递过来 因此没必要做多余判断
        //        var dismiss = false
        //        if self.dismissPresentedOnTap == true {
        //            let toPoint = self.convert(point, to: self.presentedViewController.view)
        //            dismiss = self.presentedViewController.view.bounds.contains(toPoint) == false
        //        }
        
        var hit = super.hitTest(point, with: event)
        var animated = true

        defer {
            if dismissPresentedOnTap {
                presentedViewController.dismiss(animated: animated, completion: nil)
                dismissPresentedOnTap = false
            }
        }

        if isBlur && hit == self,
            let newHit = passthroughViews.first(where: { $0.hitTest(convert(point, to: $0), with: event) != .none }) {
            hit = newHit
            animated = false
        }

        return hit
    }
}


extension WZPresentationMaskView {
    
    public func setBlurEffect(withView view: UIView ,type: WZPresentationBlurEffectStyle?){
        guard let `type` = type, let snapImage = view.wz_snapshotImage() else { return }
        ///模糊处理
        DispatchQueue.global().async {
            let image: UIImage?
            switch type {
            case .extraLight:
                image = snapImage.wz_imageByBlurExtraLight
            case .light:
                image = snapImage.wz_imageByBlurLight
            case .dark:
                image = snapImage.wz_imageByBlurDark
            }

            guard let blurImage = image else { return }
            let blurColor = UIColor(patternImage: blurImage)
            DispatchQueue.main.async {
                self.isBlur = true
                self.backgroundColor = blurColor
            }
        }
    }
}
