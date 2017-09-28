//
//  NSObject+QS_DicToModel.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/28.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "NSObject+QS_DicToModel.h"
#import <objc/runtime.h>

@implementation NSObject (QS_DicToModel)
+ (instancetype)qs_initWithDictionary:(NSDictionary *)dic {
    
    id obj = [[self alloc] init];
    unsigned int outCount;
    objc_property_t *arrPropertys = class_copyPropertyList([self class], &outCount);
    
    for (NSInteger i = 0; i < outCount; i ++) {
        objc_property_t property = arrPropertys[i];
        NSMutableString *propertyName = [NSMutableString stringWithUTF8String:property_getName(property)];
        NSString *firstLetter = [[propertyName substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        [propertyName replaceCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
        id propertyValue = dic[propertyName];
        
        if (propertyValue != nil) {
            [obj setValue:propertyValue forKey:propertyName];;
        }
    }
    free(arrPropertys);
    return obj;
}
@end
