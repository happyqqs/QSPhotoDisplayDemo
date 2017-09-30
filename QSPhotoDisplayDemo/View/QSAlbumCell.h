//
//  QSAlbumCell.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/26.
//  Copyright © 2017年 申倩倩. All rights reserved.
//  相簿列表cell

#import <UIKit/UIKit.h>

@class QSAlbumModel;

@interface QSAlbumCell : UITableViewCell

@property (nonatomic, strong) QSAlbumModel *model;

@end
