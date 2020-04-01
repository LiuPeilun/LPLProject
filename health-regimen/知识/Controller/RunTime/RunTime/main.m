//
//  main.m
//  RunTime
//
//  Created by 312 on 2019/12/5.
//  Copyright © 2019 Lun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

#import <objc/message.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //Person *p = [[Person alloc];
        Person *p = objc_msgSend(objc_getClass("Person"), sel_registerName("alloc"));
        
        //p = [p init];
        p = objc_msgSend(p, sel_registerName("init"));
        
        //[p eat];
        objc_msgSend(p, @selector(eat));
        
        //[p run:20];
        objc_msgSend(p, @selector(run:), 20);
    }
    return 0;
}
