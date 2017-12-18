//
//  NSObject+Swizzle.m
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











#pragma mark ----------------------- NSArray -----------------------
@implementation NSArray (Safe)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(initWithObjects_safe:count:) tarClass:@"__NSPlaceholderArray" tarSel:@selector(initWithObjects:count:)];
        [self swizzleMethod:@selector(objectAtIndex_safe:) tarClass:@"__NSArrayI" tarSel:@selector(objectAtIndex:)];
        [self swizzleMethod:@selector(arrayByAddingObject_safe:) tarClass:@"__NSArrayI" tarSel:@selector(arrayByAddingObject:)];
    });
}

- (instancetype)initWithObjects_safe:(id *)objects count:(NSUInteger)cnt{
    NSUInteger newCnt=0;
    for (NSUInteger i=0; i<cnt; i++) {
        if (!objects[i]) {
            NSAssertTip(@"数组初始化错误");
            break;
        }
        newCnt++;
    }
    self = [self initWithObjects_safe:objects count:newCnt];
    return self;
}

- (id)objectAtIndex_safe:(NSUInteger)index{
    if (index>=self.count) {
        NSAssertTip(@"数组越界");
        return nil;
    }
    return [self objectAtIndex_safe:index];
}

- (NSArray *)arrayByAddingObject_safe:(id)anObject {
    if (!anObject) {
        NSAssertTip(@"新增的对象错误");
        return self;
    }
    return [self arrayByAddingObject_safe:anObject];
}

@end














#pragma mark ----------------------- NSMutableArray -----------------------
@implementation NSMutableArray (Safe)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(objectAtIndex_safe:) tarClass:@"__NSArrayM" tarSel:@selector(objectAtIndex:)];
        [self swizzleMethod:@selector(addObject_safe:) tarClass:@"__NSArrayM" tarSel:@selector(addObject:)];
        [self swizzleMethod:@selector(insertObject_safe:atIndex:) tarClass:@"__NSArrayM" tarSel:@selector(insertObject:atIndex:)];
        [self swizzleMethod:@selector(removeObjectAtIndex_safe:) tarClass:@"__NSArrayM" tarSel:@selector(removeObjectAtIndex:)];
        [self swizzleMethod:@selector(replaceObjectAtIndex_safe:withObject:) tarClass:@"__NSArrayM" tarSel:@selector(replaceObjectAtIndex:withObject:)];
    });
}

- (id)objectAtIndex_safe:(NSUInteger)index{
    if (index >= self.count) {
        NSAssertTip(@"数组越界");
        return nil;
    }
    return [self objectAtIndex_safe:index];
}

- (void)addObject_safe:(id)anObject {
    if (!anObject) {
        NSAssertTip(@"新增的对象为nil");
        return;
    }
    [self addObject_safe:anObject];
}

- (void)insertObject_safe:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count || !anObject) {
        NSAssertTip(@"数组插入错误");
        return;
    }
    [self insertObject_safe:anObject atIndex:index];
}

- (void)removeObjectAtIndex_safe:(NSUInteger)index {
    if (index >= self.count) {
        NSAssertTip(@"数组移除错误");
        return;
    }
    return [self removeObjectAtIndex_safe:index];
}

- (void)replaceObjectAtIndex_safe:(NSUInteger)index withObject:(id)anObject {
    if (index >= self.count || !anObject) {
        NSAssertTip(@"数组替换错误");
        return;
    }
    [self replaceObjectAtIndex_safe:index withObject:anObject];
}
@end;













#pragma mark ----------------------- NSDictionary -----------------------
@implementation NSDictionary (Safe)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(initWithObjects_safe:forKeys:count:) tarClass:@"__NSPlaceholderDictionary" tarSel:@selector(initWithObjects:forKeys:count:)];
    });
}

-(instancetype)initWithObjects_safe:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)cnt {
    NSUInteger newCnt = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (!(keys[i] && objects[i])) {
            NSAssertTip(@"字典初始化错误");
            break;
        }
        newCnt++;
    }
    self = [self initWithObjects_safe:objects forKeys:keys count:newCnt];
    return self;
}
@end




