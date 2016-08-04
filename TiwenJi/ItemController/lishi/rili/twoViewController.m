//
//  twoViewController.m
//  Newthermometer
//
//  Created by 莫福见 on 16/2/22.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "twoViewController.h"
#import "JAYColor.h"
#import  "JAYChart.h"
#import "SVProgressHUD.h"
#define twoViewControllerdefine @"twoViewController"


@interface twoViewController ()<JAYChartDataSource>{
    BabyBluetooth*baby;
    JAYChart *_lineChartView;
    UILabel *_barValueLabel;
   
   
}
@property (nonatomic, retain) NSDate * curDate;
@property (nonatomic, retain) NSDateFormatter * formatter;
@property(nonatomic,strong)CBPeripheral*twoPeripheral;
@property(nonatomic,strong)CBCharacteristic*twoviewCharacteristic;
@end

@implementation twoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.curDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"dd/MM/yyyy --- HH:mm"];
   
    
    
    baby=[BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
    _lineChartView = [[JAYChart alloc]initwithJAYChartDataFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height*0.4-20, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-[UIScreen mainScreen].bounds.size.height*0.4-20)
                                                     withSource:self   withStyle:JAYChartLineStyle];
    
    
    
    _lineChartView.backgroundColor =  JAYWhite;
    _lineChartView.showRange = NO;
    [_lineChartView showInView:self.view];
    
 
    
    

}

