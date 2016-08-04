//
//  baojingPopViewController.h
//  Newthermometer
//
//  Created by 莫福见 on 16/3/1.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "ViewController.h"
#import "baojingViewController.h"
@protocol baojingPopupViewDelegate;

@interface baojingPopViewController : ViewController<PassButtonSenderDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pick1;

@property (assign, nonatomic) id <baojingPopupViewDelegate>delegate;

@end
@protocol baojingPopupViewDelegate<NSObject>
@optional
- (void)baojingquxiaoClicked:(baojingPopViewController*)secondDetailViewController;
- (void)baojingokButtonClicked:(baojingPopViewController *)TimePopViewController Time:(NSString*)wenduString sender:(int)Sender;
@end
