//
//  MCChartInformationView.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/18.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCChartInformationView : UIView

@property (nonatomic, strong) UILabel *textLabel;

- (instancetype)initWithText:(NSString *)text ;//withBackgroudColor:(UIColor *)backColor

@end
