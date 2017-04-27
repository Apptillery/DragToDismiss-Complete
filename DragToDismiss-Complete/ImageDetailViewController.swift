//
//  ImageDetailViewController.swift
//  EasyAnimatedTransition
//
//  Created by Alex Gibson on 3/29/17.
//  Copyright © 2017 AG. All rights reserved.
//

import UIKit

class ImageDetailViewController:UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var containerView: DraggableView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var image : UIImage?
    var fadeView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        
        containerView.delegate = self
        
        self.view.backgroundColor = .clear
        fadeView = UIView(frame: view.bounds)
        fadeView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        fadeView?.backgroundColor = .black
        if let fv = fadeView{
            self.view.insertSubview(fv, at: 0)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imgView.image = image
    }
    
    
    @IBAction func closeDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustScrollViewInsets()
    }
    
    func adjustScrollViewInsets(){
        if scrollView.contentOffset.y < 0{
            let leftMargin = (scrollView.frame.size.width - self.containerView.frame.size.width) * 0.5
            let topMargin = (scrollView.frame.size.height - self.containerView.frame.size.height) * 0.5
            scrollView.contentInset = UIEdgeInsets(top: topMargin, left: leftMargin, bottom: 0, right: 0)
        }else{
            if scrollView.contentInset != .zero{
                scrollView.contentInset = .zero
            }
        }
    }
    
}

extension ImageDetailViewController: DraggableViewDelegate{
    func panGestureDidBegin(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint) {
        //no need
    }
    
    func panGestureDidChange(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint, velocityInView: CGPoint) {
        containerView?.frame.origin = CGPoint(
            x: containerView!.frame.origin.x,
            y: translation.y
        )
        
        if containerView.center.y > originalCenter.y {
            let alpha = 1 - (abs(self.view.bounds.height/2 - containerView.center.y)/(self.view.bounds.height))
            self.fadeView?.alpha = alpha
        }else{
            self.fadeView?.alpha = 1
        }
    }
    
    func panGestureDidEnd(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint, velocityInView: CGPoint) {
        if containerView.center.y >= containerView.bounds.height * 0.66{
            if let _ = transitioningDelegate{
                self.dismiss(animated: true, completion: nil)
            }else{
                //handle non custom presentation
                UIView.animate(withDuration: 0.3, animations: {
                    self.containerView.frame.origin.y = self.view.bounds.height
                }, completion: { (finished) in
                    self.dismiss(animated: false, completion: nil)
                })
            }

        }else{
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                self.containerView.center = originalCenter
                self.fadeView?.alpha = 1
            }, completion: nil)
        }
    }
}
