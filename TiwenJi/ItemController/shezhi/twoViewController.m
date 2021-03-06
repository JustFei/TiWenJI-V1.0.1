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
#import "Test.h"
#import "MCLineChartView.h"
#import "AppDelegate.h"
#import "THDatePickerViewController.h"

@interface twoViewController () <MCLineChartViewDataSource, MCLineChartViewDelegate>{
    BabyBluetooth*baby;
    NSMutableArray*timeArray;
}
@property (nonatomic, strong) UIButton *loginHistoryButton;
@property (nonatomic, retain) NSDate * curDate;
@property (nonatomic, retain) NSDateFormatter * formatter;
@property (nonatomic, retain) NSDateFormatter * formatter2;
@property(nonatomic,strong)CBPeripheral*twoPeripheral;
@property(nonatomic,strong)CBCharacteristic*twoviewCharacteristic;
@property(nonatomic ,strong)AppDelegate*myappdelegate;
@property(nonatomic,strong)NSMutableArray*riqi;
@property(nonatomic,strong)NSMutableArray*wd;
@property (strong, nonatomic) MCLineChartView *lineChartView;

//横轴坐标显示
//@property (strong, nonatomic) NSArray *titles;
@property (nonatomic ,strong) NSMutableArray *titles;

//数据源
@property (strong, nonatomic) NSMutableArray *dataSource;
//有温度的天数的数组，直到今天为止
@property (strong, nonatomic) NSMutableArray*today;
//最大温度
@property (strong, nonatomic)NSString*zuida;
@property(nonatomic,assign)int zhongjian;

@end

@implementation twoViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    timeArray=[[NSMutableArray alloc]init];
    NSLog(@"viewDidLoad");
    
    //禁用所有按钮点击
    self.todayButton.enabled = NO;
    self.zuoButton.enabled = NO;
    self.youButton.enabled = NO;
    
    _zuida=@"20";
    self.curDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"YYYYMMdd"];
    self.formatter2 = [[NSDateFormatter alloc] init];
    [_formatter2 setDateFormat:@"YYYY-MM-dd"];
    
    self.myappdelegate=[UIApplication sharedApplication].delegate;
    baby=[BabyBluetooth shareBabyBluetooth];
    //[self babyDelegate];

    _dataSource = [NSMutableArray array];
    
    _lineChartView = [[MCLineChartView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height*0.5 - 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*0.5 - 30)];
    _lineChartView.dotRadius = 3.0;
    _lineChartView.oppositeY = NO;
    _lineChartView.dataSource = self;
    _lineChartView.delegate = self;
    _lineChartView.minValue = @30;
    _lineChartView.maxValue = @43;
    _lineChartView.solidDot = YES;
    _lineChartView.numberOfYAxis = 10;
    _lineChartView.colorOfXAxis = [UIColor whiteColor];
    _lineChartView.colorOfXText = [UIColor whiteColor];
    _lineChartView.colorOfYAxis = [UIColor whiteColor];
    _lineChartView.colorOfYText = [UIColor whiteColor];
    
    [self.view addSubview:_lineChartView];
    
    [_lineChartView reloadDataWithAnimate:NO];
    
    //载入历史记录的button
    _loginHistoryButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 50, self.view.center.y + 50, 100, 50)];
    _loginHistoryButton.backgroundColor = [UIColor clearColor];
    [[_loginHistoryButton layer] setBorderWidth:1.0f];
    _loginHistoryButton.layer.cornerRadius = 25;
    [[_loginHistoryButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [_loginHistoryButton setTitle:NSLocalizedString(@"HistoryLoad", nil) forState:UIControlStateNormal];
    _loginHistoryButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_loginHistoryButton addTarget:self action:@selector(loginHistory:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginHistoryButton];
    [self.view bringSubviewToFront:_loginHistoryButton];
    
    NSLog(@"viewDidLoad");
    self.curDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"YYYYMMdd"];

}

//在
-(void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        _today = nil;
        _today=[[NSMutableArray alloc]init];
        [self coredatachaozao];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
}

