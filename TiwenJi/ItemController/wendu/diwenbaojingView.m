//
//  diwenbaojingView.m
//  TiwenJi
//
//  Created by 莫福见 on 16/3/24.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//



#import "diwenbaojingView.h"

@interface diwenbaojingView ()
@property (weak, nonatomic) IBOutlet UILabel *mingz;
@property (weak, nonatomic) IBOutlet UILabel *wendu;
@property (weak, nonatomic) IBOutlet UIImageView *backimage;

@end

@implementation diwenbaojingView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 6.0;
    
    
    self.backimage.layer.masksToBounds = YES;
    self.backimage.layer.cornerRadius = 6.0;
}
- (IBAction)quxiao:(id)sender {
    [self.delegate dwcancelButtonClicked:self];
}
- (IBAction)queding:(id)sender {
    [self.delegate dwokButtonClicked:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)passSender:(NSString*)mingz Wendu:(NSString*)wendu{
    
    self.mingz.text=mingz;
    self.wendu.text=wendu;
}

@end
