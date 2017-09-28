//
//  QSPhotoCheckCell.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/27.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "QSPhotoCheckCell.h"
#import "QSPhotoCheckView.h"
#import "QSAssetModel.h"

@implementation QSPhotoCheckCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self configSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.checkView.frame = self.bounds;
}

#pragma mark - Public Functions

- (void)configSubviews {
    self.checkView = [[QSPhotoCheckView alloc] initWithFrame:self.contentView.frame];
    __weak typeof(self) weakSelf = self;
    [self.checkView setSingleTapGestureBlock:^{
        if (weakSelf.singleTapGestureBlock) {
            weakSelf.singleTapGestureBlock();
        }
    }];
    [self addSubview:self.checkView];
}

- (void)recoverSubviews {
    [_checkView recoverSubviews];
}

- (void)photoPreviewCollectionViewDidScroll {
    
}

#pragma mark - Setter && Getter

- (void)setAssetModel:(QSAssetModel *)assetModel {
    _assetModel = assetModel;
    _checkView.assetModel = assetModel;
}

@end
