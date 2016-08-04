//
//  xiaoViewController.m
//  TiwenJi
//
//  Created by 莫福见 on 16/3/30.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "xiaoViewController.h"


@interface xiaoViewController ()
@property(nonatomic,assign)NSInteger integer;
@end

@implementation xiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSString* plistfile1 = [[NSBundle mainBundle]pathForResource:@"wenzi" ofType:@"plist"];
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithContentsOfFile:plistfile1];
    
   

        self.text.text=[data valueForKey:[NSString stringWithFormat:@"%ld",(long)self.integer+1]];
    self.headtext.text=[data valueForKey:[NSString stringWithFormat:@"%ld",(long)self.integer+101]];
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)celltext:(NSString *)text cellrow:(NSInteger)integer{
    self.integer=integer;

}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.lineH.constant=[UIScreen mainScreen].bounds.size.height*0.03;
}

@end
