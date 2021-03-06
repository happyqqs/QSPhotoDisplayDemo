//
//  QSPhotoCheckView.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/27.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "QSPhotoCheckView.h"
#import "QSPhotoManager.h"
#import "QSAssetModel.h"
#import "UIView+QS_Layout.h"
#import "UIImage+QS_Gif.h"

@interface QSPhotoCheckView ()<UIScrollViewDelegate>

@end

@implementation QSPhotoCheckView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self.imageContainerView addSubview:self.imageView];
    [self.scrollView addSubview:self.imageContainerView];
    [self addSubview:self.scrollView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self addGestureRecognizer:tap2];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(10, 0, self.qs_width - 20, self.qs_height);
    [self recoverSubviews];
}

#pragma mark - Public Functions

- (void)recoverSubviews {
    [_scrollView setZoomScale:1.0 animated:NO];
    [self p_resizeSubviews];
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self p_refreshImageContainerViewCenter];
}

#pragma mark - Private Functions

- (void)p_refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.qs_width > _scrollView.contentSize.width) ? ((_scrollView.qs_width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.qs_height > _scrollView.contentSize.height) ? ((_scrollView.qs_height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)p_resizeSubviews {
    _imageContainerView.qs_origin = CGPointZero;
    _imageContainerView.qs_width = self.scrollView.qs_width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.qs_height / self.scrollView.qs_width) {
        _imageContainerView.qs_height = floor(image.size.height / (image.size.width / self.scrollView.qs_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.qs_width;
        if (height < 1 || isnan(height)) height = self.qs_height;
        height = floor(height);
        _imageContainerView.qs_height = height;
        _imageContainerView.qs_centerY = self.qs_height / 2;
    }
    if (_imageContainerView.qs_height > self.qs_height && _imageContainerView.qs_height - self.qs_height <= 1) {
        _imageContainerView.qs_height = self.qs_height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.qs_height, self.qs_height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.qs_width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.qs_height <= self.qs_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - Setter && Getter

- (void)setAssetModel:(QSAssetModel *)assetModel {
    _assetModel = assetModel;
    [_scrollView setZoomScale:1.0 animated:NO];
    __weak typeof(self) weakSelf = self;
    if (assetModel.type == QSAssetTypePhotoGif) {
        // 先显示缩略图
        [[QSPhotoManager manager] getOriginalPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            weakSelf.imageView.image = photo;
            [weakSelf p_resizeSubviews];
            // 再显示gif动图
            [[QSPhotoManager manager] getOriginalPhotoDataWithAsset:assetModel.asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
                weakSelf.imageView.image = [UIImage qs_animatedGIFWithData:data];
                [weakSelf p_resizeSubviews];
            }];
        }];
    } else {
        self.asset = assetModel.asset;
    }
}

- (void)setAsset:(PHAsset *)asset {
    if (_asset && self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    _asset = asset;
    __weak typeof(self) weakSelf = self;
    
    [[QSPhotoManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (![asset isEqual:_asset]) {
            return;
        }
        weakSelf.imageView.image = photo;
        [weakSelf p_resizeSubviews];
    }];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
    }
    return _scrollView;
}

- (UIView *)imageContainerView {
    if (_imageContainerView == nil) {
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageContainerView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
@end
