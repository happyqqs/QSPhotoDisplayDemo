//
//  QSPhotoManager.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "QSAssetModel.h"

@class QSAlbumModel, QSExifModel;

@interface QSPhotoManager : NSObject

@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;
@property (nonatomic, assign) CGFloat photoWidth;
@property (nonatomic, assign) BOOL shouldFixOrientation;
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;
@property (nonatomic, assign) NSInteger columnNumber;

+ (instancetype)manager;

- (BOOL)hasAuthorized;
+ (NSInteger)authorizationStatus;
- (void)requestAuthorizationWithCompletion:(void (^)(void))completion;

#pragma mark - Get Albums
- (void)getCameraRollAlbumWithCompletion:(void (^)(QSAlbumModel *model))completion;
- (void)getAllAlbumsWithCompletion:(void (^)(NSArray<QSAlbumModel *> *models))completion;

#pragma mark - Get Assets
- (void)getAssetFromFetchResult:(PHFetchResult *)fetchResult atIndex:(NSInteger)index completion:(void (^)(QSAssetModel *model))completion;
- (void)getAssetsFromFetchResult:(PHFetchResult *)fetchResult completion:(void (^)(NSArray<QSAssetModel *> *models))completion;
- (QSAssetType)getAssetType:(PHAsset *)asset;

#pragma mark - Get Photo
- (void)getPostImageWithAlbumModel:(QSAlbumModel *)model completion:(void (^)(UIImage *))completion;
- (int32_t)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
- (int32_t)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
- (int32_t)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;
- (int32_t)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

#pragma mark - Get Full Image
/// 如果info[PHImageResultIsDegradedKey] 为 YES，则表明当前返回的是缩略图，否则是原图。
- (int32_t)getOriginalPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion;
- (int32_t)getOriginalPhotoWithAsset:(PHAsset *)asset newCompletion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
- (int32_t)getOriginalPhotoDataWithAsset:(PHAsset *)asset completion:(void (^)(NSData *data,NSDictionary *info,BOOL isDegraded))completion;

#pragma mark - Get Exif
- (void)getExifModelWithAsset:(PHAsset *)asset completion:(void (^)(QSExifModel *exifModel)) completion;

@end
