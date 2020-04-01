//
//  LPLBtnItem.m
//  health-regimen
//
//  Created by home on 2019/10/27.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "LPLBtnItem.h"

@interface LPLBtnItem()

@end

@implementation LPLBtnItem

//类方法初始化
+(instancetype)itemWithDict:(NSDictionary *)dict{
    LPLBtnItem *item = [[LPLBtnItem alloc] init];
    
    item.btnName = dict[@"btnName"];
    item.btnImage = dict[@"btnImage"];
    
    return item;
}

//对象方法初始化
-(instancetype)initWithDictL:(NSDictionary *)dict{
    
    LPLBtnItem *item = [[LPLBtnItem alloc] init];
    
    item.btnName = dict[@"btnName"];
    item.btnImage = dict[@"btnImage"];
    
    return item;
    
}

@end
