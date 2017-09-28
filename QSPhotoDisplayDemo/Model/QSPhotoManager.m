//
//  QSPhotoManager.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "QSPhotoManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "QSPhotoDisplayMacro.h"
#import "QSAlbumModel.h"
#import "QSExifModel.h"
#import "NSString+QS_Extension.h"

@interface QSPhotoManager () {
    CGSize _thumbnailSize;
    CGFloat _screenWidth;
    CGFloat _screenScale;
}

@end

@implementation QSPhotoManager

#pragma mark - Get Instance

+ (instancetype)manager {
    static QSPhotoManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QSPhotoManager alloc] init];
        [manager p_configScreenScale];
    });
    return manager;
}

#pragma mark - Get Authorization

+ (NSInteger)authorizationStatus {
    return [PHPhotoLibrary authorizationStatus];
}

- (BOOL)hasAuthorized {
    NSInteger status = [self.class authorizationStatus];
    return status;
}

- (void)requestAuthorizationWithCompletion:(void (^)(void))completion {
    void (^callCompletionBlock)(void) = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            callCompletionBlock();
        }];
    });
}

#pragma mark - Get Albums

- (void)getCameraRollAlbumWithCompletion:(void (^)(QSAlbumModel *model))completion{
    __block QSAlbumModel *model;
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!self.sortAscendingByModificationDate) {
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:self.sortAscendingByModificationDate]];
    }
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
        if ([self p_isCameraRollAlbum:collection]) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            model = [self p_albumModelWithResult:fetchResult name:collection.localizedTitle isCameraRoll:YES];
            if (completion) completion(model);
            break;
        }
    }
}

- (void)getAllAlbumsWithCompletion:(void (^)(NSArray<QSAlbumModel *> *models))completion {
    NSMutableArray *albumsArray = [NSMutableArray array];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    if (!self.sortAscendingByModificationDate) {
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:self.sortAscendingByModificationDate]];
    }
    
    PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    PHFetchResult *smartAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
    NSArray *allAlbums = @[myPhotoStreamAlbum, smartAlbum, topLevelUserCollections, syncedAlbums, sharedAlbums];
    for (PHFetchResult *fetchResult in allAlbums) {
        for (PHAssetCollection *collection in fetchResult) {
            if (![collection isKindOfClass:[PHAssetCollection class]]) {
                continue;
            }
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            if (result.count < 1) {
                continue;
            }
            if ([collection.localizedTitle qs_containsString:@"Hidden"] || [collection.localizedTitle isEqualToString:@"已隐藏"]) {
                continue;
            }
            if ([self p_isCameraRollAlbum:collection]) {
                [albumsArray insertObject:[self p_albumModelWithResult:result name:collection.localizedTitle isCameraRoll:YES] atIndex:0];
            } else {
                [albumsArray addObject:[self p_albumModelWithResult:result name:collection.localizedTitle isCameraRoll:NO]];
            }
        }
    }
    if (completion && albumsArray.count > 0) {
        completion(albumsArray);
    }
}

#pragma mark - Get Assets

- (void)getAssetsFromFetchResult:(PHFetchResult *)fetchResult completion:(void (^)(NSArray<QSAssetModel *> *))completion {
    NSMutableArray *assetsArray = [NSMutableArray array];
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSAssetModel *model = [self p_assetModelWithAsset:obj];
        if (model) {
            [assetsArray addObject:model];
        }
    }];
    if (completion) {
        completion(assetsArray);
    }
}
/// Get asset at index
- (void)getAssetFromFetchResult:(PHFetchResult *)fetchResult atIndex:(NSInteger)index completion:(void (^)(QSAssetModel *))completion {
    PHAsset *asset;
    @try {
        asset = fetchResult[index];
    }
    @catch(NSException *e) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    QSAssetModel *model = [self p_assetModelWithAsset:asset];
    if (completion) {
        completion(model);
    }
}

#pragma mark - Get Photo

/// Get photo 获得照片本身
- (int32_t)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *, NSDictionary *, BOOL isDegraded))completion {
    CGFloat fullScreenWidth = _screenWidth;
    if (fullScreenWidth > _photoPreviewMaxWidth) {
        fullScreenWidth = _photoPreviewMaxWidth;
    }
    return [self getPhotoWithAsset:asset photoWidth:fullScreenWidth completion:completion progressHandler:nil networkAccessAllowed:YES];
}

- (int32_t)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    return [self getPhotoWithAsset:asset photoWidth:photoWidth completion:completion progressHandler:nil networkAccessAllowed:YES];
}

- (int32_t)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    CGFloat fullScreenWidth = _screenWidth;
    if (fullScreenWidth > _photoPreviewMaxWidth) {
        fullScreenWidth = _photoPreviewMaxWidth;
    }
    return [self getPhotoWithAsset:asset photoWidth:fullScreenWidth completion:completion progressHandler:progressHandler networkAccessAllowed:networkAccessAllowed];
}

