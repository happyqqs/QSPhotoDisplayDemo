//
//  QSAlbumsViewController.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "QSAlbumsDisplayViewController.h"
#import "QSPhotosDisplayViewController.h"
#import "QSPhotoManager.h"
#import "QSAlbumModel.h"
#import "QSAlbumCell.h"

static NSString *albumCellReuseIdentifier = @"SAlbumCell";
static const NSInteger defaultColumnNumber = 4;

@interface QSAlbumsDisplayViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *_albumsTableView;
}
@property (nonatomic, strong) NSMutableArray *albumsArray;

@end

@implementation QSAlbumsDisplayViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"相簿";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self p_configTableView];
}

#pragma mark - Private Functions

- (void)p_configTableView {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[QSPhotoManager manager] getAllAlbumsWithCompletion:^(NSArray<QSAlbumModel *> *models) {
            _albumsArray = [NSMutableArray arrayWithArray:models];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!_albumsTableView) {
                    _albumsTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
                    _albumsTableView.rowHeight = 70;
                    _albumsTableView.tableFooterView = [[UIView alloc] init];
                    _albumsTableView.dataSource = self;
                    _albumsTableView.delegate = self;
                    [_albumsTableView registerClass:[QSAlbumCell class] forCellReuseIdentifier:albumCellReuseIdentifier];
                    [self.view addSubview:_albumsTableView];
                }
                [_albumsTableView reloadData];
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

- (NSInteger)columnNumber {
    if (_columnNumber == 0) {
        return defaultColumnNumber;
    }
    return _columnNumber;
}

@end
