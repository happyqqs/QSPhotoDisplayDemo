//
//  QSPhotoCheckView.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/27.
//  Copyright © 2017年 申倩倩. All rights reserved.
//  单张照片详情查看视图

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class QSAssetModel;

@interface QSPhotoCheckView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) QSAssetModel *assetModel;
@property (nonatomic, assign) int32_t imageRequestID;

@property (nonatomic, copy) void (^singleTapGestureBlock)(void);

- (void)recoverSubviews;

@end