- (void)loginHistory:(UIButton *)sender
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSString *string_day_time = [formatter stringFromDate:date] ;
    
    [SVProgressHUD show];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        _today = nil;
        _today=[[NSMutableArray alloc]init];
        [self coredatachaozao];
        
        [self chazhao:string_day_time];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSString*p in _dataSource) {
                if( [_zuida floatValue]<[p floatValue]){
                    _zuida=p;
                }
            }
            self.labelText.text=_zuida;
            //回调或者说是通知主线程刷新，
            [_lineChartView reloadData];
            [_lineChartView reloadDataWithAnimate:NO];
            
            [SVProgressHUD dismiss];
            
        });
        
    });
    
    self.todayButton.enabled = YES;
    self.zuoButton.enabled = YES;
    self.youButton.enabled = YES;
    
    [sender setHidden:YES];
}

-(void)coredatachaozao{

    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"suername"];
    
    if (username) {
        
        NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
        //实体描述，即表明为Test，
        NSEntityDescription * entity = [NSEntityDescription entityForName:@"Test" inManagedObjectContext:self.myappdelegate.managedObjectContext];
        //给这个命令指定一个表：Test
        [fetchRequest setEntity:entity];
        //谓词
        
        NSPredicate * agePre = [NSPredicate predicateWithFormat:@"name like[cd] %@",username];
        //给命令具体执行内容，内容为查找，查找 name为沙盒中存储的suername
        [fetchRequest setPredicate:agePre];
        NSError * requestError = nil;
        //执行这个命令，获得结果persons
        NSArray * persons = [self.myappdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
        
        //判断日期是否和shijian中的前八个是否存在于today中，如果不存在，就添加该日期
        for (Test*pp in persons) {
            NSLog( @"pp.shijian=%@",pp.shijian);
            //如果是当前用户名的话
            if ([pp.name isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"suername"]]) {
                if (![_today containsObject:[pp.shijian substringToIndex:8]]) {
                    [_today addObject:[pp.shijian substringToIndex:8]];
                }
            }
            
            
        }
        NSLog(@"_today=%@",_today);
        
        _zhongjian=_today.count -1;
    }
}

//在折线图视图的行数
- (NSUInteger)numberOfLinesInLineChartView:(MCLineChartView *)lineChartView {
    return 1;
}

//24个小时，x坐标数量
- (NSUInteger)lineChartView:(MCLineChartView *)lineChartView lineCountAtLineNumber:(NSInteger)number {
    return [_dataSource count];
}

//每个坐标的值
- (id)lineChartView:(MCLineChartView *)lineChartView valueAtLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    
    float Tvalue = [_dataSource[index] floatValue];
    
    if (Tvalue > 30) {
        return _dataSource[index];
    }else {
        return @30;
    }
}

//横坐标的坐标值：时间
- (NSString *)lineChartView:(MCLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number {
    return _titles[number];
}

//折线颜色
- (UIColor *)lineChartView:(MCLineChartView *)lineChartView lineColorWithLineNumber:(NSInteger)lineNumber {
    if (lineNumber == 0) {
        return [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:1.0];
    } else if (lineNumber == 1) {
        return [UIColor lightGrayColor];
    } else if (lineNumber == 2) {
        return [UIColor redColor];
    } else {
        return [UIColor yellowColor];
    }
}

//折线上点的提示框的值
- (NSString *)lineChartView:(MCLineChartView *)lineChartView informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    
    return [NSString stringWithFormat:@"%@°C", _dataSource[index]];
}

