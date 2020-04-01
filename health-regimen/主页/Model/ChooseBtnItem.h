//
//  ChooseBtnItem.h
//  health-regimen
//
//  Created by home on 2019/10/22.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseBtnItem : NSObject
//按钮名称
@property(nonatomic, copy) NSString *name;

//模型初始化类方法
+(instancetype)initWithDict:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
