//
//  SceneDelegate.swift
//  SplashAnimiationDemo
//
//  Created by swiftprimer on 2020/11/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor(red: 128.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        guard let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else { return }
        window?.rootViewController = navigationController
        
        //logo mask
        let maskLayer = CALayer()
        maskLayer.contents = UIImage(named: "logo")?.cgImage
        maskLayer.position = navigationController.view.center
        maskLayer.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        navigationController.view.layer.mask = maskLayer
        
        //logo mask background view
        let maskBackgroundView = UIView(frame: navigationController.view.bounds)
        maskBackgroundView.backgroundColor = .white
        navigationController.view.addSubview(maskBackgroundView)
        navigationController.view.bringSubviewToFront(maskBackgroundView)
        
        //logo mask animation
        let logoMaskAnimaiton = CAKeyframeAnimation(keyPath: "bounds")
        logoMaskAnimaiton.duration = 1.0
        logoMaskAnimaiton.beginTime = CACurrentMediaTime() + 1.0
        
        let initalBounds = maskLayer.bounds
        let secondBounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        let finalBounds  = CGRect(x: 0, y: 0, width: 2000, height: 2000)
        logoMaskAnimaiton.values = [initalBounds, secondBounds, finalBounds]
        logoMaskAnimaiton.keyTimes = [0, 0.5, 1]
        logoMaskAnimaiton.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut), CAMediaTimingFunction(name: .easeOut), CAMediaTimingFunction(name: .easeOut)]
        logoMaskAnimaiton.isRemovedOnCompletion = false
        logoMaskAnimaiton.fillMode = .forwards
        navigationController.view.layer.mask?.add(logoMaskAnimaiton, forKey: "logoMaskAnimaiton")
        
        UIView.animate(withDuration: 0.1, delay: 1.35, options: .curveEaseIn) {
            maskBackgroundView.alpha = 0
        } completion: { (finish) in
            maskBackgroundView.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.25, delay: 1.3, options: []) {
            navigationController.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } completion: { (finish) in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                navigationController.view.transform = .identity
            } completion: { (finish) in
                navigationController.view.layer.mask = nil
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

