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

#pragma mark - Get Instance

+ (instancetype)manager; //获取单例

#pragma mark - Get Authorization
/// Return YES if Authorized 返回YES如果得到了授权
- (BOOL)hasAuthorized;
+ (NSInteger)authorizationStatus;
- (void)requestAuthorizationWithCompletion:(void (^)(void))completion;

#pragma mark - Get Albums
/// Get Album 获得相册/相册数组
- (void)getCameraRollAlbumWithCompletion:(void (^)(QSAlbumModel *model))completion;
- (void)getAllAlbumsWithCompletion:(void (^)(NSArray<QSAlbumModel *> *models))completion;

#pragma mark - Get Assets
/// Get Assets 获得Asset数组
- (void)getAssetFromFetchResult:(PHFetchResult *)fetchResult atIndex:(NSInteger)index completion:(void (^)(QSAssetModel *model))completion;
- (void)getAssetsFromFetchResult:(PHFetchResult *)fetchResult completion:(void (^)(NSArray<QSAssetModel *> *models))completion;

#pragma mark - Get Photo
/// Get photo 获得照片
- (void)getPostImageWithAlbumModel:(QSAlbumModel *)model completion:(void (^)(UIImage *))completion;
- (int32_t)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
- (int32_t)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
- (int32_t)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;
- (int32_t)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

#pragma mark - Get Full Image
/// Get full Image 获取原图
/// 如果info[PHImageResultIsDegradedKey] 为 YES，则表明当前返回的是缩略图，否则是原图。
- (void)getOriginalPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
- (void)getOriginalPhotoDataWithAsset:(PHAsset *)asset completion:(void (^)(NSData *data,NSDictionary *info,BOOL isDegraded))completion;
#pragma mark - Get Asset Type
/// 获取asset的资源类型
- (QSAssetType)getAssetType:(PHAsset *)asset;

#pragma mark - Get Exif
- (void)getExifModelWithAsset:(PHAsset *)asset completion:(void (^)(QSExifModel *exifModel)) completion;

@end
