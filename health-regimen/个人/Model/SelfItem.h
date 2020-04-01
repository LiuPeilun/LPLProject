//
//  SelfItem.h
//  health-regimen
//
//  Created by home on 2019/10/28.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelfItem : NSObject

@property(nonatomic, assign) NSString *group;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *title;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)itemWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
