//
//  TimePopViewController.m
//  Newthermometer
//
//  Created by 莫福见 on 16/3/1.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "TimePopViewController.h"
#import "baojingViewController.h"

@interface TimePopViewController (){
    int Int;
}
@property(nonatomic,strong)NSMutableArray*pickerArray;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *suerButton;

@end

@implementation TimePopViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    _pickerArray=[[NSMutableArray alloc]initWithCapacity:1];
    self.cancelButton.layer.borderWidth = 1.0;
    self.suerButton.layer.borderWidth = 1.0;
    self.cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.suerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    for(int i=2;i<30;i++)
    {
        NSString *stringInt = [NSString stringWithFormat:@"%d",i];
        
        [_pickerArray addObject:stringInt];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)OK:(id)sender {
    if (Int==0) {
        Int=2;
    }
    
        [self.delegate okButtonClicked:self Time:Int];
    
}
- (IBAction)quxiao:(id)sender {
     [self.delegate quxiaoClicked:self];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
  
        return [_pickerArray count];
 
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  
        return [_pickerArray objectAtIndex:row];

  

    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return 40.0;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //NSLog(@"%@",[_pickerArray objectAtIndex:row]);
   
        Int=[[_pickerArray objectAtIndex:row] intValue];


    
}

@end
