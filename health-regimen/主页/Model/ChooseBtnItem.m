//
//  ChooseBtnItem.m
//  health-regimen
//
//  Created by home on 2019/10/22.
//  Copyright © 2019 lpl. All rights reserved.
//

#import "ChooseBtnItem.h"

@implementation ChooseBtnItem

+(instancetype)initWithDict:(NSDictionary *)dic{
    
    ChooseBtnItem *item = [[ChooseBtnItem alloc] init];
    item.name = dic[@"name"];
    
    return item;
}

@end
