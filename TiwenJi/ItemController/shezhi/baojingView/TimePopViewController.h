//
//  TimePopViewController.h
//  Newthermometer
//
//  Created by 莫福见 on 16/3/1.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "ViewController.h"

@protocol TimePopupViewDelegate;

@interface TimePopViewController : ViewController
@property (weak, nonatomic) IBOutlet UIPickerView *timepick;
@property (assign, nonatomic) id <TimePopupViewDelegate>delegate;




@end
@protocol TimePopupViewDelegate<NSObject>
@optional
- (void)quxiaoClicked:(TimePopViewController*)secondDetailViewController;
- (void)okButtonClicked:(TimePopViewController *)TimePopViewController Time:(int)time ;
@end
