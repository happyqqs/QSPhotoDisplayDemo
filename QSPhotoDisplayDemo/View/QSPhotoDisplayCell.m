//
//  QSPhotoCollectionViewCell.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "QSPhotoDisplayCell.h"
#import <Photos/Photos.h>
#import "QSPhotoManager.h"
#import "QSAssetModel.h"
#import "UIView+QS_Layout.h"

@interface QSPhotoDisplayCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (weak, nonatomic) UIView *bottomView;
@property (nonatomic, weak) UILabel *timeLength;
@property (nonatomic, weak) UIImageView *videoImgView;
@property (nonatomic, assign) int32_t bigImageRequestID;

@end

@implementation QSPhotoDisplayCell

#pragma mark - setter && getter

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.qs_width, self.qs_height);
    
    
    _bottomView.frame = CGRectMake(0, self.qs_height - 17, self.qs_width, 17);
    _videoImgView.frame = CGRectMake(8, 0, 17, 17);
    _timeLength.frame = CGRectMake(self.videoImgView.qs_right, 0, self.qs_width - self.videoImgView.qs_right - 5, 17);
    
    self.type = (NSInteger)self.assetModel.type;
}

- (void)setAssetModel:(QSAssetModel *)assetModel {
    _assetModel = assetModel;
    self.representedAssetIdentifier = assetModel.asset.localIdentifier;
    int32_t imageRequestID = [[QSPhotoManager manager] getPhotoWithAsset:assetModel.asset photoWidth:self.qs_width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        self.imageView.image = photo;
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    } progressHandler:nil networkAccessAllowed:NO];
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.imageRequestID = imageRequestID;
    self.type = (NSInteger)assetModel.type;
    [self setNeedsLayout];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}


- (UIImageView *)videoImgView {
    if (_videoImgView == nil) {
        UIImageView *videoImgView = [[UIImageView alloc] init];
        //[videoImgView setImage:[UIImage imageNamedFromMyBundle:@"VideoSendIcon"]];
        _videoImgView = videoImgView;
    }
    return _videoImgView;
}

- (UILabel *)timeLength {
    if (_timeLength == nil) {
        UILabel *timeLength = [[UILabel alloc] init];
        timeLength.font = [UIFont boldSystemFontOfSize:11];
        timeLength.textColor = [UIColor whiteColor];
        timeLength.textAlignment = NSTextAlignmentRight;
        [self.bottomView addSubview:timeLength];
        _timeLength = timeLength;
    }
    return _timeLength;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        UIView *bottomView = [[UIView alloc] init];
        static NSInteger rgb = 0;
        bottomView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.8];
        [self.contentView addSubview:bottomView];
        _bottomView = bottomView;
    }
    return _bottomView;
}

@end