//查找数据
-(void)chazhao:(NSString*)string{
    NSString*string_day_time=string;
    
    //先清空数据源
    _titles = nil;
    _dataSource=nil;
    _titles = [NSMutableArray array];
    _dataSource = [[NSMutableArray alloc] init];
    _zuida=@"0°C";
    
    //从沙盒中获取到最大温度，可换成从数据库获取来的温度数据
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"suername"])
    {
        //CoreData请求命令集
        NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
        //实体描述，即表明为Test，
        NSEntityDescription * entity = [NSEntityDescription entityForName:@"Test" inManagedObjectContext:self.myappdelegate.managedObjectContext];
        //给这个命令指定一个表：Test
        [fetchRequest setEntity:entity];
        //谓词
        NSPredicate * agePre = [NSPredicate predicateWithFormat:@"name like[cd] %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"suername"]];
        //给命令具体执行内容，内容为查找，查找 name为沙盒中存储的suername
        [fetchRequest setPredicate:agePre];
        NSError * requestError = nil;
        //执行这个命令，获得结果persons
        NSArray * persons = [self.myappdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
        NSLog(@"persons == %@, count = %lu",persons ,(unsigned long)persons.count);
        
        if ([persons count]>0)
        {
            for (Test*pp in persons)
                
            {
                /**
                 *  这一步操作是将当天的温度以及时间添加到数据源中
                 *  YYYYMMdd
                 */
                if ([[pp.shijian substringToIndex:8] isEqualToString:string_day_time]) {
                    NSLog(@"pp.shijian == %@",pp.shijian);//201608091423
                    NSString *hh = [pp.shijian substringWithRange:NSMakeRange(8, 2)];
                    NSString *mm = [pp.shijian substringWithRange:NSMakeRange(10, 2)];
                    [_titles addObject:[NSString stringWithFormat:@"%@:%@",hh ,mm]];
                    
                    NSLog(@"存储的温度数据 == %@",pp.wendu);
                    [_dataSource addObject:pp.wendu];
                }
            }
        }
   
        NSLog(@"_titles个数 = %ld",(unsigned long)_titles.count);
        NSLog(@"_dataSource个数 = %ld",(unsigned long)_dataSource.count);
        
        //刷新图表数据
//        [_lineChartView reloadData];
//        [_lineChartView reloadDataWithAnimate:NO];
        
        //获取到最大温度
        for (NSString*p in _dataSource) {
            if( [_zuida floatValue]<[p floatValue]){
                _zuida=p;
            }
        }
//        self.labelText.text=_zuida;
    }
    else
    {
        NSLog(@"没有数据");
        
    }
}

//今天的按钮事件
- (IBAction)todayButtonAction:(UIButton *)sender {
//    [self.todayButton setTitle:@"今天" forState:0];
  

    
    NSString *todayStr = sender.titleLabel.text;
    NSLog(@"%@",todayStr);
    NSString *caozuoStr;
    NSLog(NSLocalizedString(@"TodayButton", nil));
    
    if ([todayStr isEqualToString:NSLocalizedString(@"TodayButton", nil)]) {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYYMMdd"];
            NSString *string_day_time = [formatter stringFromDate:date];
        caozuoStr = string_day_time;
    }else {
        NSMutableString *mutTodayStr = [NSMutableString stringWithString:todayStr];
        NSString *string_day_time = [mutTodayStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        caozuoStr = string_day_time;
    }
    
    NSLog(@"%@",caozuoStr);
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        [self chazhao:caozuoStr];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSString*p in _dataSource) {
                if( [_zuida floatValue]<[p floatValue]){
                    _zuida=p;
                }
            }
            self.labelText.text=_zuida;
            //回调或者说是通知主线程刷新，
            [_lineChartView reloadData];
            [_lineChartView reloadDataWithAnimate:NO];
            
            [SVProgressHUD dismiss];
            
        });
        
    });
    
}

//前一天的数据
- (IBAction)zuo:(id)sender {
    if (_today.count>0)
    {
        
            self.youButton.enabled=YES;
        
        NSLog(@"11111%d",_zhongjian);
            _zhongjian--;
        NSLog(@"22222%d",_zhongjian);
            if (_zhongjian>=0)
            {
                NSString*yesr=[[_today objectAtIndex:_zhongjian]substringWithRange:NSMakeRange(0,4)];
                NSString*month=[[_today objectAtIndex:_zhongjian]substringWithRange:NSMakeRange(4,2)];
                NSString*day=[[_today objectAtIndex:_zhongjian]substringWithRange:NSMakeRange(6,2)];;
                NSLog(@"%@-%@-%@",yesr,month,day);
                NSString*dstr=[[[[yesr stringByAppendingString:@"-"] stringByAppendingString:month] stringByAppendingString:@"-"] stringByAppendingString:day];
                
                [self.todayButton setTitle:dstr forState:0];
                
                
//                [self chazhao:[_today objectAtIndex:_zhongjian]];
                NSLog(@"33333%@",_today[_zhongjian]);
                
                [SVProgressHUD show];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    // 处理耗时操作的代码块...
                    [self chazhao:[_today objectAtIndex:_zhongjian]];
                    //通知主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        for (NSString*p in _dataSource) {
                            if( [_zuida floatValue]<[p floatValue]){
                                _zuida=p;
                            }
                        }
                        self.labelText.text=_zuida;
                        [_lineChartView reloadData];
                        [_lineChartView reloadDataWithAnimate:NO];
                        [SVProgressHUD dismiss];
                    });
                    
                });
                
                
            }else if (_zhongjian<0){
                _zhongjian ++;
                [SVProgressHUD showImage:[UIImage imageNamed:@"user_warning"] status:NSLocalizedString(@"It's Top", nil)];
                self.zuoButton.enabled=NO;
            }
    }
    else{
        [SVProgressHUD showImage:[UIImage imageNamed:@"user_warning"] status:NSLocalizedString(@"NoMore", nil)];
    }
    
}

