//
//  QSPhotoCheckCell.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/27.
//  Copyright © 2017年 申倩倩. All rights reserved.
//  

#import <UIKit/UIKit.h>

@class QSAssetModel;
@class QSPhotoCheckView;

@interface QSPhotoCheckCell : UICollectionViewCell

@property (nonatomic, strong) QSAssetModel *assetModel;
@property (nonatomic, strong) QSPhotoCheckView *checkView;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);

- (void)configSubviews;
- (void)photoPreviewCollectionViewDidScroll;
- (void)recoverSubviews;

@end