-(void)viewWillAppear:(BOOL)animated{
  
    NSArray*arry=[baby findConnectedPeripherals];
    if (arry.count>0)
    {
        for (CBPeripheral*per in arry)
        {
            self.twoPeripheral=per;
            
        }
        
        [self tworeloaddataforbulettoh];
       
        
        
        
    }
    else
    {
     
        [SVProgressHUD showErrorWithStatus:@"未连接设备"];
      
    }

  
}
-(void)tworeloaddataforbulettoh{
    
    baby.having(self.twoPeripheral).and.channel(twoViewControllerdefine).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    
}
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    
    
    //设置扫描到设备的委托
    
    [baby setBlockOnDiscoverToPeripheralsAtChannel:twoViewControllerdefine block:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        
    }];
    
    [baby setBlockOnConnectedAtChannel:twoViewControllerdefine block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"two连接成功");
        
      
        
    }];
    
    [baby setBlockOnDiscoverCharacteristicsAtChannel:twoViewControllerdefine block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        //weakSelf.viewCharacteristic=[service.characteristics objectAtIndex:0];
        //NSLog(@"===viewCharacteristic:%@",service.characteristics);
        //插入row到tableview
        [weakSelf insertRowToTableView:service];
        
    }];
    
    
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:twoViewControllerdefine block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"two写入成功");
        
    }];
    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:twoViewControllerdefine block:^(CBCharacteristic *characteristic, NSError *error) {
        [weakSelf insertReadValues:characteristic];
        
    }];
    
    
}
#pragma mark 已连接的CBCharacteristic
-(void)insertRowToTableView:(CBService *)service{
    NSLog(@"[twoview.characteristics objectAtIndex:0]==%@",[service.characteristics objectAtIndex:0]);
    NSLog(@"[twoview.characteristics objectAtIndex:1]==%@",[service.characteristics lastObject]);
    self.twoviewCharacteristic=[service.characteristics objectAtIndex:0];
    [self setnotificationison];
    [self huoquwendu];
}
-(void)huoquwendu{
    unsigned char sendStr1[16];
    
    sendStr1[0] = 0xFC;
    sendStr1[1] = 0x06;
    sendStr1[2] = 0x00;
    sendStr1[3] = 0x00;
    sendStr1[4] = 0x00;
    sendStr1[5] = 0x00;
    sendStr1[6] = 0x00;
    sendStr1[7] = 0x00;
    sendStr1[8] = 0x00;
    sendStr1[9] = 0x00;
    sendStr1[10] = 0x00;
    sendStr1[11] = 0x00;
    sendStr1[12] = 0x00;
    sendStr1[13] = 0x00;
    sendStr1[14] = 0x00;
    sendStr1[15] = 0x00;
    
    
    
    
    NSData *data = [NSData dataWithBytes:sendStr1 length:16];
    [self.twoPeripheral writeValue:data forCharacteristic:self.twoviewCharacteristic type:CBCharacteristicWriteWithResponse];
    
    
    
//    unsigned char sendStr[16];
//    
//    sendStr[0] = 0xFC;
//    sendStr[1] = 0x06;
//    sendStr[2] = 0x00;
//    sendStr[3] = 0x00;
//    sendStr[4] = 0x00;
//    sendStr[5] = 0x00;
//    sendStr[6] = 0x00;
//    sendStr[7] = 0x00;
//    sendStr[8] = 0x00;
//    sendStr[9] = 0x00;
//    sendStr[10] = 0x00;
//    sendStr[11] = 0x00;
//    sendStr[12] = 0x00;
//    sendStr[13] = 0x00;
//    sendStr[14] = 0x00;
//    sendStr[15] = 0x00;
//    
//    
//    
//    
//    NSData *data2 = [NSData dataWithBytes:sendStr length:16];
//    [self.twoPeripheral writeValue:data2 forCharacteristic:self.twoviewCharacteristic type:CBCharacteristicWriteWithResponse];
    
    
    
}
#pragma mark  设置通知
-(void)setnotificationison{
    
    
    [baby notify:self.twoPeripheral
  characteristic:self.twoviewCharacteristic
           block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
               NSLog(@"设置通知success");
               [self insertReadValues:characteristics];
               
           }];
}
-(void)insertReadValues:(CBCharacteristic *)characteristics{
    NSLog(@"characteristics.value=%@",characteristics.value);
    //NSLog(@"self.viewCharacteristic.value=%@",self.twoviewCharacteristic);
    
//    const unsigned char *hexBytesLight = [characteristics.value bytes];
//    NSString *battery = [NSString stringWithFormat:@"%02x", hexBytesLight[13]];
//    NSString *battery2 = [NSString stringWithFormat:@"%02x", hexBytesLight[14]];
//    int zhengshu = 0;
//    int xiaoshu = 0;
//    for(int i=0;i<[battery length];i++)
//    {
//        /// 两位16进制数转化后的10进制数
//        
//        unichar hex_char1 = [battery characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
//        int int_ch1;
//        if(hex_char1 >= '0' && hex_char1 <='9')
//            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
//        else if(hex_char1 >= 'A' && hex_char1 <='F')
//            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
//        else
//            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
//        i++;
//        
//        unichar hex_char2 = [battery characterAtIndex:i]; ///两位16进制数中的第二位(低位)
//        int int_ch2;
//        if(hex_char2 >= '0' && hex_char2 <='9')
//            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
//        else if(hex_char1 >= 'A' && hex_char1 <='F')
//            int_ch2 = hex_char2-55; //// A 的Ascll - 65
//        else
//            int_ch2 = hex_char2-87; //// a 的Ascll - 97
//        
//        zhengshu = int_ch1+int_ch2;
//        NSLog(@"温度整数部分=%d",zhengshu);
//        
//    }
//    
//    
//    
//    for(int i=0;i<[battery2 length];i++)
//    {
//        /// 两位16进制数转化后的10进制数
//        
//        unichar hex_char1 = [battery2 characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
//        int int_ch1;
//        if(hex_char1 >= '0' && hex_char1 <='9')
//            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
//        else if(hex_char1 >= 'A' && hex_char1 <='F')
//            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
//        else
//            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
//        i++;
//        
//        unichar hex_char2 = [battery2 characterAtIndex:i]; ///两位16进制数中的第二位(低位)
//        int int_ch2;
//        if(hex_char2 >= '0' && hex_char2 <='9')
//            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
//        else if(hex_char1 >= 'A' && hex_char1 <='F')
//            int_ch2 = hex_char2-55; //// A 的Ascll - 65
//        else
//            int_ch2 = hex_char2-87; //// a 的Ascll - 97
//        
//        xiaoshu = int_ch1+int_ch2;
//        NSLog(@"温度整数部分=%d",xiaoshu);
//        
//    }
//    NSString *shengshustr=[NSString stringWithFormat:@"%d",zhengshu];
//    NSString*dian=@".";
//    NSString*newstr=[shengshustr stringByAppendingString:dian];
//    
//    NSString*xiaoshustr=[NSString stringWithFormat:@"%d",xiaoshu];
}


