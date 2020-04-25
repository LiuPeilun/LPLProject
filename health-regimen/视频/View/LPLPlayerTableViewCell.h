//
//  LPLPlayerTableViewCell.h
//  health-regimen
//
//  Created by home on 2019/11/5.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "VideoItem.h"

NS_ASSUME_NONNULL_BEGIN
@class LPLPlayerTableViewCell;

typedef void (^CellBlock)(LPLPlayerTableViewCell *cell, UIButton *button);
@protocol LPLPlayerTableViewCellDelegate <NSObject>

-(void)playerTableViewCell:(UITableViewCell *)cell tag:(NSInteger)tag;

@end

@interface LPLPlayerTableViewCell : UITableViewCell

@property (nonatomic, strong) CellBlock block;
@property(nonatomic, strong) AVPlayer *player;
//@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) AVPlayerViewController * __nullable playerVC;

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UIView *view;
@property(nonatomic, strong) UIButton *button;
@property(nonatomic, strong) VideoItem *item;
@property(nonatomic, strong) UIImageView *loadImageView;
@property (nonatomic, strong) UILabel *labelBottom;
@property (nonatomic, strong) UILabel *labelTime;

@end

NS_ASSUME_NONNULL_END
