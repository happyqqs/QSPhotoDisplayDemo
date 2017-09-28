//
//  NSArray+QS_Description.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/28.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "NSArray+QS_Description.h"

@implementation NSArray (QS_Description)

-(NSString *)qs_descriptionWithSeparator:(NSString *)separator {
    if (self == nil) {
        return nil;
    }
    NSMutableString *str = [NSMutableString string];
    NSInteger count = self.count;
    if (count > 0) {
        [str appendString:[self[0] stringValue]];
        for (int i = 1; i < count; i++) {
            [str appendString:separator];
            [str appendString:[self[i] stringValue]];
        }
        return str;
    } else {
        return nil;
    }
}

@end
