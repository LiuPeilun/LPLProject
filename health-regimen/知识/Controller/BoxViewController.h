//
//  BoxViewController.h
//  健康养生
//
//  Created by B04 on 2019/10/24.
//  Copyright © 2019年 B04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class ToolsViewController;
@protocol BoxViewControllerDelegate <NSObject>

-(void)toolsWithTag:(NSInteger)tag title:(NSString *)title;

@end

@interface BoxViewController : UIViewController

@property(nonatomic, weak) id<BoxViewControllerDelegate> delegate;

@end
