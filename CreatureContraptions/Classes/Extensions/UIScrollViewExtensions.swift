//
//  UIScrollViewExtensions.swift
//  Clime
//
//  Copyright (c) 2020 Chris Pflepsen
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

extension UIScrollView {
    
    //Scrolls the scrollview to the passed in views giving priority to the earliest view in the array,
    //if the passed in views occupy too large of an area to fully display we will remove the last view
    //and recursively call this function until the views fit or there are no views left
    func scrollToViews(_ views: [UIView], animated: Bool = true) {
        guard let firstView = views.first,
            let firstSuperview = firstView.superview else { return }
        
        var scrollRect = convert(firstView.frame, from: firstSuperview)
        var views = views
        
        let bottomPadding: CGFloat = 10.0
        
        for view in views {
            var frame = view.frame
            if let viewSuperview = view.superview {
                frame = convert(frame, from: viewSuperview)
            }
            scrollRect = scrollRect.union(frame)
        }
        
        scrollRect.size.height += bottomPadding
        
        let visibleHeight = bounds.size.height - contentInset.bottom - contentInset.top
        
        guard scrollRect.size.height <= visibleHeight else {
            views.removeLast()
            scrollToViews(views)
            return
        }
        
        DispatchQueue.main.async {
            self.scrollRectToVisible(scrollRect, animated: animated)
        }
    }
    
    //Adjusts the inset of the scrollview to account for the keyboard and will scrol to the views if those are provided
    func adjustContentInsetForKeyboard(withNotification notification: Notification,
                                       containerView view: UIView,
                                       scrollToViews views: [UIView]? = nil,
                                       includeSafeArea: Bool? = true,
                                       customBottomInset: CGFloat = 0.0) {
        
        guard let userInfo = notification.userInfo,
            let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else { return }
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame.cgRectValue, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: customBottomInset, right: 0)
        } else if notification.name == UIResponder.keyboardWillChangeFrameNotification {
            //Make sure the new frame of the keyboard is on screen
            guard keyboardViewEndFrame.origin.y < self.frame.height else { return }
            
            let bottomInset = includeSafeArea == true ? 0 : (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - bottomInset, right: 0)
            
            guard let views = views else { return }
            scrollToViews(views)
        }
    }
}
