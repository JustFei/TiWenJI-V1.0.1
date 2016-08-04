//
//  AboutViewController.h
//  Newthermometer
//
//  Created by 莫福见 on 16/2/29.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "ViewController.h"

@interface AboutViewController : ViewController
@property (strong, nonatomic) IBOutlet UITableView *tabelview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tabeldowntoviewdown;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoW;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tabelviewH;
@end
