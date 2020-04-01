//
//  HistoryItem.h
//  health-regimen
//
//  Created by home on 2019/11/29.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryItem : NSObject

@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *url;

+(instancetype)itemWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
