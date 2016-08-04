//
//  helpsViewController.m
//  TiwenJi
//
//  Created by 莫福见 on 16/3/31.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "helpsViewController.h"

@interface helpsViewController ()

@end

@implementation helpsViewController

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
    self.view1H.constant=([UIScreen mainScreen].bounds.size.height-70)/4;
    self.view2H.constant=([UIScreen mainScreen].bounds.size.height-70)/4;
    self.view3H.constant=([UIScreen mainScreen].bounds.size.height-70)/4;

    self.view4H.constant=([UIScreen mainScreen].bounds.size.height-70)/4;
    
    self.viewimageH.constant=([UIScreen mainScreen].bounds.size.height-70)/4-42;
    
    self.viewimageW.constant=([UIScreen mainScreen].bounds.size.height-70)/4-42;
     self.viewimage1W.constant=([UIScreen mainScreen].bounds.size.height-70)/4-42;
      self.viewimage2W.constant=([UIScreen mainScreen].bounds.size.height-70)/4-42;
    
}

@end
