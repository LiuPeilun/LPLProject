//
//  BoxItem.h
//  健康养生
//
//  Created by B04 on 2019/10/24.
//  Copyright © 2019年 B04. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoxItem : NSObject

@property(nonatomic, copy)NSString *fileName;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *icon;

+(instancetype)initWithDict:(NSDictionary *)dic;
@end
