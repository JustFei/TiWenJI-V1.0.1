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
@property (nonatomic, strong) THDatePickerViewController * datePicker;

@end
