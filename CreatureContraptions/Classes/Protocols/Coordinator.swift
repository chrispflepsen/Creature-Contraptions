//
//  Coordinator.swift
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

public enum CoordinatorId: String {
    case authorization
    case onboarding
    case forgotPassword
    case createAccount
    case dashboard
    case appCoordinator
}

public protocol Coordinator: class {
    var parentCoordinator: Coordinator? { get }
    var childCoordinators: [CoordinatorId: Coordinator] { get set }
    func start()

    //Optional, default implementaion will be used unless implemented
    func commonStart()
    func addChildCoordinator(coordinator: Coordinator, withId: CoordinatorId)
    func removeChildCoordinator(_ coordinatorId: CoordinatorId)
    func showLoadingScreen(animated: Bool, showSpinner: Bool, completion: (() -> Void)?)
    func dismissLoadingScreen(animated: Bool, completion: (() -> Void)?)
    func presentViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismissViewController(animated: Bool, completion: (() -> Void)?)
    func dismissAllPresentedViewControllers(animated: Bool, completion: (() -> Void)?)
    func showError(_ error: String?)
}

extension Coordinator {
    
    public func commonStart() {
        //Do nothing, this is where any data should be initialized in classes that conform to the protocol
    }
    
    public func addChildCoordinator(coordinator: Coordinator, withId coordinatorId: CoordinatorId) {
        childCoordinators[coordinatorId] = coordinator
    }
    
    public func removeChildCoordinator(_ coordinatorId: CoordinatorId) {
        childCoordinators[coordinatorId] = nil
    }
    
    public func showLoadingScreen(animated: Bool, showSpinner: Bool, completion: (() -> Void)? = nil) {
        parentCoordinator?.showLoadingScreen(animated: animated, showSpinner: showSpinner, completion: completion)
    }
    
    public func dismissLoadingScreen(animated: Bool, completion: (() -> Void)? = nil) {
        parentCoordinator?.dismissLoadingScreen(animated: animated, completion: completion)
    }
    
    public func presentViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        parentCoordinator?.presentViewController(viewController, animated: animated, completion: completion)
    }
    
    public func dismissViewController(animated: Bool, completion: (() -> Void)? = nil) {
        parentCoordinator?.dismissViewController(animated: animated, completion: completion)
    }
    
    public func dismissAllPresentedViewControllers(animated: Bool, completion: (() -> Void)? = nil) {
        parentCoordinator?.dismissAllPresentedViewControllers(animated: animated, completion: completion)
    }
    
    public func showError(_ error: String?) {
        parentCoordinator?.showError(error)
    }
    
}
