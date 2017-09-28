//
//  QSAlbumModel.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QSAssetModel, PHFetchResult;

@interface QSAlbumModel : NSObject

@property (nonatomic, copy) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) PHFetchResult *fetchResult;             
@property (nonatomic, copy) NSArray<QSAssetModel *> *assetModels;
@property (nonatomic, assign) BOOL isCameraRoll;

@end
