//
//  XiaoZhiShiViewController.h
//  Newthermometer
//
//  Created by 莫福见 on 16/3/2.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "ViewController.h"
@protocol PassValueDelegate
-(void)celltext:(NSString*)text cellrow:(NSInteger)integer;
@end
@interface XiaoZhiShiViewController : ViewController
@property(retain,nonatomic)id<PassValueDelegate>passdelegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH;
@property (weak, nonatomic) IBOutlet UITableView *tablelview;

@end
