//
//  MainViewController.h
//  health-regimen
//
//  Created by home on 2019/10/21.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MainViewControllerDelegate <NSObject>

-(void)cellClickWithURL:(NSString *)url cellTag:(NSInteger)tag;

@end

@interface MainViewController : UITableViewController

@property(nonatomic, strong) id<MainViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
