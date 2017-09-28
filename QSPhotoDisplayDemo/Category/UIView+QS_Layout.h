//
//  UIView+QS_Layout.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QS_Layout)

@property (nonatomic, assign)CGFloat qs_height;
@property (nonatomic, assign)CGFloat qs_width;
@property (nonatomic, assign)CGFloat qs_x;
@property (nonatomic, assign)CGFloat qs_y;
@property (nonatomic, assign) CGFloat qs_right;
@property (nonatomic, assign) CGFloat qs_bottom;
@property (nonatomic, assign)CGFloat qs_centerX;
@property (nonatomic, assign)CGFloat qs_centerY;
@property (nonatomic, assign)CGPoint qs_origin;
@property (nonatomic, assign)CGSize qs_size;

@end
