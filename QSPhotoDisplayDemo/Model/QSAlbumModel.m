//
//  QSAlbumModel.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "QSAlbumModel.h"
#import "QSPhotoManager.h"

@implementation QSAlbumModel

#pragma mark - Setter && Getter
- (void)setFetchResult:(PHFetchResult *)fetchResult {
    _fetchResult = fetchResult;
    [[QSPhotoManager manager] getAssetsFromFetchResult:fetchResult completion:^(NSArray<QSAssetModel *> *models) {
        _assetModels = models;
        _count = models.count;
    }];
}
@end
