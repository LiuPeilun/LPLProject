//
//  UIColor+LPLColor.m
//  health-regimen
//
//  Created by home on 2019/11/5.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "UIColor+LPLColor.h"

//#import <AppKit/AppKit.h>

@implementation UIColor (LPLColor)

//字体颜色
+(UIColor *)labelColor{
    UIColor *lplColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
        if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
            return [UIColor blackColor];
        }
        else {
            return [UIColor colorWithRed:118/255.0 green:117/255.0 blue:123/255.0 alpha:1];
        }
    }];
    
    return lplColor;
}

//tableView背景色
+(UIColor *)tableViewBackColor{
    
    UIColor *lplColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
        if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
            return [UIColor whiteColor];
        }
        else {
            return [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1];
        }
    }];
    
    return lplColor;
}

//tableView组头颜色
+(UIColor *)tableViewHeadColor{
    
    UIColor *lplColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
               if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                   //白天白色
                   return [UIColor colorWithRed:237/255.0 green:236/255.0 blue:235/255.0 alpha:1];
               }
               else {
                   //暗黑灰色
                   return [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1];
               }
           }];
    
    return lplColor;
}

//导航栏颜色
+(UIColor *)navigationBarColor{
    
    UIColor *lplColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
               if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                   //白天白色
                   return [UIColor colorWithRed:83/255.0 green:182/255.0 blue:25/255.0 alpha:1];
               }
               else {
                   //暗黑灰色
                   return [UIColor colorWithRed:37/255.0 green:89/255.0 blue:21/255.0 alpha:1];
               }
           }];
    
    return lplColor;
}

//tabbar颜色
+(UIColor *)tabBarColor{
    
    UIColor *lplColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
               if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                   //白天白色
                   return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
               }
               else {
                   //暗黑灰色
                   return [UIColor colorWithRed:41/255.0 green:42/255.0 blue:46/255.0 alpha:1];
               }
           }];
    
    return lplColor;
}

//cell颜色
+(UIColor *)cellColor{
    UIColor *lplColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
        if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
            //白天白色
            return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        }
        else {
            //暗黑灰色
            return [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1];
        }
    }];
    
    return lplColor;
}

//底部小字颜色
+(UIColor *)bottomLabelColor{
    
    UIColor *lplColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
        if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
            return [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
        }
        else {
            return [UIColor colorWithRed:118/255.0 green:117/255.0 blue:123/255.0 alpha:1];
        }
    }];
    
    return lplColor;
    
}

@end
