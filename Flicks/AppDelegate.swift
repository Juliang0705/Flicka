//
//  AppDelegate.swift
//  Flicks
//
//  Created by Juliang Li on 1/14/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nowPlayingNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MovieViewController
        nowPlayingViewController.endPoint = "now_playing"
        nowPlayingViewController.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "now_playing.png")
        
        
        let topRatedNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! MovieViewController
        topRatedViewController.endPoint = "top_rated"
        topRatedViewController.title = "Top Rated"
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "top_rated.png")
        
        let popularNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        let popularViewController = popularNavigationController.topViewController as! MovieViewController
        popularViewController.endPoint = "popular"
        popularViewController.title = "Popular"
        popularNavigationController.tabBarItem.title = "Popular"
        popularNavigationController.tabBarItem.image = UIImage(named: "popular.png")
        
        
        let upcomingNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        let upcomingViewController = upcomingNavigationController.topViewController as! MovieViewController
        upcomingViewController.endPoint = "upcoming"
        upcomingViewController.title = "Upcoming"
        upcomingNavigationController.tabBarItem.title = "Upcoming"
        upcomingNavigationController.tabBarItem.image = UIImage(named: "upcoming.png")
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavigationController,topRatedNavigationController,popularNavigationController, upcomingNavigationController]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 27.0/255.0, green: 99.0/225.0, blue: 130.0/255.0, alpha: 1.0)        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

