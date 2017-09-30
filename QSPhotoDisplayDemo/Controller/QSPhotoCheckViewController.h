//
//  QSPhotoCheckViewController.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/27.
//  Copyright © 2017年 申倩倩. All rights reserved.
//  展示单张照片详情

#import <UIKit/UIKit.h>
@class QSAssetModel;
@interface QSPhotoCheckViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<QSAssetModel *> *assetModels;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger currentIndex;

@end
