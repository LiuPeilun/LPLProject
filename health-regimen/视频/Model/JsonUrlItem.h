//
//  JsonUrlItem.h
//  health-regimen
//
//  Created by home on 2019/12/1.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JsonUrlItem : NSObject

@property(nonatomic, copy) NSString *jsonUrl;

+(instancetype)jsonUrlWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
