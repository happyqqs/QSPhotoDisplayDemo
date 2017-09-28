//
//  QSPhotoExifInfoViewController.h
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/28.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSExifModel;

@interface QSPhotoExifInfoViewController : UITableViewController

@property (nonatomic, strong) QSExifModel *exifModel;

@end
