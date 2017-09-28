//
//  NSString+QS_Extension.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/27.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "NSString+QS_Extension.h"
#import "QSPhotoDisplayMacro.h"

@implementation NSString (QS_Extension)

- (BOOL)qs_containsString:(NSString *)string {
    if (iOS8Later) {
        return [self containsString:string];
    } else {
        NSRange range = [self rangeOfString:string];
        return range.location != NSNotFound;
    }
}

@end
