//
//  AFHTTPSessionManagerTool.m
//  health-regimen
//
//  Created by home on 2020/4/25.
//  Copyright © 2020 lpl. All rights reserved.
//

#import "AFHTTPSessionManagerTool.h"

@implementation AFHTTPSessionManagerTool

//单例
+(instancetype)shareManager{
    static AFHTTPSessionManagerTool *manager;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        manager = [[AFHTTPSessionManagerTool alloc] initWithBaseURL:nil];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        manager.requestSerializer.timeoutInterval = 20;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return manager;
}

@end
