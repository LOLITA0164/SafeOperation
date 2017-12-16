//
//  NSObject+SwizzleMRC.m
//  SafeOperation
//
//  Created by LOLITA on 17/12/16.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#define NSAssertTip(tip) NSAssert(NO, tip)


#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@implementation NSObject (Swizzle)
+ (void)swizzleMethod:(SEL)srcSel tarClass:(NSString *)tarClassName tarSel:(SEL)tarSel{
    if (!srcSel||!tarClassName||!tarSel) {
        return;
    }
    Class srcClass = [self class];
    Class tarClass = NSClassFromString(tarClassName);
    Method srcMethod = class_getInstanceMethod(srcClass,srcSel);
    Method tarMethod = class_getInstanceMethod(tarClass,tarSel);
    method_exchangeImplementations(srcMethod, tarMethod);
}
@end


// fix enter background crash bug when keyboard show.
@implementation NSMutableArray (SafeMRC)
- (id)objectAtIndex_safe:(NSUInteger)index {
    if (index >= self.count) {
        NSAssertTip(@"数组越界");
        return nil;
    }
    return [self objectAtIndex_safe:index];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(objectAtIndex_safe:) tarClass:@"__NSArrayM" tarSel:@selector(objectAtIndex:)];
    });
}
@end
