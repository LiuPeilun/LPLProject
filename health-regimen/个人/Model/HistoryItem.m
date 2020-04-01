//
//  HistoryItem.m
//  health-regimen
//
//  Created by home on 2019/11/29.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "HistoryItem.h"

@implementation HistoryItem

+(instancetype)itemWithDict:(NSDictionary *)dict{
    HistoryItem *item = [[HistoryItem alloc] init];
    
    item.icon = dict[@"icon"];
    item.title = dict[@"title"];
    item.url = dict[@"url"];
    
    return item;
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    HistoryItem *item = [[HistoryItem alloc] init];
    
    item.icon = dict[@"icon"];
    item.title = dict[@"title"];
    item.url = dict[@"url"];
    
    return item;
}


@end