//横坐标标题数组
- (NSArray *)JAYChart_xLableArray:(JAYChart *)chart
{
    
    NSMutableArray *abc=[NSMutableArray arrayWithObjects:@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff",@"fff", nil];
    return abc;
}

//数值多重数组
- (NSArray *)JAYChart_yValueArray:(JAYChart *)chart
{
    NSLog(@"-----------");
        NSArray *ary = @[@29.5,@38,@35,@39,@"32",@"30",@"31",@"30",@"38",@"32",@"32",@"36"];
   // NSArray *ary=_mutableArrsy;
    //        NSArray  *yValues = _mutableArrsy;//1组数据
    NSArray  *yValues = @[ary];//2组数据
    
    return yValues;
    _lineChartView=nil;
    
    
}

//设置Y轴需要显示的数值范围，最大值-最小值
- (CGRange)JAYChartChooseRangeInLineChart:(JAYChart *)chart
{
    //这里设置的是需要正常显示的范围,即最大值最小值
    return CGRangeMake(42, 20);
}
//2组数值区域
- (JAYGroupRange)JAYGroupChartMarkRangeInLineChart:(JAYChart *)chart
{
    CGRange range1 = CGRangeMake(42, 36.50);
    CGRange range2 = CGRangeMake(36, 30);
    return JAYGroupRangeMake(range1, range2);
    
}

//设置正常范围需要渲染的背景
- (CGRange)JAYChartMarkRangeInLineChart:(JAYChart *)chart
{
    return CGRangeMake(42, 36.6);
}

//设置多组数据不同柱状条颜色
- (NSArray *)JAYChart_ColorArray:(JAYChart *)chart
{
    return @[JAYBrown ,JAYBlue];
}


//判断显示横线条
- (BOOL)JAYChart:(JAYChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.imageH.constant=[UIScreen mainScreen].bounds.size.height*0.2;
    self.imageW.constant=[UIScreen mainScreen].bounds.size.height*0.2;

  
}
- (IBAction)gotoDateView:(id)sender {
    if(!self.datePicker)
        self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.date = self.curDate;
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setAutoCloseOnSelectDate:YES];
    [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    
    //    [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
    //     int tmp = (arc4random() % 30)+1;
    //     if(tmp % 5 == 0)
    //     return YES;
    //     return NO;
    //     }];
    //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(1.0),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                  }];
}

if(!self.datePicker)
self.datePicker = [THDatePickerViewController datePicker];
self.datePicker.date = self.curDate;
self.datePicker.delegate = self;
[self.datePicker setAllowClearDate:NO];
[self.datePicker setAutoCloseOnSelectDate:YES];
[self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
[self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];

//    [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
//     int tmp = (arc4random() % 30)+1;
//     if(tmp % 5 == 0)
//     return YES;
//     return NO;
//     }];
//[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
[self presentSemiViewController:self.datePicker withOptions:@{
                                                              KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                              KNSemiModalOptionKeys.animationDuration : @(1.0),
                                                              KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                              }];
}
- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    self.curDate = datePicker.date;
   
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}

- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate {
    NSLog(@"Date selected: %@",[_formatter stringFromDate:selectedDate]);
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