//后一天的数据
- (IBAction)you:(id)sender {
    if (_today.count>0)
    {
        
        self.zuoButton.enabled=YES;
        NSLog(@"%d",_zhongjian);
        _zhongjian++;
        if (_zhongjian<_today.count)
        {
            NSString*yesr=[[_today objectAtIndex:_zhongjian]substringWithRange:NSMakeRange(0,4)];
            NSString*month=[[_today objectAtIndex:_zhongjian]substringWithRange:NSMakeRange(4,2)];
            NSString*day=[[_today objectAtIndex:_zhongjian]substringWithRange:NSMakeRange(6,2)];
            
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYYMMdd"];
            NSString *string_day_time = [formatter stringFromDate:date];
            
            
            if ([[NSString stringWithFormat:@"%@%@%@",yesr,month,day] isEqualToString:string_day_time]) {
                [self.todayButton setTitle:NSLocalizedString(@"TodayButton", nil) forState:0];
            } else {
            NSLog(@"%@-%@-%@",yesr,month,day);
            NSString*dstr=[[[[yesr stringByAppendingString:@"-"] stringByAppendingString:month] stringByAppendingString:@"-"] stringByAppendingString:day];
            [self.todayButton setTitle:dstr forState:0];
            }
            NSLog(@"33333%@",_today[_zhongjian]);
            
            
            [SVProgressHUD show];
            //分线程获取数据，结束后刷新UI
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 处理耗时操作的代码块...
                [self chazhao:[_today objectAtIndex:_zhongjian]];
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    
                    for (NSString*p in _dataSource) {
                        if( [_zuida floatValue]<[p floatValue]){
                            _zuida=p;
                        }
                    }
                    self.labelText.text=_zuida;
                    
                    [_lineChartView reloadData];
                    [_lineChartView reloadDataWithAnimate:NO];
                    
                    [SVProgressHUD dismiss];
                });
                
            });
            
            
            
        }else if (_zhongjian==_today.count)
        {
            _zhongjian --;
            [SVProgressHUD showImage:[UIImage imageNamed:@"user_warning"] status:@"到顶了！"];
            self.youButton.enabled=NO;
            
        }
    }
    else
    {
        [SVProgressHUD showImage:[UIImage imageNamed:@"user_warning"] status:@"没有历史数据"];
    }
}

