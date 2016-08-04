//
//  otherpopViewController.h
//  TiwenJi
//
//  Created by 莫福见 on 16/4/11.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yonghuViewController.h"
@protocol MJSecondPopupDelegate;
@interface otherpopViewController : UIViewController<passButtonSenderDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (assign, nonatomic) id <MJSecondPopupDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *pickview;

@end
@protocol MJSecondPopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(otherpopViewController*)secondDetailViewController;
- (void)okButtonClicked:(otherpopViewController *)aSecondDetailViewController item:(NSString*)Item sender:(int)Sender;
@end