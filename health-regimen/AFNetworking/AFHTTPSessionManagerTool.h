//
//  AFHTTPSessionManagerTool.h
//  health-regimen
//
//  Created by home on 2020/4/25.
//  Copyright © 2020 lpl. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFHTTPSessionManagerTool : AFHTTPSessionManager

//单例方法
+(instancetype )shareManager;

@end

NS_ASSUME_NONNULL_END
