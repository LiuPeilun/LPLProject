//
//  AppDelegate.m
//  health-regimen
//
//  Created by home on 2019/10/21.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor purpleColor];
//
//    UITabBarController *tabBar = [[UITabBarController alloc] init];
//    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:tabBar];
//    
//    self.window.rootViewController = navVC;
//    [self.window makeKeyAndVisible];
    //修改tabbar默认的蓝色渲染
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:8/255.0 green:163/255.0 blue:27/255.0 alpha:1]];
    
    //延长launchImage显示时长
    [NSThread sleepForTimeInterval:3];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