//
//-(void)tworeloaddataforbulettoh{
//    
//    baby.having(self.twoPeripheral).and.channel(twoViewControllerdefine).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
//    
//}
//-(void)babyDelegate{
//    
//    __weak typeof(self) weakSelf = self;
//    
//    
//    //设置扫描到设备的委托
//    
//    [baby setBlockOnDiscoverToPeripheralsAtChannel:twoViewControllerdefine block:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
//        
//    }];
//    
//    [baby setBlockOnConnectedAtChannel:twoViewControllerdefine block:^(CBCentralManager *central, CBPeripheral *peripheral) {
//        NSLog(@"two连接成功");
//        
//        
//        
//    }];
//    
//    [baby setBlockOnDiscoverCharacteristicsAtChannel:twoViewControllerdefine block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
//        //weakSelf.viewCharacteristic=[service.characteristics objectAtIndex:0];
//        //NSLog(@"===viewCharacteristic:%@",service.characteristics);
//        //插入row到tableview
//        [weakSelf insertRowToTableView:service];
//        
//    }];
//    
//    
//    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:twoViewControllerdefine block:^(CBCharacteristic *characteristic, NSError *error) {
//        NSLog(@"two写入成功");
//        
//    }];
//    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:twoViewControllerdefine block:^(CBCharacteristic *characteristic, NSError *error) {
//        [weakSelf insertReadValues:characteristic];
//        
//    }];
//    
//    
//}
//#pragma mark 已连接的CBCharacteristic
//-(void)insertRowToTableView:(CBService *)service{
//    NSLog(@"[twoview.characteristics objectAtIndex:0]==%@",[service.characteristics objectAtIndex:0]);
//    NSLog(@"[twoview.characteristics objectAtIndex:1]==%@",[service.characteristics lastObject]);
//    self.twoviewCharacteristic=[service.characteristics objectAtIndex:0];
//    [self setnotificationison];
//    [self huoquwendu];
//}
//-(void)huoquwendu{
//    unsigned char sendStr1[16];
//    
//    sendStr1[0] = 0xFC;
//    sendStr1[1] = 0x06;
//    sendStr1[2] = 0x00;
//    sendStr1[3] = 0x00;
//    sendStr1[4] = 0x00;
//    sendStr1[5] = 0x00;
//    sendStr1[6] = 0x00;
//    sendStr1[7] = 0x00;
//    sendStr1[8] = 0x00;
//    sendStr1[9] = 0x00;
//    sendStr1[10] = 0x00;
//    sendStr1[11] = 0x00;
//    sendStr1[12] = 0x00;
//    sendStr1[13] = 0x00;
//    sendStr1[14] = 0x00;
//    sendStr1[15] = 0x00;
//    
//    
//    
//    
//    NSData *data = [NSData dataWithBytes:sendStr1 length:16];
//    [self.twoPeripheral writeValue:data forCharacteristic:self.twoviewCharacteristic type:CBCharacteristicWriteWithResponse];
//    
//
//    
//}
//#pragma mark  设置通知
//-(void)setnotificationison{
//    
//    
//    [baby notify:self.twoPeripheral
//  characteristic:self.twoviewCharacteristic
//           block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//               NSLog(@"设置通知success");
//               [self insertReadValues:characteristics];
//               
//           }];
//}
//-(void)insertReadValues:(CBCharacteristic *)characteristics{
//    NSLog(@"characteristics.value=%@",characteristics.value);
//    
//}


//}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.imageH.constant=[UIScreen mainScreen].bounds.size.height*0.28;
    self.imageW.constant=[UIScreen mainScreen].bounds.size.height*0.28;
    self.labelH.constant=[UIScreen mainScreen].bounds.size.height*0.28;
    self.labelW.constant=[UIScreen mainScreen].bounds.size.height*0.28;
    self.label2H.constant=[UIScreen mainScreen].bounds.size.height*0.28;
    self.label2W.constant=[UIScreen mainScreen].bounds.size.height*0.3*0.5;
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
    [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    __weak typeof(self) weakSelf = self;
    [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        NSString *strDate = [dateFormatter stringFromDate:date];
        
        return [weakSelf.today containsObject:strDate];
    }];
    
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(1.0),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                  }];
}

//在日历上选择日期的话，刷新当前天数的日期和数据
-(void)datePickerDonePressed:(THDatePickerViewController *)datePicker{
    
    if ([_today containsObject:[_formatter stringFromDate: datePicker.date]]) {
        self.curDate = datePicker.date;
        NSLog(@"%@",[_formatter stringFromDate:_curDate]);
        [_todayButton setTitle:[_formatter2 stringFromDate:_curDate] forState:0];
        
        [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            [self chazhao:[_formatter stringFromDate:_curDate]];
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                for (NSString*p in _dataSource) {
                    if( [_zuida floatValue]<[p floatValue]){
                        _zuida=p;
                    }
                }
                self.labelText.text=_zuida;
                //回调或者说是通知主线程刷新，
                [_lineChartView reloadData];
                [_lineChartView reloadDataWithAnimate:NO];
                
                [SVProgressHUD dismiss];
            });
        });
        
        [self.loginHistoryButton setHidden:YES];
        
        self.todayButton.enabled = YES;
        self.zuoButton.enabled = YES;
        self.youButton.enabled = YES;
        
        [self dismissSemiModalView];
    } else {
        UIAlertView *selectWorngDateView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hint", nil) message:NSLocalizedString(@"WorngDatePick", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [selectWorngDateView show];
    }
    
    
}

-(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker{
    //[self.datePicker slideDownAndOut];
    [self dismissSemiModalView];
}





@end
