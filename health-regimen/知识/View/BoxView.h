//
//  BoxView.h
//  health-regimen
//
//  Created by home on 2019/10/27.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BoxView;
@protocol BoxViewDelegate <NSObject>

-(void)boxView:(BoxView *)boxView tag:(NSInteger)tag title:(NSString *)title;

@end

@interface BoxView : UIView

@property(nonatomic, weak) id<BoxViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
