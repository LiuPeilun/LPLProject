//
//  KonwTableItem.m
//  health-regimen
//
//  Created by home on 2019/11/16.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "KonwTableItem.h"

@implementation KonwTableItem

+ (instancetype)knowTableDataWithDict:(NSDictionary *)dict{
    KonwTableItem *item = [[KonwTableItem alloc] init];
    
    item.title = dict[@"title"];
    item.text = dict[@"text"];
    item.icon1 = dict[@"icon1"];
    item.icon2 = dict[@"icon2"];
    item.icon3 = dict[@"icon3"];
    item.url = dict[@"url"];
    
    return item;
}

@end
