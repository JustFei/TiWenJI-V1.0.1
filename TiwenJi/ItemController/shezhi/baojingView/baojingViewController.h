//
//  baojingViewController.h
//  Newthermometer
//
//  Created by 莫福见 on 16/2/26.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "ViewController.h"
@protocol PassButtonSenderDelegate<NSObject>

-(void)pass:(int)sender;

@end

@interface baojingViewController : ViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image1W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iamge2W;
@property (weak, nonatomic) IBOutlet UILabel *gaowenLabel;
@property (weak, nonatomic) IBOutlet UILabel *diwenLabel;
@property (weak, nonatomic) IBOutlet UISwitch *Gbaojingswitch;
@property (weak, nonatomic) IBOutlet UISwitch *GlingsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *GzhengdongSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *DbaojingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *DlingsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *DzhengdongSwitch;
@property (weak, nonatomic) IBOutlet UILabel *baojingjiege;
@property (weak, nonatomic) IBOutlet UIButton *baocunButton;
@property (weak, nonatomic) IBOutlet UIButton *jiangeButton;
@property (weak, nonatomic) IBOutlet UIButton *diwenButton;
@property (weak, nonatomic) IBOutlet UIButton *gaowenButton;
@property (strong, nonatomic) id <PassButtonSenderDelegate>passdelegate;
@end
