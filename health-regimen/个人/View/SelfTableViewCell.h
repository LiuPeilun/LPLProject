//
//  SelfTableViewCell.h
//  health-regimen
//
//  Created by home on 2019/10/28.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SelfTableViewCell;
@protocol SelfTableViewCellDelegate <NSObject>

-(void)tableViewCell:(SelfTableViewCell *)cell sliderValue:(CGFloat)value;
-(void)tableViewCell:(SelfTableViewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier;
-(void)tableViewCell:(SelfTableViewCell *)cell isOn:(BOOL)isOn;

@end

@interface SelfTableViewCell : UITableViewCell

@property(nonatomic, weak) id<SelfTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
