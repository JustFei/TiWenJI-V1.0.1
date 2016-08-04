//
//  aboutAsViewController.m
//  TiwenJi
//
//  Created by 莫福见 on 16/3/31.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "aboutAsViewController.h"

@interface aboutAsViewController ()

@end

@implementation aboutAsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.logoimageH.constant=[UIScreen mainScreen].bounds.size.height*0.1;
    
    self.logoimageW.constant=[UIScreen mainScreen].bounds.size.height*0.2;
    
    self.xiaViewH.constant=[UIScreen mainScreen].bounds.size.height*0.1;
    self.image1H.constant=[UIScreen mainScreen].bounds.size.height*0.1;
    self.image1W.constant=[UIScreen mainScreen].bounds.size.height*0.1;
    self.image2H.constant=[UIScreen mainScreen].bounds.size.height*0.1;
    self.image2W.constant=[UIScreen mainScreen].bounds.size.height*0.1;
    self.labelH.constant=[UIScreen mainScreen].bounds.size.height*0.5;
    
}

@end
