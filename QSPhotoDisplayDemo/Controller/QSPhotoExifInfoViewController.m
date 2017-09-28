//
//  QSPhotoExifInfoViewController.m
//  QSPhotoDisplayDemo
//
//  Created by qqs on 2017/9/28.
//  Copyright © 2017年 申倩倩. All rights reserved.
//

#import "QSPhotoExifInfoViewController.h"
#import "QSExifModel.h"
#import "NSArray+QS_Description.h"

@interface QSPhotoExifInfoViewController ()

@property (nonatomic, strong) NSMutableArray<NSArray *> *detailInfo;
@property (nonatomic, strong) NSString *tempString;

@end

@implementation QSPhotoExifInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _detailInfo.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuseIdentifier];
    }
    cell.textLabel.text = _detailInfo[indexPath.row][0];
    cell.detailTextLabel.text = _detailInfo[indexPath.row][1];

    return cell;
}


#pragma mark - Getter && Setter

- (void)setExifModel:(QSExifModel *)exifModel {
    _exifModel = exifModel;
    _detailInfo = [NSMutableArray array];
    self.tempString = exifModel.colorModel;
    [_detailInfo addObject:@[@"颜色模式", _tempString]];
    self.tempString = exifModel.profileName;
    [_detailInfo addObject:@[@"配置文件名称", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.dPIHeight];
    [_detailInfo addObject:@[@"DPI高度", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.dPIWidth];
    [_detailInfo addObject:@[@"DPI宽度", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.pixelHeight];
    [_detailInfo addObject:@[@"像素高度", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.pixelWidth];
    [_detailInfo addObject:@[@"像素宽度", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.depth];
    [_detailInfo addObject:@[@"深度", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.orientation];
    [_detailInfo addObject:@[@"旋转方向", _tempString]];
    
    // Exif
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.exif.apertureValue];
    [_detailInfo addObject:@[@"光圈", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.exif.brightnessValue];
    [_detailInfo addObject:@[@"亮度", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.exif.colorSpace];
    [_detailInfo addObject:@[@"颜色空间", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%@", [exifModel.exif.componentsConfiguration qs_descriptionWithSeparator:@"  "]];
    [_detailInfo addObject:@[@"图像构造", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%ld", (long)exifModel.exif.customRendered];
    [_detailInfo addObject:@[@"自定义图像处理", _tempString]];
    self.tempString = exifModel.exif.dateTimeDigitized;
    [_detailInfo addObject:@[@"数字化时间", _tempString]];
    self.tempString = exifModel.exif.dateTimeOriginal;
    [_detailInfo addObject:@[@"创建时间", _tempString]];
    self.tempString = [exifModel.exif.digitalZoomRatio stringValue];
    [_detailInfo addObject:@[@"数位变焦比率", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%@", [exifModel.exif.exifVersion qs_descriptionWithSeparator:@"."]];
    [_detailInfo addObject:@[@"Exif版本", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%ld", (long)[exifModel.exif.exposureBiasValue integerValue]];
    [_detailInfo addObject:@[@"曝光补偿", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%ld", (long)[exifModel.exif.exposureMode integerValue]];
    [_detailInfo addObject:@[@"曝光模式", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%ld", (long)[exifModel.exif.exposureProgram integerValue]];
    [_detailInfo addObject:@[@"曝光程序", _tempString]];
    self.tempString = [exifModel.exif.exposureTime stringValue];
    [_detailInfo addObject:@[@"曝光时间", _tempString]];
    self.tempString = [exifModel.exif.fNumber stringValue];
    [_detailInfo addObject:@[@"光圈系数(fNumber)", _tempString]];
    self.tempString = [exifModel.exif.flash stringValue];
    [_detailInfo addObject:@[@"闪光灯", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%@", [exifModel.exif.flashPixVersion qs_descriptionWithSeparator:@"."]];
    [_detailInfo addObject:@[@"Flash Pix 版本", _tempString]];
    self.tempString = [exifModel.exif.focalLength stringValue];
    [_detailInfo addObject:@[@"焦距", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%@", [exifModel.exif.iSOSpeedRatings qs_descriptionWithSeparator:@""]];
    [_detailInfo addObject:@[@"感光度", _tempString]];
    self.tempString = [exifModel.exif.lightSource stringValue];
    [_detailInfo addObject:@[@"光源（白平衡）", _tempString]];
    self.tempString = [exifModel.exif.meteringMode stringValue];
    [_detailInfo addObject:@[@"测光方式", _tempString]];
    self.tempString = exifModel.exif.lensMake;
    [_detailInfo addObject:@[@"增光设备生产商", _tempString]];
    self.tempString = exifModel.exif.lensModel;
    [_detailInfo addObject:@[@"增光模式", _tempString]];
    self.tempString = [exifModel.exif.sceneCaptureType stringValue];
    [_detailInfo addObject:@[@"取景模式", _tempString]];
    self.tempString = [exifModel.exif.whiteBalance stringValue];
    [_detailInfo addObject:@[@"白平衡", _tempString]];
    // TIFF
    self.tempString = exifModel.tiff.dateTime;
    [_detailInfo addObject:@[@"拍摄时间", _tempString]];
    self.tempString = exifModel.tiff.make;
    [_detailInfo addObject:@[@"拍照设备厂家", _tempString]];
    self.tempString = exifModel.tiff.model;
    [_detailInfo addObject:@[@"拍照设备型号", _tempString]];
    self.tempString = exifModel.tiff.software;
    [_detailInfo addObject:@[@"软件", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.tiff.titleLength];
    [_detailInfo addObject:@[@"标题长度", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.tiff.titleWidth];
    [_detailInfo addObject:@[@"标题宽度", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.tiff.resolutionUnit];
    [_detailInfo addObject:@[@"分辨率单位", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.tiff.xResolution];
    [_detailInfo addObject:@[@"水平分辨率", _tempString]];
    self.tempString = [NSString stringWithFormat:@"%lu",(unsigned long)exifModel.tiff.yResolution];
    [_detailInfo addObject:@[@"垂直分辨率", _tempString]];
    // GPS
    self.tempString = [NSString stringWithFormat:@"%.2f°%@ %.2f°%@", [exifModel.gps.latitude doubleValue], exifModel.gps.latitudeRef,  [exifModel.gps.longitude doubleValue], exifModel.gps.longitudeRef];
    if (exifModel.gps.latitude == nil) {
        self.tempString = nil;
    }
    [_detailInfo addObject:@[@"全球定位系统GPS", _tempString]];
}

- (void)setTempString:(NSString *)tempString {
    if (tempString == nil) {
        _tempString = @"不可用";
    } else {
        _tempString = tempString;
    }
}

@end
