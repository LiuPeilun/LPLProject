//
//  NSObject+Property.h
//  runtime字典转模型
//
//  Created by 312 on 2019/12/7.
//  Copyright © 2019 Lun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Property)

+(instancetype)modelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
