//
//  QSPhotoCheckViewController.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/27.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "QSPhotoCheckViewController.h"
#import "QSPhotoExifInfoViewController.h"
#import "QSPhotoCheckCell.h"
#import "QSPhotoManager.h"
#import "QSAssetModel.h"
#import "QSExifModel.h"
#import "UIView+QS_Layout.h"
#import "QSPhotoDisplayMacro.h"

static NSString *photoCheckCellReuseIdentifier = @"QSPhotoCheckCell";

@interface QSPhotoCheckViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) BOOL isNavBarHidden;
@property (nonatomic, assign) CGFloat offsetItemCount;

@end

@implementation QSPhotoCheckViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [QSPhotoManager manager].shouldFixOrientation = YES;
    [self.view addSubview:self.collectionView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Exif信息" style:UIBarButtonItemStylePlain target:self action:@selector(checkExifInfo)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!QS_isGlobalStatusBarHidden) {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
    if (_currentIndex) {
       [_collectionView setContentOffset:CGPointMake((self.view.qs_width + 20) * _currentIndex, 0) animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!QS_isGlobalStatusBarHidden) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    [QSPhotoManager manager].shouldFixOrientation = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _layout.itemSize = CGSizeMake(self.view.qs_width + 20, self.view.qs_height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, 0, self.view.qs_width + 20, self.view.qs_height);
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetX = _offsetItemCount * _layout.itemSize.width;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.x / _layout.itemSize.width;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _assetModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QSPhotoCheckCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCheckCellReuseIdentifier forIndexPath:indexPath];
    
    cell.assetModel = _assetModels[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [cell setSingleTapGestureBlock:^{
        [weakSelf p_didTapPhotoCheckCell];
    }];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentIndex = indexPath.row;
}

#pragma mark - Private Functions

- (void)p_didTapPhotoCheckCell {
    self.isNavBarHidden = !self.isNavBarHidden;
    [self.navigationController setNavigationBarHidden:self.isNavBarHidden animated:NO];
}

#pragma mark - Button Actions

- (void)checkExifInfo {
    QSPhotoExifInfoViewController *exifInfoVC = [[QSPhotoExifInfoViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    QSAssetModel *assetModel = _assetModels[_currentIndex];
    if (assetModel.exifModel == nil) {
        [[QSPhotoManager manager] getExifModelWithAsset:assetModel.asset completion:^(QSExifModel *exifModel) {
            exifInfoVC.exifModel = exifModel;
            assetModel.exifModel = exifModel;
            [weakSelf.navigationController showViewController:exifInfoVC sender:nil];
        }];
    } else {
        exifInfoVC.exifModel = assetModel.exifModel;
        [self.navigationController showViewController:exifInfoVC sender:nil];
    }
}

#pragma mark - Setter && Getter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:_layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentOffset = CGPointMake(0, 0);
        _collectionView.contentSize = CGSizeMake(self.assetModels.count * (self.view.qs_width + 20), 0);
        [_collectionView registerClass:[QSPhotoCheckCell class] forCellWithReuseIdentifier:photoCheckCellReuseIdentifier];
    }
    return _collectionView;
}

@end
