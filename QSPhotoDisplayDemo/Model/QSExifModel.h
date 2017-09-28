//
//  QSExifModel.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/27.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSExifModel : UIView

@property (nonatomic, copy) NSString *colorModel;
@property (nonatomic, copy) NSString *profileName;
@property (nonatomic, assign) NSUInteger dpiHeight;
@property (nonatomic, assign) NSUInteger dpiWidth;
@property (nonatomic, assign) NSUInteger orientation;
@property (nonatomic, assign) NSUInteger pixelHeight;
@property (nonatomic, assign) NSUInteger pixelWidth;
@property (nonatomic, assign) NSUInteger depth;

+ (instancetype)modelWithExifInfo:(NSDictionary *)exifInfo;

@end
