//
//  gaowenbaojinView.h
//  TiwenJi
//
//  Created by 莫福见 on 16/3/24.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "ViewController.h"
#import "oneViewController.h"


@protocol MJSecondPopupDelegate;
@interface gaowenbaojinView : ViewController<onepassButtonSenderDelegate>

@property (assign, nonatomic) id <MJSecondPopupDelegate>delegate;

@end
@protocol MJSecondPopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(ViewController*)secondDetailViewController;
- (void)okButtonClicked:(ViewController *)aSecondDetailViewController;
@end