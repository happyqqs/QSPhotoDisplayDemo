//
//  QSExifModel.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/27.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "QSExifModel.h"

@implementation QSExifModel

+ (instancetype)modelWithExifInfo:(NSDictionary *)exifInfo {
    NSLog(@"Exif info: %@", exifInfo);
    QSExifModel *model = [[QSExifModel alloc] init];
    
    return model;
}

@end
