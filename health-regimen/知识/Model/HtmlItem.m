//
//  HtmlItem.m
//  health-regimen
//
//  Created by home on 2019/10/31.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "HtmlItem.h"

@implementation HtmlItem

-(instancetype)initWithDict:(NSDictionary *)dict{
    HtmlItem *item = [[HtmlItem alloc] init];
    
    item.fileName = dict[@"URL"];
    
    return item;
}

+(instancetype)itemWithDict:(NSDictionary *)dict{
    HtmlItem *item = [[HtmlItem alloc] init];
    
    item.fileName = dict[@"URL"];
    
    return item;
}

@end
