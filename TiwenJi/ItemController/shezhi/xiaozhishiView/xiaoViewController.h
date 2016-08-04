//
//  xiaoViewController.h
//  TiwenJi
//
//  Created by 莫福见 on 16/3/30.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XiaoZhiShiViewController.h"

@interface xiaoViewController : UIViewController<PassValueDelegate>
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) IBOutlet UILabel *headtext;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineH;

@end
