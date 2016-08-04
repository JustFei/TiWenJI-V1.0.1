//
//  XiaoZhiShiViewController.m
//  Newthermometer
//
//  Created by 莫福见 on 16/3/2.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "XiaoZhiShiViewController.h"
#import "xiaoViewController.h"

@interface XiaoZhiShiViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation XiaoZhiShiViewController

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [self.tablelview dequeueReusableCellWithIdentifier:@"cell"];
  
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"1.什么是小儿发热？";
            break;
            
        case 1:
            cell.textLabel.text=@"2.小儿发烧的原因";
            break;
            
        case 2:
            cell.textLabel.text=@"3.小儿发烧的临床表现";
            break;
            
            
        case 3:
            cell.textLabel.text=@"4.小儿发烧的检查";
            break;
        case 4:
            cell.textLabel.text=@"5.小儿发烧的诊断及并发症";
            break;
        case 5:
            cell.textLabel.text=@"6.小儿发烧的治疗";
            break;
        case 6:
            cell.textLabel.text=@"7.六招简单的退烧法";
            break;
        case 7:
            cell.textLabel.text=@"8.小儿发烧的物理降温方法";
            break;
        case 8:
            cell.textLabel.text=@"9.小儿感冒补水";
            break;
        case 9:
            cell.textLabel.text=@"10.怎么选择儿童退烧药";
            break;
        case 10:
            cell.textLabel.text=@"11.怎样区分孩子正常的体温升高或降低";
            break;
      
            
            
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell        *cell = [self.tablelview cellForRowAtIndexPath:indexPath];
            xiaoViewController*vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"xiaoViewController"];
    self.passdelegate=vc;
    [self.passdelegate celltext:cell.textLabel.text cellrow:indexPath.row];
    
            [self presentViewController:vc animated:YES completion:^{
    
            }];
    
    
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.linH.constant=[UIScreen mainScreen].bounds.size.height*0.03;
}
@end
