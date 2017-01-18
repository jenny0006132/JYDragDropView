//
//  JYDragDropView.swift
//  DrapDrop
//
//  Created by Jenny Yao on 2017/1/18.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import UIKit

class JYDragDropView: UIView {
    
    var currentDrag: UIView?
    var viewCount: Int = 0
    
    init(frame: CGRect, viewCount: Int) {
        
        super.init(frame: frame)
        
        self.viewCount = viewCount
        
        let firstPointX = frame.width/CGFloat(viewCount + 1)
        for i in 1...viewCount {
            
            let dragView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            dragView.center = CGPoint(x: CGFloat(i)*firstPointX, y: center.y)
            dragView.tag = i
            dragView.backgroundColor = UIColor.randomColor()
            dragView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))
            addSubview(dragView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            currentDrag = gesture.view
            if let dragView = currentDrag {
                currentDrag?.originCenter = dragView.center
                bringSubview(toFront: dragView)
            }
        }
        else if gesture.state == .changed {
            
            let translation = gesture.translation(in: self)
            
            if let dragView = currentDrag {
                dragView.center = CGPoint(x: dragView.center.x + translation.x, y: dragView.center.y + translation.y)
                
                let point = gesture.location(in: self)
                
                if point.x > dragView.originCenter.x { //right
                    
                    if dragView.center.x + dragView.frame.width/2 >= dragView.originCenter.x + frame.width/CGFloat(viewCount + 1) {
                        
                        if let rightView = viewWithTag(dragView.tag + 1) {
                            print("right swap")
                            
                            let rightViewCenter = rightView.center
                            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                                rightView.center = dragView.originCenter
                                rightView.tag -= 1
                            }, completion: nil)
                            
                            dragView.originCenter = rightViewCenter
                            dragView.tag += 1
                        }
                        
                    }
                }
                else { //left
                    if dragView.center.x - dragView.frame.width/2 <= dragView.originCenter.x - frame.width/CGFloat(viewCount + 1) {
                        
                        if let leftView = viewWithTag(dragView.tag - 1), leftView.tag > 0 {
                            
                            print("left swap")
                            
                            let leftViewCenter = leftView.center
                            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                                leftView.center = dragView.originCenter
                                leftView.tag += 1
                            }, completion: nil)
                            
                            dragView.originCenter = leftViewCenter
                            dragView.tag -= 1
                        }
                    }
                }
            }
            gesture.setTranslation(CGPoint.zero, in: self)
        }
        else if gesture.state == .ended {
            
            if let dragView = currentDrag {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    dragView.center = dragView.originCenter
                }, completion: nil)
            }
        }
    }
}

var AssociatedObjectHandle: UInt8 = 0

extension UIView {
    
    var originCenter: CGPoint {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? CGPoint ?? CGPoint.zero
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension CGFloat {
    
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    
    static func randomColor() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
