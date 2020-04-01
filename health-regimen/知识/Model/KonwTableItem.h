//
//  KonwTableItem.h
//  health-regimen
//
//  Created by home on 2019/11/16.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KonwTableItem : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) NSString *icon1;
@property(nonatomic, strong) NSString *icon2;
@property(nonatomic, strong) NSString *icon3;
@property(nonatomic, copy) NSString *url;

+(instancetype)knowTableDataWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
