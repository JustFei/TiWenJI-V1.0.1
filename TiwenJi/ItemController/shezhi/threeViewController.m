//
//  threeViewController.m
//  Newthermometer
//
//  Created by 莫福见 on 16/2/22.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "threeViewController.h"

@interface threeViewController (){
  
}

@end

@implementation threeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self iconSeting];
  
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"iconimage"];
    
    if(imageData != nil)
    {
        UIImage*image1= [UIImage imageWithData:imageData];
        [self.iconimageview setImage:image1];
        
    }
    else
    {
        [self.iconimageview setImage:[UIImage imageNamed:@"icon"]];
    }
    
    
    NSString*name=[[NSUserDefaults standardUserDefaults] objectForKey:@"suername"];
    
    if (name==nil)
    {
        self.Namelabel.text=@"姓名";
    }
    else
    {
        self.Namelabel.text=name;
    }
    
    
}

-(void)iconSeting{
    
    self.iconimageview.layer.masksToBounds=YES;
//    self.iconimageview.layer.cornerRadius=self.iconimageview.bounds.size.width*0.5;
    self.iconimageview.layer.cornerRadius=[UIScreen mainScreen].bounds.size.width*0.4/2;
//    self.iconimageview.layer.borderWidth=3.0;
//    self.iconimageview.layer.borderColor=[UIColor whiteColor].CGColor;
    
  
    
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    CGFloat ht=[UIScreen mainScreen].bounds.size.height;
    
    self.height1.constant=(ht*0.4)/5;
    self.height2.constant=(ht*0.4)/5;
    self.height3.constant=(ht*0.4)/5;
    self.height4.constant=(ht*0.4)/5;
    self.heigt5.constant=(ht*0.4)/5;
    
    self.iamgeH.constant=(ht*0.3)/5-20;
    self.imageW.constant=(ht*0.3)/5-20;
    self.imageW1.constant=(ht*0.3)/5-20;
    self.imageH1.constant=(ht*0.3)/5-20;
    self.imageW2.constant=(ht*0.3)/5-20;
    self.imageH2.constant=(ht*0.3)/5-20;
    self.imageW3.constant=(ht*0.3)/5-20;
    self.imageH3.constant=(ht*0.3)/5-20;
    self.imageW4.constant=(ht*0.3)/5-20;
    self.imageH4.constant=(ht*0.3)/5-20;
    
    self.iconimageW.constant=(ht*0.4)/5-20;
    self.iconimageW1.constant=(ht*0.4)/5-20;
    self.iconimageW2.constant=(ht*0.4)/5-20;
    self.iconimageW3.constant=(ht*0.4)/5-20;
    self.iconimageW4.constant=(ht*0.4)/5-20;
    
    
    self.icomH.constant=[UIScreen mainScreen].bounds.size.width*0.4;
    self.iconW.constant=[UIScreen mainScreen].bounds.size.width*0.4;
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