- (int32_t)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    CGSize imageSize;
    if (photoWidth < _screenWidth && photoWidth < _photoPreviewMaxWidth) {
        imageSize = _thumbnailSize;
    } else {
        CGFloat aspectRatio = asset.pixelWidth / (CGFloat)asset.pixelHeight;
        CGFloat pixelWidth = photoWidth * _screenScale * 1.5;
        // 超宽图片
        if (aspectRatio > 1.8) {
            pixelWidth = pixelWidth * aspectRatio;
        }
        // 超高图片
        if (aspectRatio < 0.2) {
            pixelWidth = pixelWidth * 0.5;
        }
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        imageSize = CGSizeMake(pixelWidth, pixelHeight);
    }
    
    __block UIImage *image;
    //
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            image = result;
        }
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            result = [self p_fixOrientation:result];
            if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        }
        // Download image from iCloud 
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result && networkAccessAllowed) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressHandler) {
                        progressHandler(progress, error, stop, info);
                    }
                });
            };
            options.networkAccessAllowed = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                resultImage = [self p_scaleImage:resultImage toSize:imageSize];
                if (!resultImage) {
                    resultImage = image;
                }
                resultImage = [self p_fixOrientation:resultImage];
                if (completion) completion(resultImage,info,NO);
            }];
        }
    }];
    return imageRequestID;
    return 0;
}

/// Get postImage / 获取封面图
- (void)getPostImageWithAlbumModel:(QSAlbumModel *)model completion:(void (^)(UIImage *))completion {
    PHAsset *asset = [model.fetchResult lastObject];
    if (!self.sortAscendingByModificationDate) {
        asset = [model.fetchResult firstObject];
    }
    [[QSPhotoManager manager] getPhotoWithAsset:asset photoWidth:80 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (completion) completion(photo);
    }];
}

/// Get Original Photo
- (int32_t)getOriginalPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion {
    return [self getOriginalPhotoWithAsset:asset newCompletion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (completion) {
            completion(photo,info);
        }
    }];
}

- (int32_t)getOriginalPhotoWithAsset:(PHAsset *)asset newCompletion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.networkAccessAllowed = YES;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage *result, NSDictionary *info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            result = [self p_fixOrientation:result];
            BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (completion) completion(result,info,isDegraded);
        }
    }];
    return imageRequestID;
}

- (int32_t)getOriginalPhotoDataWithAsset:(PHAsset *)asset completion:(void (^)(NSData *data,NSDictionary *info,BOOL isDegraded))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    int32_t imageRequestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && imageData) {
            if (completion) {
                completion(imageData,info,NO);
            }
        }
    }];
    return imageRequestID;
}

#pragma mark - Get Exif Info

- (void)getExifModelWithAsset:(PHAsset *)asset completion:(void (^)(QSExifModel *exifModel)) completion{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        CGImageSourceRef cImageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
        NSDictionary *dict =  (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(cImageSource, 0, NULL));
        NSMutableDictionary *exifInfo = [NSMutableDictionary dictionaryWithDictionary:dict];
        QSExifModel *model = [QSExifModel modelWithExifInfo:exifInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(model);
            }
        });
    }];
}

#pragma mark - Get Asset Type

- (QSAssetType)getAssetType:(PHAsset *)asset {
    QSAssetType type = QSAssetTypePhoto;
    PHAsset *phAsset = (PHAsset *)asset;
    if (phAsset.mediaType == PHAssetMediaTypeVideo) {
        type = QSAssetTypeVideo;
    } else if (phAsset.mediaType == PHAssetMediaTypeAudio) {
        type = QSAssetTypeAudio;
    } else if (phAsset.mediaType == PHAssetMediaTypeImage) {
        if ([[phAsset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            type = QSAssetTypePhotoGif;
        }
    }
    return type;
}

#pragma mark - Private Functions

- (BOOL)p_isCameraRollAlbum:(PHAssetCollection *)assetCollection {
    return assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
}

- (QSAlbumModel *)p_albumModelWithResult:(PHFetchResult *)fetchResult name:(NSString *)name isCameraRoll:(BOOL)isCameraRoll {
    QSAlbumModel *model = [[QSAlbumModel alloc] init];
    model.fetchResult = fetchResult;
    model.name = [self p_transformAblumTitle:name];
    model.isCameraRoll = isCameraRoll;
    model.count = fetchResult.count;
    return model;
}

- (QSAssetModel *)p_assetModelWithAsset:(PHAsset *)asset {
    QSAssetModel *model;
    QSAssetType type = [self getAssetType:asset];
    NSString *timeLength = type == QSAssetTypeVideo ? [NSString stringWithFormat:@"%0.0f",asset.duration] : @"";
    timeLength = [self p_getNewTimeFromDurationSecond:timeLength.integerValue];
    
    model = [QSAssetModel modelWithAsset:asset type:type timeLength:timeLength];
    return model;
}

- (NSString *)p_getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"0:0%zd",duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"0:%zd",duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}

- (void)p_configScreenScale {
    _screenScale = 2.0;
    if (ScreenWidth > 700) {
        _screenScale = 1.5;
    }
}

/// 修正图片转向
- (UIImage *)p_fixOrientation:(UIImage *)aImage {
    if (!self.shouldFixOrientation) return aImage;
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)p_scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
}

- (ALAssetOrientation)p_orientationFromImage:(UIImage *)image {
    NSInteger orientation = image.imageOrientation;
    return orientation;
}

- (NSString *)p_transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    } else if ([title isEqualToString:@"Panoramas"]) {
        return @"全景照片";
    }
    return title;
}

#pragma mark - Setter && Getter

- (void)setPhotoWidth:(CGFloat)photoWidth {
    _photoWidth = photoWidth;
    _screenWidth = photoWidth/2;
}

- (void)setColumnNumber:(NSInteger)columnNumber {
    _columnNumber = columnNumber;
    CGFloat margin = 4;
    CGFloat itemWH = (_screenWidth - 2 * margin - 4) / columnNumber - margin;
    _thumbnailSize = CGSizeMake(itemWH * _screenScale, itemWH * _screenScale);
}

@end
