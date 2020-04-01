//
//  TableItem.m
//  health-regimen
//
//  Created by home on 2019/11/16.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "TableItem.h"

@implementation TableItem

+(instancetype)tableDataWithDict:(NSDictionary *)dic{
    TableItem *item = [[TableItem alloc] init];
    
    item.title = dic[@"title"];
    item.text = dic[@"text"];
    item.icon = dic[@"icon"];
    item.url = dic[@"url"];
    
    return item;
    
}



@end
