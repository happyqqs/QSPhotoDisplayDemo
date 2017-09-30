//
//  QSPhotoDisplayViewController.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//  展示照片列表

#import <UIKit/UIKit.h>

@class QSAlbumModel;
@interface QSPhotosDisplayViewController : UIViewController

@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, strong) QSAlbumModel *albumModel;
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

@end
