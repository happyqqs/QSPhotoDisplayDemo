//
//  QSExifModel.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/27.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QSExifTiffModel : NSObject

@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *make;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *software;
@property (nonatomic, assign) NSUInteger orientation;
@property (nonatomic, assign) NSUInteger titleLength;
@property (nonatomic, assign) NSUInteger titleWidth;
@property (nonatomic, assign) NSUInteger xResolution;
@property (nonatomic, assign) NSUInteger yResolution;
@property (nonatomic, assign) NSUInteger resolutionUnit;

@end

@interface QSExifGPSModel : NSObject

@property (nonatomic, copy) NSString *altitude;
@property (nonatomic, copy) NSString *altitudeRef;
@property (nonatomic, copy) NSString *dateStamp;
@property (nonatomic, copy) NSString *destBearing;
@property (nonatomic, copy) NSString *destBearingRef;
@property (nonatomic, copy) NSString *hPositioningError;
@property (nonatomic, copy) NSString *imgDirection;
@property (nonatomic, copy) NSString *imgDirectionRef;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *latitudeRef;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *longitudeRef;
@property (nonatomic, copy) NSString *speed;
@property (nonatomic, copy) NSString *speedRef;
@property (nonatomic, copy) NSString *timeStamp;

@end

@interface QSExifMakerAppleModel : NSObject


@end


@interface QSExifExifModel : NSObject

@property (nonatomic, copy) NSString *apertureValue;
@property (nonatomic, copy) NSString *brightnessValue;
@property (nonatomic, assign) NSInteger colorSpace;
@property (nonatomic, copy) NSArray *componentsConfiguration;
@property (nonatomic, assign) NSInteger customRendered;
@property (nonatomic, copy) NSString *dateTimeDigitized;
@property (nonatomic, copy) NSString *dateTimeOriginal;
@property (nonatomic, strong) NSNumber *digitalZoomRatio;
@property (nonatomic, copy) NSArray *exifVersion;
@property (nonatomic, strong) NSNumber *exposureBiasValue;
@property (nonatomic, strong) NSNumber *exposureMode;
@property (nonatomic, strong) NSNumber *exposureProgram;
@property (nonatomic, strong) NSNumber *exposureTime;
@property (nonatomic, strong) NSNumber *fNumber;
@property (nonatomic, strong) NSNumber *flash;
@property (nonatomic, copy) NSArray *flashPixVersion;
@property (nonatomic, copy) NSString *focalLenIn35mmFilm;
@property (nonatomic, strong) NSNumber *focalLength;
@property (nonatomic, copy) NSArray *iSOSpeedRatings;
@property (nonatomic, copy) NSString *lensMake;
@property (nonatomic, copy) NSString *lensModel;
@property (nonatomic, strong) NSNumber *lightSource;
@property (nonatomic, strong) NSNumber *meteringMode;
@property (nonatomic, strong) NSNumber *pixelXDimension;
@property (nonatomic, strong) NSNumber *pixelYDimension;
@property (nonatomic, strong) NSNumber *sceneCaptureType;
@property (nonatomic, copy) NSString *sceneType;
@property (nonatomic, copy) NSString *sensingMethod;
@property (nonatomic, copy) NSString *shutterSpeedValue;
@property (nonatomic, copy) NSString *subjectArea;
@property (nonatomic, copy) NSString *subsecTimeDigitized;
@property (nonatomic, copy) NSString *subsecTimeOriginal;
@property (nonatomic, strong) NSNumber *whiteBalance;

@end

@interface QSExifModel : NSObject

@property (nonatomic, copy) NSString *colorModel;
@property (nonatomic, copy) NSString *profileName;
@property (nonatomic, assign) NSUInteger dPIHeight;
@property (nonatomic, assign) NSUInteger dPIWidth;
@property (nonatomic, assign) NSUInteger orientation;
@property (nonatomic, assign) NSUInteger pixelHeight;
@property (nonatomic, assign) NSUInteger pixelWidth;
@property (nonatomic, assign) NSUInteger depth;
@property (nonatomic, strong) QSExifGPSModel *gps;
@property (nonatomic, strong) QSExifTiffModel *tiff;
@property (nonatomic, strong) QSExifExifModel *exif;
@property (nonatomic, strong) QSExifMakerAppleModel *makerApple;

+ (instancetype)modelWithExifInfo:(NSDictionary *)exifInfo;

@end


