//
//  QSPhotoDisplayViewController.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//  展示照片列表

#import "QSPhotosDisplayViewController.h"
#import "QSPhotoCheckViewController.h"
#import "QSPhotoDisplayMacro.h"
#import "QSPhotoManager.h"
#import "QSAlbumModel.h"
#import "QSAssetModel.h"
#import "QSPhotoDisplayCell.h"
#import "UIView+QS_Layout.h"

static NSString *photoDisplayCellReuseIdentifier = @"QSPhotoDisplayCell";
static const CGFloat collectionViewMargin = 2;

@interface QSPhotosDisplayViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> 

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray<QSAssetModel *> *assetModels;
@property (nonatomic, assign) BOOL shouldScrollToBottom;
@property (nonatomic, assign) CGSize thumbnailSize;
@property (nonatomic, assign) CGFloat offsetItemCount;

@end

@implementation QSPhotosDisplayViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.albumModel.name;
    _shouldScrollToBottom = YES;
    [self p_fetchAssetModels];
    [self.view addSubview:self.collectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat itemWH = (self.view.qs_width - (self.columnNumber + 1) * collectionViewMargin) / self.columnNumber;
    _collectionView.frame = self.view.frame;
    _layout.itemSize = CGSizeMake(itemWH, itemWH);
    _layout.minimumInteritemSpacing = collectionViewMargin;
    _layout.minimumLineSpacing = collectionViewMargin;
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetY = _offsetItemCount * (_layout.itemSize.height + _layout.minimumLineSpacing);
        [_collectionView setContentOffset:CGPointMake(0, offsetY)];
    }
    [self.collectionView reloadData];
    [self p_scrollCollectionViewToBottom];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.y / (_layout.itemSize.height + _layout.minimumLineSpacing);
}

#pragma mark - Private Functions
// 获取该相簿内资产数据
- (void)p_fetchAssetModels {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (!_sortAscendingByModificationDate && _isFirstAppear && iOS8Later) {
            [[QSPhotoManager manager] getCameraRollAlbumWithCompletion:^(QSAlbumModel *model) {
                _albumModel = model;
                _assetModels = [NSMutableArray arrayWithArray:model.assetModels];
            }];
        } else {
            if (!iOS8Later || _isFirstAppear) {
                [[QSPhotoManager manager] getAssetsFromFetchResult:_albumModel.fetchResult completion:^(NSArray<QSAssetModel *> *models) {
                    _assetModels = [NSMutableArray arrayWithArray:models];
                }];
            } else {
                _assetModels = [NSMutableArray arrayWithArray:_albumModel.assetModels];
            }
        }
    });
    [self.collectionView reloadData];
}
// 滑动到底部
- (void)p_scrollCollectionViewToBottom {
    if (_shouldScrollToBottom && _assetModels.count > 0) {
        NSInteger item = _assetModels.count - 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            _shouldScrollToBottom = NO;
            _collectionView.hidden = NO;
        });
    } else {
        _collectionView.hidden = NO;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _assetModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QSPhotoDisplayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoDisplayCellReuseIdentifier forIndexPath:indexPath];
    cell.assetModel = _assetModels[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
// 点击照片展示大图
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    QSPhotoCheckViewController *photoCheckVC = [[QSPhotoCheckViewController alloc] init];
    photoCheckVC.currentIndex = indexPath.row;
    photoCheckVC.assetModels = _assetModels;
    [self.navigationController showViewController:photoCheckVC sender:nil];
}

#pragma mark - Setter && Getter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:_layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(collectionViewMargin, collectionViewMargin, collectionViewMargin, collectionViewMargin);
        [_collectionView registerClass:[QSPhotoDisplayCell class] forCellWithReuseIdentifier:photoDisplayCellReuseIdentifier];
    }
    return _collectionView;
}

@end
