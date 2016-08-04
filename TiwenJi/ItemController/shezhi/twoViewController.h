//
//  twoViewController.h
//  Newthermometer
//
//  Created by 莫福见 on 16/2/22.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "THDatePickerViewController.h"

@interface twoViewController : UIViewController<THDatePickerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label2H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label2W;

@property (weak, nonatomic) IBOutlet UIButton *todayButton;

@property (weak, nonatomic) IBOutlet UIButton *zuoButton;
@property (weak, nonatomic) IBOutlet UIButton *youButton;

@property (nonatomic, strong) THDatePickerViewController * datePicker;

@end
