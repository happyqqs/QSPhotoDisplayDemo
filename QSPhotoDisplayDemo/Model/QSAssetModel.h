//
//  QSAssetModel.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QSAssetType) {
    QSAssetTypePhoto = 0,
    QSAssetTypeLivePhoto,
    QSAssetTypePhotoGif,
    QSAssetTypeVideo,
    QSAssetTypeAudio
};

@class PHAsset, QSExifModel;

@interface QSAssetModel : NSObject

@property (nonatomic, assign) QSAssetType type;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, copy) NSString *timeLength;
@property (nonatomic, strong) QSExifModel *exifModel;

///Init a photo dataModel With a asset
+ (instancetype)modelWithAsset:(PHAsset *)asset type:(QSAssetType)type;
+ (instancetype)modelWithAsset:(PHAsset *)asset type:(QSAssetType)type timeLength:(NSString *)timeLength;

@end


