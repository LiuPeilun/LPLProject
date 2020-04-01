//
//  JsonUrlItem.m
//  health-regimen
//
//  Created by home on 2019/12/1.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "JsonUrlItem.h"

@implementation JsonUrlItem

+(instancetype)jsonUrlWithDict:(NSDictionary *)dict{
    JsonUrlItem *item = [[JsonUrlItem alloc] init];
    
    item.jsonUrl = dict[@"jsonUrl"];
    
    return item;
}

@end
