//
//  WDTabBarViewController.swift
//  WardrobeApp
//
//  Created by Igor Khomenko on 12/19/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit

class WDTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if selectedViewController == nil || viewController == selectedViewController {
//            return false
//        }
//
//        let fromView = selectedViewController!.view
//        let toView = viewController.view
//
//        UIView.transition(from: fromView!, to: toView!, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
//
//        return true
//    }
//
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let tabViewControllers = tabBarController.viewControllers!
        guard let toIndex = tabViewControllers.index(of: viewController) else {
            return false
        }
        
        // Our method
        animateToTab(toIndex: toIndex)
        
        return true
    }
    
    func animateToTab(toIndex: Int) {
        let tabViewControllers = viewControllers!
        let fromView = selectedViewController?.view
        let toView = tabViewControllers[toIndex].view
        let fromIndex = tabViewControllers.index(of: selectedViewController!)
        
        guard fromIndex != toIndex else {return}
        fromView?.superview!.addSubview(toView!)

        let screenWidth = UIScreen.main.bounds.size.width
        let from = fromIndex! as Int
        let scrollRight = toIndex > from
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView?.center = CGPoint(x: (fromView?.center.x)! + offset, y: (toView?.center.y)!)
        
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            fromView?.center = CGPoint(x: (fromView?.center.x)! - offset, y: (fromView?.center.y)!);
            toView?.center   = CGPoint(x: (toView?.center.x)! - offset, y: (toView?.center.y)!);
            
        }, completion: { finished in
            
            fromView?.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }
}
