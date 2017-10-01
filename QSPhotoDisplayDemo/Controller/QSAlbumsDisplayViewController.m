//
//  QSAlbumsViewController.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//  展示相簿列表

#import "QSAlbumsDisplayViewController.h"
#import "QSPhotosDisplayViewController.h"
#import "QSPhotoManager.h"
#import "QSAlbumModel.h"
#import "QSAlbumCell.h"
#import "UIView+QS_Layout.h"

static NSString *albumCellReuseIdentifier = @"SAlbumCell";
static const NSInteger defaultColumnNumber = 4;

@interface QSAlbumsDisplayViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *albumsTableView;
@property (nonatomic, strong) NSMutableArray *albumsArray;

@end

@implementation QSAlbumsDisplayViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"相簿";
    [self.view addSubview:self.albumsTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self p_fetchAllAlbums];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat top = 0;
    CGFloat tableViewHeight = 0;
    CGFloat naviBarHeight = self.navigationController.navigationBar.qs_height;
    BOOL isStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
    if (self.navigationController.navigationBar.isTranslucent) {
        top = naviBarHeight;
        if (!isStatusBarHidden) {
            top += 20;
        }
        tableViewHeight = self.view.qs_height - top;
    } else {
        tableViewHeight = self.view.qs_height;
    }
    _albumsTableView.frame = CGRectMake(0, top, self.view.qs_width, tableViewHeight);
}

#pragma mark - Private Functions

- (void)p_fetchAllAlbums {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 获取所有相簿
        [[QSPhotoManager manager] getAllAlbumsWithCompletion:^(NSArray<QSAlbumModel *> *models) {
            _albumsArray = [NSMutableArray arrayWithArray:models];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.albumsTableView reloadData];
            });
        }];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QSAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:albumCellReuseIdentifier];
    cell.model = self.albumsArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QSPhotosDisplayViewController *photoDisplayVC = [[QSPhotosDisplayViewController alloc] init];
    photoDisplayVC.columnNumber = self.columnNumber;
    photoDisplayVC.albumModel = _albumsArray[indexPath.row];
    [self.navigationController showViewController:photoDisplayVC sender:nil];
}

#pragma mark - Setter && Getter

- (NSInteger)columnNumber {
    if (_columnNumber == 0) {
        return defaultColumnNumber;
    }
    return _columnNumber;
}

- (UITableView *)albumsTableView {
    if (_albumsTableView == nil) {
        _albumsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _albumsTableView.rowHeight = 70;
        _albumsTableView.tableFooterView = [[UIView alloc] init];
        _albumsTableView.dataSource = self;
        _albumsTableView.delegate = self;
        [_albumsTableView registerClass:[QSAlbumCell class] forCellReuseIdentifier:albumCellReuseIdentifier];
    }
    return _albumsTableView;
}

@end
