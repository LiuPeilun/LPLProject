//
//  HtmlItem.h
//  health-regimen
//
//  Created by home on 2019/10/31.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HtmlItem : NSObject

@property(nonatomic, copy) NSString *fileName;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)itemWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
