//
//  NSObject+Property.m
//  runtime字典转模型
//
//  Created by 312 on 2019/12/7.
//  Copyright © 2019 Lun. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/message.h>
#import "User.h"

@implementation NSObject (Property)

+(instancetype)modelWithDict:(NSDictionary *)dict{
    
    id objc = [[self alloc] init];
    
    //runtime模型转数组：根据模型中属性，去字典中取出对应的value给模型属性赋值
    //遍历模型成员变量
    //count：成员变量个数
    int count = 0;
    //返回数组
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    for (int i=0; i<count; i++) {
        //获取成员变量
        Ivar ivar = ivarList[i];
        //获取成员变量名字
        NSString *string = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        //裁剪名字，使和模型成员变量名字一样
        NSString *key = [string substringFromIndex:1];
        
        NSLog(@"%@", key);
        
        // 去字典中查找对应值
        id value = dict[key];
        
        //二级转换：判断下value是否是字典，如果是，字典转换成对应的模型。
        if([value isKindOfClass:[NSDictionary class]]){
            //字典转化为模型 userDict => User模型
            //转换成哪个模型
            //获取成员变量类型
            NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            
            NSLog(@"%@", ivarType);
            
            //整理类型格式
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
            
            NSLog(@"%@", ivarType);
            //获取类
            Class modelClass = NSClassFromString(ivarType);
            value = [modelClass modelWithDict:value];
            
        }
        
        //给模型中属性赋值
        if(value){
            [objc setValue:value forKey:key];
        }
    }
    
    return objc;
}

@end
