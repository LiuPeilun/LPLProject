//
//  CacheManager.m
//  health-regimen
//
//  Created by home on 2019/11/3.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "CacheManager.h"

static CacheManager *cacheManager = nil;

@interface CacheManager()

@property(nonatomic, copy) NSString *cachesDirPath;


@end

@implementation CacheManager

-(instancetype) init{
    
    if(self = [super init]){
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        _cachesDirPath = [cachePath copy];
    }
    return self;
}

+(CacheManager *)shareManager{
    if(cacheManager == nil){
        @synchronized (self) {
            if(cacheManager == nil){
                cacheManager = [[[self class] alloc] init];
            }
        }
    }
    
    return cacheManager;
}

//清理缓存文件的实现，如果获取到缓存文件大小大于0，则进行清理操作
- (BOOL)clearCaches{
    if([self requestCachesFlieSize] > 0){
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:_cachesDirPath];
        for(NSString *file in files){
            NSString *path = [_cachesDirPath stringByAppendingPathComponent:file];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:path]){
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
        }
        
        return YES;
    }else{
        return NO;
    }
    
}

//获取所有缓存文件大小
- (NSString *)getAllTheCacheFileSize{
    
    NSString *fileSize = [NSString stringWithFormat:@"%.3f MB", [self requestCachesFlieSize]];
    
    return fileSize;
}

//通过路径获取文件的大小
-(long long)fileSizePath:(NSString *)filePath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

//遍历整个项目文件夹获取所有的文件大小
-(float)requestCachesFlieSize{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if(![manager fileExistsAtPath:_cachesDirPath]){
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:_cachesDirPath] objectEnumerator];
    
    NSString *fileName;
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [_cachesDirPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizePath:fileAbsolutePath];
    }
    
    return folderSize/(1024.0 * 1024.0);
}
@end
