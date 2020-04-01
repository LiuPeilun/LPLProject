//
//  KnowWebViewController.h
//  health-regimen
//
//  Created by home on 2019/11/16.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "KnowledgeViewController.h"
#import "MBProgressHUD+XMG.h"

NS_ASSUME_NONNULL_BEGIN

@interface KnowWebViewController : UIViewController<KnowledgeViewControllerDelegate,MBProgressHUDDelegate,WKUIDelegate>

@end

NS_ASSUME_NONNULL_END
