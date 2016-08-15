//
//  baojingViewController.m
//  Newthermometer
//
//  Created by 莫福见 on 16/2/26.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "baojingViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "baojingPopViewController.h"
#import "TimePopViewController.h"
@interface baojingViewController ()<TimePopupViewDelegate,baojingPopupViewDelegate>{
    baojingPopViewController*baojingPopView;
    TimePopViewController*timePopVie;
    
   
   
}
@property(nonatomic, assign) BOOL Gswitch;
@property(nonatomic, assign) BOOL GLswitch;
@property(nonatomic, assign) BOOL GZswitch;
@property(nonatomic, assign) BOOL Dswitch;
@property(nonatomic, assign) BOOL DLswitch;
@property(nonatomic, assign) BOOL DZswitch;

@end

@implementation baojingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self panduan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)buttonAction:(id)sender {
    UIButton*button=sender;
    switch (button.tag) {
        case 0:
            baojingPopView=nil;
            baojingPopView=[[baojingPopViewController alloc]initWithNibName:@"baojingPopViewController" bundle:nil];
            baojingPopView.delegate=self;
            
            [self presentPopupViewController:baojingPopView animationType:MJPopupViewAnimationFade];
            
            self.passdelegate=baojingPopView;
            [self.passdelegate pass:(int)button.tag];
            break;
        case 1:
            baojingPopView=nil;
            baojingPopView=[[baojingPopViewController alloc]initWithNibName:@"baojingPopViewController" bundle:nil];
            baojingPopView.delegate=self;
            [self presentPopupViewController:baojingPopView animationType:MJPopupViewAnimationFade];
            
            self.passdelegate=baojingPopView;
            [self.passdelegate pass:(int)button.tag];

            break;
        case 2:
            timePopVie=nil;
            timePopVie=[[TimePopViewController alloc]initWithNibName:@"TimePopViewController" bundle:nil];
            timePopVie.delegate=self;
            [self presentPopupViewController:timePopVie animationType:MJPopupViewAnimationFade];

            break;
            
        default:
            break;
    }
    
}


- (void)quxiaoClicked:(TimePopViewController*)secondDetailViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    secondDetailViewController = nil;
}
- (void)okButtonClicked:(TimePopViewController *)TimePopViewController Time:(int)time {
    
    self.baojingjiege.text=[NSString stringWithFormat:@"%d",time];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    TimePopViewController = nil;
    
}

- (void)baojingquxiaoClicked:(baojingPopViewController*)secondDetailViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    secondDetailViewController = nil;
    
}
- (void)baojingokButtonClicked:(baojingPopViewController *)TimePopViewController Time:(NSString*)wenduString sender:(int)Sender{

    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    TimePopViewController = nil;
    switch (Sender) {
        case 0:
            self.gaowenLabel.text=wenduString;
            break;
        case 1:
            self.diwenLabel.text=wenduString;
            break;
            
        default:
            break;
    }
    
}
-(void)panduan{
    
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    if ([user stringForKey:@"baojingjiege"]!=nil) {
        self.baojingjiege.text=[user stringForKey:@"baojingjiege"];
    }
    else{
        self.baojingjiege.text=@"0";
        
    }
    
    if ([user stringForKey:@"gaowenLabel"]!=nil) {
        self.gaowenLabel.text=[user stringForKey:@"gaowenLabel"];
    }
    else{
        self.baojingjiege.text=@"0";
        
    }
    
    if ([user stringForKey:@"diwenLabel"]!=nil) {
        self.diwenLabel.text=[user stringForKey:@"diwenLabel"];
    }
    else{
        self.baojingjiege.text=@"0";
        
    }
    
    [user boolForKey:@"Gswitch"]?[self.Gbaojingswitch  setOn:YES animated:YES]:[self.Gbaojingswitch  setOn:NO animated:YES];
    
    [user boolForKey:@"GLswitch"]?[self.GlingsSwitch  setOn:YES animated:YES]:[self.GlingsSwitch  setOn:NO animated:YES];
     [user boolForKey:@"GZswitch"]?[self.GzhengdongSwitch  setOn:YES animated:YES]:[self.GzhengdongSwitch  setOn:NO animated:YES];
    
    
    [user boolForKey:@"Dswitch"]?[self.DbaojingSwitch  setOn:YES animated:YES]:[self.DbaojingSwitch  setOn:NO animated:YES];
    
    [user boolForKey:@"DLswitch"]?[self.DlingsSwitch  setOn:YES animated:YES]:[self.DlingsSwitch  setOn:NO animated:YES];
    [user boolForKey:@"DZ"]?[self.DzhengdongSwitch  setOn:YES animated:YES]:[self.DzhengdongSwitch  setOn:NO animated:YES];
    
    
    
  
    
}


- (IBAction)baocun:(id)sender {
    if ([self.baojingjiege.text isEqualToString:@"0"]||[self.diwenLabel.text isEqualToString:@"0"]||[self.gaowenLabel.text isEqualToString:@"0"]) {
        NSLog(@"设置不完整 无法保存");
        UIAlertView *failSaveView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hint", nil) message:NSLocalizedString(@"SaveFailInfo", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        
        failSaveView.tag = 100;
        
        [failSaveView show];
    }
    else{
        
    
       
        NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
        if ([self.Gbaojingswitch isOn]) {
            self.Gswitch=YES;
           
        }
        else{
            self.Gswitch=NO;
           
        }
        [user setBool:self.Gswitch forKey:@"Gswitch"];
        
        
        if ([self.GlingsSwitch isOn]) {
            self.GLswitch=YES;
            
        }
        else{
            self.GLswitch=NO;
            
        }
        [user setBool:self.GLswitch forKey:@"GLswitch"];
        
        if ([self.GzhengdongSwitch isOn]) {
            self.GZswitch=YES;
            
        }
        else{
            self.GZswitch=NO;
            
        }
        [user setBool:self.GZswitch forKey:@"GZswitch"];
        
        
        if ([self.DbaojingSwitch isOn]) {
            self.Dswitch=YES;
            
        }
        else{
            self.Dswitch=NO;
            
        }
        [user setBool:self.Dswitch forKey:@"Dswitch"];
        
        if ([self.DlingsSwitch isOn]) {
            self.DLswitch=YES;
            
        }
        else{
            self.DLswitch=NO;
            
        }
        [user setBool:self.DLswitch forKey:@"DLswitch"];
        
        if ([self.DzhengdongSwitch isOn]) {
            self.DZswitch=YES;
            
        }
        else{
            self.DZswitch=NO;
            
        }
        [user setBool:self.DZswitch forKey:@"DZ"];
        
        [user setObject:self.baojingjiege.text forKey:@"baojingjiege"];
        [user setObject:self.gaowenLabel.text forKey:@"gaowenLabel"];
        [user setObject:self.diwenLabel.text forKey:@"diwenLabel"];
        
        UIAlertView *saveSuccessView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hint", nil) message:NSLocalizedString(@"SaveSuccessInfo", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Complete", nil) otherButtonTitles:nil, nil];
        
        saveSuccessView.tag = 101;
        
        [saveSuccessView show];
       
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        
    }
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
     self.oneView.constant=[UIScreen mainScreen].bounds.size.height*0.3;
     self.twoView.constant=[UIScreen mainScreen].bounds.size.height*0.3;
    self.image1W.constant=[UIScreen mainScreen].bounds.size.height*0.3/4/2;
    self.iamge2W.constant=[UIScreen mainScreen].bounds.size.height*0.3/4/2;
    
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
