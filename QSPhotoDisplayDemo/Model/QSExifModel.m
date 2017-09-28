//
//  QSExifModel.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/27.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "QSExifModel.h"
#import "NSObject+QS_DicToModel.h"

@implementation QSExifGPSModel

@end

@implementation QSExifTiffModel

@end

@implementation QSExifMakerAppleModel

@end

@implementation QSExifExifModel

@end

@implementation QSExifModel

+ (instancetype)modelWithExifInfo:(NSDictionary *)exifInfo {
    NSDictionary *tiff = [exifInfo objectForKey:@"{TIFF}"];
    NSDictionary *gps = [exifInfo objectForKey:@"{GPS}"];
    NSDictionary *makerApple = [exifInfo objectForKey:@"{MakerApple}"];
    NSDictionary *exif = [exifInfo objectForKey:@"{Exif}"];
    QSExifModel *model = [QSExifModel qs_initWithDictionary:exifInfo];
    model.tiff = [QSExifTiffModel qs_initWithDictionary:tiff];
    model.gps = [QSExifGPSModel qs_initWithDictionary:gps];
    model.makerApple = [QSExifMakerAppleModel qs_initWithDictionary:makerApple];
    model.exif = [QSExifExifModel qs_initWithDictionary:exif];
    NSLog(@"Exif info: %@", exifInfo);
    return model;
}

@end