#pragma mark ----------------------- NSMutableDictionary -----------------------
@implementation NSMutableDictionary (Safe)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(removeObjectForKey_safe:) tarClass:@"__NSDictionaryM" tarSel:@selector(removeObjectForKey:)];
        [self swizzleMethod:@selector(setObject_safe:forKey:) tarClass:@"__NSDictionaryM" tarSel:@selector(setObject:forKey:)];
    });
}

- (void)removeObjectForKey_safe:(id)aKey {
    if (!aKey) {
        NSAssertTip(@"字典移除错误");
        return;
    }
    [self removeObjectForKey_safe:aKey];
}

- (void)setObject_safe:(id)anObject forKey:(id <NSCopying>)aKey {
    if (!anObject||!aKey) {
        NSAssertTip(@"字典设置出错");
        return;
    }
    [self setObject_safe:anObject forKey:aKey];
}
@end













#pragma mark ----------------------- NSString -----------------------
@implementation NSString (Safe)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(characterAtIndex_safe:) tarClass:@"__NSCFString" tarSel:@selector(characterAtIndex:)];
        [self swizzleMethod:@selector(substringWithRange_safe:) tarClass:@"__NSCFString" tarSel:@selector(substringWithRange:)];
    });
}
- (unichar)characterAtIndex_safe:(NSUInteger)index {
    if (index >= self.length) {
        NSAssertTip(@"字符越界");
        return 0;
    }
    return [self characterAtIndex_safe:index];
}

- (NSString *)substringWithRange_safe:(NSRange)range {
    if (range.location + range.length > self.length) {
        NSAssertTip(@"字符串截取错误");
        return @"";
    }
    return [self substringWithRange_safe:range];
}
@end












#if __has_feature(objc_arc)
#define AUTORELEASE(exp) exp
#else
#define AUTORELEASE(exp) [exp autorelease]
#endif
#pragma mark ----------------------- NSMutableString -----------------------
@implementation NSMutableString (Safe)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(appendString_safe:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendString:)];
        [self swizzleMethod:@selector(appendFormat_safe:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendFormat:)];
        [self swizzleMethod:@selector(setString_safe:) tarClass:@"__NSCFConstantString" tarSel:@selector(setString:)];
        [self swizzleMethod:@selector(insertString_safe:atIndex:) tarClass:@"__NSCFConstantString" tarSel:@selector(insertString:atIndex:)];
    });
}

- (void)appendString_safe:(NSString *)aString {
    if (!aString) {
        NSAssertTip(@"字符串拼接错误");
        return;
    }
    [self appendString_safe:aString];
}

- (void)appendFormat_safe:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2) {
    if (!format) {
        NSAssertTip(@"字符串拼接错误");
        return;
    }
    va_list arguments;
    va_start(arguments, format);
    NSString *formatStr = [[NSString alloc]initWithFormat:format arguments:arguments];
    formatStr = AUTORELEASE(formatStr);
    [self appendFormat_safe:@"%@",formatStr];
    va_end(arguments);
}

- (void)setString_safe:(NSString *)aString {
    if (!aString) {
        NSAssertTip(@"字符设置错误");
        return;
    }
    [self setString_safe:aString];
}

- (void)insertString_safe:(NSString *)aString atIndex:(NSUInteger)index {
    if (index > self.length || !aString) {
        NSAssertTip(@"字符插入错误");
        return;
    }
    [self insertString_safe:aString atIndex:index];
}
@end
















#pragma mark ----------------------- NSNumber -----------------------
@implementation NSNumber (Safe)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(isEqualToNumber_safe:) tarClass:@"__NSCFNumber" tarSel:@selector(isEqualToNumber:)];
        [self swizzleMethod:@selector(compare_safe:) tarClass:@"__NSCFNumber" tarSel:@selector(compare:)];
    });
}

- (BOOL)isEqualToNumber_safe:(NSNumber *)number {
    if (!number) {
        return NO;
    }
    return [self isEqualToNumber_safe:number];
}

- (NSComparisonResult)compare_safe:(NSNumber *)number {
    if (!number) {
        return NSOrderedAscending;
    }
    return [self compare_safe:number];
}
@end





