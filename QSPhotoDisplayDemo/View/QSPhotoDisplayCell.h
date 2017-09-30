//
//  QSPhotoCollectionViewCell.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//  照片列表展示cell

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QSPhotoCellType) {
    QSPhotoCellTypePhoto = 0,
    QSPhotoCellTypeLivePhoto,
    QSPhotoCellTypePhotoGif,
    QSPhotoCellTypeVideo,
    QSPhotoCellTypeAudio,
};

@class QSAssetModel;

@interface QSPhotoDisplayCell : UICollectionViewCell

@property (nonatomic, strong) QSAssetModel *assetModel;
@property (nonatomic, assign) QSPhotoCellType type;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;

@end
