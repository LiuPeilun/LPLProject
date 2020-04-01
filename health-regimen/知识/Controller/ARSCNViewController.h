//
//  ARSCNViewController.h
//  health-regimen
//
//  Created by 312 on 2019/11/23.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ARSCNViewControllerDelegate <NSObject>

-(void)reload;

@end

@interface ARSCNViewController : UIViewController

@property (nonatomic, strong) id<ARSCNViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
