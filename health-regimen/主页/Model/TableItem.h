//
//  TableItem.h
//  health-regimen
//
//  Created by home on 2019/11/16.
//  Copyright © 2019 lpl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableItem : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, strong) NSString *icon;

+(instancetype)tableDataWithDict:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
