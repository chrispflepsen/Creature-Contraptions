//
//  RxViewControllerExtensions.swift
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
import RxSwift

extension RxViewController where Self: UIViewController {
    private var recognizerName: String {
        return "tapToDismissKeyboard"
    }
    
    public func enableTapToDismissKeyboardGesture() {
        
        guard let tap = view.gestureRecognizers?.first(where: { $0.name == recognizerName }) else {
            let tap = UITapGestureRecognizer()
            view.addGestureRecognizer(tap)
            
            tap.rx.event.subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
                .disposed(by: bag)
            
            return
        }
        tap.isEnabled = true
    }
    
    public func disableTapToDismissKeyboardGesture() {
        guard let tap = view.gestureRecognizers?.first(where: { $0.name == recognizerName }) else {
            return
        }
        tap.isEnabled = false
    }
}

extension RxScrollingViewController where Self: UIViewController {
    
    /// Scrolls the view and will attempt fit all the views in the availible space giving prioity to the first view
    public func addKeyboardAvoidance(withViews views: [UIView]) {
        let changeFrame = NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification).asObservable()
        let willHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).asObservable()
        
        changeFrame
            .subscribe(onNext: { [weak self] (notification) in
                self?.adjustForKeyboard(notification: notification, views: views)
            })
            .disposed(by: bag)
        
        willHide
            .subscribe(onNext: { [weak self] (notification) in
                self?.adjustForKeyboard(notification: notification, views: views)
            })
        .disposed(by: bag)
        
    }
    
    private func adjustForKeyboard(notification: Notification, views: [UIView]) {
        scrollView.adjustContentInsetForKeyboard(withNotification: notification,
                                                 containerView: containerView,
                                                 scrollToViews: views)
    }
}
