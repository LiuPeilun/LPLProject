//
//  LPLBtnView.h
//  health-regimen
//
//  Created by home on 2019/10/27.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPLBtnView;

NS_ASSUME_NONNULL_BEGIN

@protocol LPLBtnViewDelegate <NSObject>

//-(void)btnView:(LPLBtnView *)btnView height:(CGFloat)height;
-(void)btnView:(LPLBtnView *)btnView btnTag:(NSInteger)tag;

@end

@interface LPLBtnView : UIView

@property(nonatomic, weak) id<LPLBtnViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
