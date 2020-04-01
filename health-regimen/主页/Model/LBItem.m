//
//  LBItem.m
//  health-regimen
//
//  Created by home on 2019/10/29.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "LBItem.h"

@implementation LBItem

-(instancetype)initWithDict:(NSDictionary *)dict{
    LBItem *item = [[LBItem alloc] init];
    
    item.imageName = dict[@"imageName"];
    
    return item;
}


+(instancetype)itemWithDict:(NSDictionary *)dict{
    LBItem *item = [[LBItem alloc] init];
    
    item.imageName = dict[@"imageName"];
    
    return item;
}

@end
