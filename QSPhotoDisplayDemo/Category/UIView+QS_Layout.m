//
//  UIView+QS_Layout.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "UIView+QS_Layout.h"

@implementation UIView (QS_Layout)

- (void)setQs_x:(CGFloat)qs_x {
    CGRect rect = self.frame;
    rect.origin.x = qs_x;
    self.frame = rect;
}
- (CGFloat)qs_x {
    return self.frame.origin.x;
}

- (void)setQs_y:(CGFloat)qs_y {
    CGRect rect = self.frame;
    rect.origin.y = qs_y;
    self.frame = rect;
}
- (CGFloat)qs_y {
    return self.frame.origin.y;
}

- (CGFloat)qs_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setQs_right:(CGFloat)qs_right {
    CGRect frame = self.frame;
    frame.origin.x = qs_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)qs_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setQs_bottom:(CGFloat)qs_bottom {
    CGRect frame = self.frame;
    frame.origin.y = qs_bottom - frame.size.height;
    self.frame = frame;
}

- (void)setQs_height:(CGFloat)qs_height {
    CGRect rect = self.frame;
    rect.size.height = qs_height;
    self.frame = rect;
}
- (CGFloat)qs_height {
    return self.frame.size.height;
}


- (void)setQs_width:(CGFloat)qs_width {
    CGRect rect = self.frame;
    rect.size.width = qs_width;
    self.frame = rect;
}
- (CGFloat)qs_width {
    return self.frame.size.width;
}

- (CGFloat)qs_centerX {
    return self.center.x;
}

- (void)setQs_centerX:(CGFloat)qs_centerX {
    CGPoint center = self.center;
    center.x = qs_centerX;
    self.center = center;
}

- (CGFloat)qs_centerY {
    return self.center.y;
}

- (void)setQs_centerY:(CGFloat)qs_centerY {
    CGPoint center = self.center;
    center.y = qs_centerY;
    self.center = center;
}

- (CGSize)qs_size {
    return self.frame.size;
}

- (void)setQs_size:(CGSize)qs_size {
    CGRect rect = self.frame;
    rect.size = qs_size;
    self.frame = rect;
}

- (CGPoint)qs_origin {
    return self.frame.origin;
}

- (void)setQs_origin:(CGPoint)qs_origin {
    CGRect rect = self.frame;
    rect.origin = qs_origin;
    self.frame = rect;
}

@end
