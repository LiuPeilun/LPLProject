//
//  SelfItem.m
//  health-regimen
//
//  Created by home on 2019/10/28.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "SelfItem.h"

@implementation SelfItem
//对象方法
-(instancetype)initWithDict:(NSDictionary *)dict{
    
    SelfItem *item = [[SelfItem alloc] init];
    
    item.group = dict[@"group"];
    item.type = dict[@"type"];
    item.imageName = dict[@"imageName"];
    item.title = dict[@"title"];
    
    return item;
}

//类方法
+(instancetype)itemWithDict:(NSDictionary *)dict{
    
    SelfItem *item = [[SelfItem alloc] init];
    
    item.group = dict[@"group"];
    item.type = dict[@"type"];
    item.imageName = dict[@"imageName"];
    item.title = dict[@"title"];
    
    return item;
}

@end
