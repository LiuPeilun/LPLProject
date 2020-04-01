//
//  SelfTableViewController.h
//  health-regimen
//
//  Created by home on 2019/10/21.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelfTableViewCell.h"
#import "LPLTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SelfTableViewControllerDelegate <NSObject>

-(void)removeHistory;

@end

@interface SelfTableViewController : UITableViewController<SelfTableViewCellDelegate, UITabBarControllerDelegate>

@property(nonatomic, strong) id<SelfTableViewControllerDelegate> delegate1;
@property(nonatomic, strong) id<SelfTableViewControllerDelegate> delegate2;

@end

NS_ASSUME_NONNULL_END
