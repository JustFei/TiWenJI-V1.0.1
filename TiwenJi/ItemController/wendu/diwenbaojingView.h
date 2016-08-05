//
//  diwenbaojingView.h
//  TiwenJi
//
//  Created by 莫福见 on 16/3/24.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//




#import "ViewController.h"
#import "oneViewController.h"

@protocol dwbjViewPopupDelegate;

@interface diwenbaojingView : ViewController<onepassButtonSenderDelegate>
@property (assign, nonatomic) id <dwbjViewPopupDelegate>delegate;
@end

@protocol dwbjViewPopupDelegate<NSObject>
@optional
- (void)dwcancelButtonClicked:(ViewController*)secondDetailViewController;
- (void)dwokButtonClicked:(ViewController *)aSecondDetailViewController;
@end