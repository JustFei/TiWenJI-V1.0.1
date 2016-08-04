//
//  TabBarViewController.m
//  Newthermometer
//
//  Created by 莫福见 on 16/2/22.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "TabBarViewController.h"
#import "oneViewController.h"
#import "twoViewController.h"
#import "threeViewController.h"
#import "SVProgressHUD.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
  
    [super viewDidLoad];
    
        CGRect frame = CGRectMake(-1, 0, [UIScreen mainScreen].bounds.size.width+1, 50);
        UIImageView *v = [[UIImageView alloc] initWithFrame:frame];
        v.image=[UIImage imageNamed:@"barback.png"];
    
        [self.tabBar insertSubview:v atIndex:0];
    
    
  
    
    
    self.tabBar.tintColor=[UIColor whiteColor];
    
    
    //[[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    for (UITabBarItem *item in self.tabBar.items) {
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       
    }
  
    
    
    
}


@end
