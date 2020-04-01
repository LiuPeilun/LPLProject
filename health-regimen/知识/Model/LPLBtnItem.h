//
//  LPLBtnItem.h
//  health-regimen
//
//  Created by home on 2019/10/27.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPLBtnItem : NSObject

@property(nonatomic, copy) NSString *btnName;
@property(nonatomic, copy) NSString *btnImage;

+(instancetype)itemWithDict:(NSDictionary *)dict;
-(instancetype)initWithDictL:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
