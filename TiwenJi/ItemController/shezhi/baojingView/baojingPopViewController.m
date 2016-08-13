//
//  baojingPopViewController.m
//  Newthermometer
//
//  Created by 莫福见 on 16/3/1.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "baojingPopViewController.h"


@interface baojingPopViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSString* wendu;
    int Sender;
}
@property(nonatomic,strong)NSMutableArray*pickerArray;
@property(nonatomic,strong)NSMutableArray*pickerArray2;
@property(nonatomic,strong)NSMutableArray*pickerArray3;
@property(nonatomic,strong)NSString*zhengshu;
@property(nonatomic,strong)NSString*xiaoshushu;


@end

@implementation baojingPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    _pickerArray=[[NSMutableArray alloc]initWithCapacity:1];
    for(int i=37;i<=42;i++)
    {
        NSString *stringInt = [NSString stringWithFormat:@"%d",i];
        
        
        [_pickerArray addObject:stringInt];
    }
    _pickerArray2=[[NSMutableArray alloc]initWithCapacity:1];
    for(int i=0;i<=99;i++)
    {
        NSString *stringInt = [NSString stringWithFormat:@"%d",i];
        
        [_pickerArray2 addObject:stringInt];
    }
    _pickerArray3=[[NSMutableArray alloc]initWithCapacity:1];
    for(int i=30;i<=40;i++)
    {
        NSString *stringInt = [NSString stringWithFormat:@"%d",i];
        
        [_pickerArray3 addObject:stringInt];
    }
    
    
    
    [self.pick1 selectRow:0 inComponent:0 animated:YES];
    [self.pick1 selectRow:0 inComponent:2 animated:YES];
    
}
-(void)pass:(int)sender{
    Sender=sender;
    NSLog(@"Sender=%d",Sender);
    [self.pick1 reloadAllComponents];
}
- (IBAction)OK:(id)sender {
    
    NSString*qian=self.zhengshu ;
    NSString*hou=self.xiaoshushu;
   
    
    if (qian==nil&&hou==nil) {
        [self.delegate baojingokButtonClicked:self Time:@"37.00" sender:Sender];
      
    } if (qian==nil&&hou!=nil) {
         NSString*string=@"37.";
        NSString*str=[string stringByAppendingString:hou];
        [self.delegate baojingokButtonClicked:self Time:str sender:Sender];
       
    }
    
    if (qian!=nil&&hou==nil) {
        NSString*string2=@"00";
        
        NSString*str2=[[qian stringByAppendingString:@"."] stringByAppendingString:string2];
        [self.delegate baojingokButtonClicked:self Time:str2 sender:Sender];
       
    }
    if (qian!=nil&&hou!=nil) {
        wendu=[[qian stringByAppendingString:@"."] stringByAppendingString:hou];
        [self.delegate baojingokButtonClicked:self Time:wendu sender:Sender];
       
    }
    
   
   
}
- (IBAction)quxiao:(id)sender {
     [self.delegate baojingquxiaoClicked:self];
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 4; // 返回2表明该控件只包含2列
}
//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
   
    
    if (Sender==0) {
        // 如果是第一列，返回authors中元素的个数
        // 即authors包含多少个元素，第一列包含多少个列表项
        if (component == 0) {
            return _pickerArray.count;
        }
        if (component == 1) {
            return 1;
        }if (component == 2) {
            // 如果是其他列（只有第二列），
            // 返回books中selectedAuthor对应的NSArray中元素的个数
            return _pickerArray2.count;
        }
        return 1;
    }
    else{
        // 如果是第一列，返回authors中元素的个数
        // 即authors包含多少个元素，第一列包含多少个列表项
        if (component == 0) {
            return _pickerArray3.count;
        }
        if (component == 1) {
            return 1;
        }if (component == 2) {
            // 如果是其他列（只有第二列），
            // 返回books中selectedAuthor对应的NSArray中元素的个数
            return _pickerArray2.count;
        }
        return 1;
        
    }
    
}
// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为
// UIPickerView中指定列和列表项上显示的标题
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component
{
    if (Sender==0) {
        // 如果是第一列，返回authors中row索引处的元素
        // 即第一列的元素由authors集合元素决定
        if (component == 0) {
            return [_pickerArray objectAtIndex:row];
        }
        if (component ==1 ) {
            return @".";
        } if (component ==2 ) {
            // 如果是其他列（只有第二列），
            // 返回books中selectedAuthor对应的NSArray中row索引处的元素
            return [_pickerArray2 objectAtIndex:row];
        }
        return @"°C";
    }
    else{
        // 如果是第一列，返回authors中row索引处的元素
        // 即第一列的元素由authors集合元素决定
        if (component == 0) {
            return [_pickerArray3 objectAtIndex:row];
        }
        if (component ==1 ) {
            return @".";
        } if (component ==2 ) {
            // 如果是其他列（只有第二列），
            // 返回books中selectedAuthor对应的NSArray中row索引处的元素
            return [_pickerArray2 objectAtIndex:row];
        }
        return @"°C";
    }
    
}
// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component

{
    if (Sender==0) {
        // 即第一列的元素由authors集合元素决定
        if (component == 0) {
            self.zhengshu=[_pickerArray objectAtIndex:row];
            NSLog(@"%@", [_pickerArray objectAtIndex:row]);
        }
        if (component ==2 ) {
            self.xiaoshushu=[_pickerArray2 objectAtIndex:row];
            NSLog(@"%@", [_pickerArray2 objectAtIndex:row]);
            
        }
    }
    else{
        // 即第一列的元素由authors集合元素决定
        if (component == 0) {
            self.zhengshu=[_pickerArray3 objectAtIndex:row];
            NSLog(@"%@", [_pickerArray3 objectAtIndex:row]);
        }
        if (component ==2 ) {
            self.xiaoshushu=[_pickerArray2 objectAtIndex:row];
            NSLog(@"%@", [_pickerArray2 objectAtIndex:row]);
            
        }
        
    }
    
    
   
}
// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为
// UIPickerView中指定列的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:
(NSInteger)component
{
    // 如果是第一列，宽度为90
    if (component == 0) {
        return 40;
    }if (component == 1) {
       return  15;
    }
    if (component == 2) {
        return  40;
    }
    return 38; // 如果是其他列（只有第二列），宽度为210
}

    
    

    





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
