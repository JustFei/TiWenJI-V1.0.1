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

@interface lanyalianjieViewController : ViewController
@property (weak, nonatomic) IBOutlet UIImageView *beaconView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchImageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchImageH;

@property (weak, nonatomic) IBOutlet UISwitch *duankaiSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dianlianglabel;

@end

