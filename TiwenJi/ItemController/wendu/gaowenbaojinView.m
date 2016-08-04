//
//  gaowenbaojinView.m
//  TiwenJi
//
//  Created by 莫福见 on 16/3/24.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "gaowenbaojinView.h"

@interface gaowenbaojinView ()
@property (weak, nonatomic) IBOutlet UIImageView *backimage;
@property (weak, nonatomic) IBOutlet UILabel *MZ;
@property (weak, nonatomic) IBOutlet UILabel *tw;

@end

@implementation gaowenbaojinView

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    self.view.layer.masksToBounds = YES;
   self.view.layer.cornerRadius = 6.0;

   
    self.backimage.layer.masksToBounds = YES;
    self.backimage.layer.cornerRadius = 6.0;

}
- (IBAction)quxiao:(id)sender {
    
    [self.delegate cancelButtonClicked:self];

}
- (IBAction)queding:(id)sender {
    [self.delegate okButtonClicked:self];

}

-(void)passSender:(NSString*)mingz Wendu:(NSString*)wendu{
    
    self.MZ.text=mingz;
    self.tw.text=wendu;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
