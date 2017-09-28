//
//  QSAssetModel.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "QSAssetModel.h"

@implementation QSAssetModel

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(QSAssetType)type{
    QSAssetModel *model = [[QSAssetModel alloc] init];
    model.asset = asset;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(QSAssetType)type timeLength:(NSString *)timeLength {
    QSAssetModel *model = [[QSAssetModel alloc] init];
    model.asset = asset;
    model.type = type;
    model.timeLength = timeLength;
    return model;
}

@end


