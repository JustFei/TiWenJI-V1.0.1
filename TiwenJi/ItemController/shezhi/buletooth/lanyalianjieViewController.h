//
//  lanyalianjieViewController.h
//  Newthermometer
//
//  Created by 莫福见 on 16/2/27.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

//回调到oneViewController的时候修改扫描按钮的title和状态，但是现在不能回调
typedef void(^LanYaLianJieWaitingForDataCallBack)(void);

//回调到oneViewController的时候，当前断开连接的时候，暂停定时器
typedef void(^DisconnectCallBack)(void);

@interface lanyalianjieViewController : ViewController
@property (weak, nonatomic) IBOutlet UIImageView *beaconView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchImageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchImageH;

@property (weak, nonatomic) IBOutlet UISwitch *duankaiSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dianlianglabel;

@property (nonatomic,copy) LanYaLianJieWaitingForDataCallBack block;

@property (nonatomic,copy) DisconnectCallBack disconnetCallBack;

//- (void)setLanYaLianJieWaitingForDataCallBack:(LanYaLianJieWaitingForDataCallBack)callback;

@end

