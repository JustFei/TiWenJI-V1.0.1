//
//  AboutViewController.m
//  Newthermometer
//
//  Created by 莫福见 on 16/2/29.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "AboutViewController.h"
#import "aboutAsViewController.h"
#import "helpsViewController.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)helpsViewController*vc;
@property(nonatomic,strong)aboutAsViewController*bc;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabelview.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tabelview dequeueReusableCellWithIdentifier:@"cell"];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
    
            
        case 0:
            cell.textLabel.text=NSLocalizedString(@"UseHelp", nil );
            break;
            
        case 1:
            cell.textLabel.text=@"关于我们";
            break;
        
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
//        case 0:
//          
//            [self Version];
            break;
        case 0:
                _vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"helpsViewController"];
                [self presentViewController:_vc animated:YES completion:^{
            
                }];
            break;
        case 1:
            _bc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"aboutAsViewController"];
            [self presentViewController:_bc animated:YES completion:^{
                
            }];
            break;
        default:
            break;
    }
  
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height*0.25/2;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.tabelviewH.constant=[UIScreen mainScreen].bounds.size.height*0.25;
    self.tabeldowntoviewdown.constant=[UIScreen mainScreen].bounds.size.height*0.25;
    self.viewH.constant=[UIScreen mainScreen].bounds.size.height*0.25;
    
    self.logoH.constant=[UIScreen mainScreen].bounds.size.height*0.13;self.logoW.constant=[UIScreen mainScreen].bounds.size.width*0.5;
    
    
}
-(void)Version{
    UIAlertView*aler=[[UIAlertView alloc]initWithTitle:@"版本检查" message:@"已是最新版本" delegate:self
cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [aler show];
//    NSString*string=[NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://itunes.apple.com/lookup?id=1076859655"] encoding:NSUTF8StringEncoding error:nil];
//    if (string!=nil&&[string length]>0&&[string rangeOfString:@"version"].length==7) {
//        [self checkupdate:string];
//    }
    
}
-(void)checkupdate:(NSString*)appinfo{
   
    NSString*version=[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
    NSString*appinfo1=[appinfo substringFromIndex:[appinfo rangeOfString:@"\"version\":"].location+10];
   // NSLog(@"appinfo1=%@",appinfo1);
    appinfo1=[[appinfo1 substringToIndex:[appinfo1 rangeOfString:@","].location]stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSLog(@"现在的版本=%@",version);
    NSLog(@"APP上的的版本=%@",appinfo1);
}

@end
