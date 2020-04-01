//
//  CacheManager.h
//  health-regimen
//
//  Created by home on 2019/11/3.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheManager : NSObject

//单例
+(CacheManager *)shareManager;
//清理缓存
-(BOOL)clearCaches;
//获取所有缓存文件的大小
-(NSString *)getAllTheCacheFileSize;

@end

NS_ASSUME_NONNULL_END
