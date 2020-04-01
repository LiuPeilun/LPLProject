//
//  VideoTableViewController.h
//  health-regimen
//
//  Created by home on 2019/10/21.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoTableViewController : UITableViewController

//用于生成文件在caches目录中的路径
- (NSString *)cacheDir;

@end

NS_ASSUME_NONNULL_END
