//
//  UIColor+LPLColor.h
//  health-regimen
//
//  Created by home on 2019/11/5.
//  Copyright © 2019 lpl. All rights reserved.
//



#import <UIKit/UIKit.h>
//#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (LPLColor)

//字体颜色
+(UIColor *)labelColor;
//tableView背景色
+(UIColor *)tableViewBackColor;
//tableView组头颜色
+(UIColor *)tableViewHeadColor;
//导航栏颜色
+(UIColor *)navigationBarColor;
//tabbar颜色
+(UIColor *)tabBarColor;
//cell颜色
+(UIColor *)cellColor;
//底部小字颜色
+(UIColor *)bottomLabelColor;

@end

NS_ASSUME_NONNULL_END
