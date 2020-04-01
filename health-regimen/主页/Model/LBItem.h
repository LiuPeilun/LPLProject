//
//  LBItem.h
//  health-regimen
//
//  Created by home on 2019/10/29.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LBItem : NSObject

@property(nonatomic, copy) NSString *imageName;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)itemWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
