//
//  LPLTabBarView.h
//  health-regimen
//
//  Created by home on 2019/11/12.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LPLTabBarView;
@protocol LPLTabBarViewDelegate <NSObject>

-(void)tabBar:(LPLTabBarView *)tabBar index:(NSInteger)index;

@end

@interface LPLTabBarView : UIView

@property(nonatomic, strong) id<LPLTabBarViewDelegate> delegate;
@property(nonatomic, strong) NSArray *item;

-(void)showTabBar;
-(void)hideTabBar;
@end

NS_ASSUME_NONNULL_END
