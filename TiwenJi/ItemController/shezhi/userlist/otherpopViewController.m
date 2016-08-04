//
//  otherpopViewController.m
//  TiwenJi
//
//  Created by 莫福见 on 16/4/11.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "otherpopViewController.h"

@interface otherpopViewController ()
@property(nonatomic,strong)NSMutableArray*pickerArray;
@property(nonatomic,assign)int buttonsender;
@property(nonatomic,strong)NSString*item;

@end

@implementation otherpopViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)passSender:(int)sender{
    _buttonsender=sender;
    NSLog(@"%d",sender);
    switch (sender) {
        case 3:
            
            _pickerArray=[[NSMutableArray alloc]initWithCapacity:1];
            for(int i=1;i<100;i++)
            {
                NSString *stringInt = [NSString stringWithFormat:@"%d",i];
                
                [_pickerArray addObject:stringInt];
            }
            break;
        case 4:
            _pickerArray=[[NSMutableArray alloc]initWithCapacity:1];
            for(int i=100;i<200;i++)
            {
                NSString *stringInt = [NSString stringWithFormat:@"%d",i];
                
                [_pickerArray addObject:stringInt];
            }
            break;
        case 5:
            _pickerArray=[[NSMutableArray alloc]initWithCapacity:1];
            for(int i=10;i<200;i++)
            {
                NSString *stringInt = [NSString stringWithFormat:@"%d",i];
                
                [_pickerArray addObject:stringInt];
            }
            break;
            
        default:
            break;
    }
    self.pickview.delegate=self;
    self.pickview.dataSource=self;
    
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
    _item=[_pickerArray objectAtIndex:row];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancle:(id)sender {
    NSLog(@"hgfrwsbfwe");
    [self.delegate cancelButtonClicked:self];
    
    
}

- (IBAction)ok:(id)sender {
    NSLog(@"...");
    if (self.delegate && [self.delegate respondsToSelector:@selector(okButtonClicked:item:sender:)]) {
        [self.delegate okButtonClicked:self item:_item sender:_buttonsender];
    }
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
