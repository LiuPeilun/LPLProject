//
//  BoxItem.m
//  健康养生
//
//  Created by B04 on 2019/10/24.
//  Copyright © 2019年 B04. All rights reserved.
//

#import "BoxItem.h"

@implementation BoxItem


+ (instancetype)initWithDict:(NSDictionary *)dic{
    
    BoxItem *item = [[BoxItem alloc] init];
    
    item.fileName = dic[@"FileName"];
    item.title = dic[@"Title"];
    item.icon = dic[@"Icon"];
    
    return  item;
}
@end
