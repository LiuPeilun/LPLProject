//
//  KnowledgeViewController.h
//  health-regimen
//
//  Created by home on 2019/10/21.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSCNViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol KnowledgeViewControllerDelegate <NSObject>

-(void)cellClickWithURL:(NSString *)url;

@end

@interface KnowledgeViewController : UITableViewController<ARSCNViewControllerDelegate>

@property(nonatomic, strong) id<KnowledgeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
