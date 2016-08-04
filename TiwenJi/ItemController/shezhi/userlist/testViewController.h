//
//  testViewController.h
//  TiwenJi
//
//  Created by 莫福见 on 16/4/11.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yonghuViewController.h"
@protocol testDelegate;
@interface testViewController : UIViewController
@property (assign, nonatomic) id <testDelegate>Delegate;
@end
@protocol testDelegate<NSObject>
@optional
- (void)NcancelButtonClicked:(testViewController*)secondDetailViewController;
- (void)NokButtonClicked:(testViewController *)aSecondDetailViewController Labelstring:(NSString*)labelstring;
@end