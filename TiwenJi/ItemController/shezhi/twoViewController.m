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
    _lineChartView.dotRadius = 1.5;
    _lineChartView.oppositeY = NO;
    _lineChartView.dataSource = self;
    _lineChartView.delegate = self;
    _lineChartView.minValue = @0;
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
    UIButton *loginHistoryButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 50, self.view.center.y + 50, 100, 50)];
    loginHistoryButton.backgroundColor = [UIColor redColor];
    [loginHistoryButton setTitle:@"载入历史" forState:UIControlStateNormal];
    [loginHistoryButton addTarget:self action:@selector(loginHistory:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginHistoryButton];
    [self.view bringSubviewToFront:loginHistoryButton];
    
    NSLog(@"viewDidLoad");
    self.curDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"YYYYMMdd"];
    
    _today=[[NSMutableArray alloc]init];
    [self coredatachaozao];
}

- (void)loginHistory:(UIButton *)sender
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSString *string_day_time = [formatter stringFromDate:date] ;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
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
        });
        
    });
    
    [sender setHidden:YES];
}

-(void)coredatachaozao{
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Test" inManagedObjectContext:self.myappdelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor*sort=[[NSSortDescriptor alloc]initWithKey:@"shijian" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]
                                initWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError * requestError = nil;
    NSArray * shuzu = [self.myappdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    //NSLog(@"shuzu=%@",shuzu);
    
    //判断日期是否和shijian中的前八个是否存在于today中，如果不存在，就添加该日期
    for (Test*pp in shuzu) {
        NSLog( @"pp.shijian=%@",pp.shijian);
        if (![_today containsObject:[pp.shijian substringToIndex:8]]) {
            [_today addObject:[pp.shijian substringToIndex:8]];
        }
        
    }
    NSLog(@"_today=%@",_today);
    
    _zhongjian=_today.count -1;
    
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
    return _dataSource[index];
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

-(void)viewWillAppear:(BOOL)animated{
    
 NSLog(@"viewWillAppear");
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSString *string_day_time = [formatter stringFromDate:date] ;
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        // 处理耗时操作的代码块...
//        [self chazhao:string_day_time];
//        //通知主线程刷新
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //回调或者说是通知主线程刷新，
//            self.labelText.text=_zuida;
//            //刷新图表数据
//            [_lineChartView reloadData];
//            [_lineChartView reloadDataWithAnimate:NO];
//        });
//    });
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
                
                //将person的历史温度数据放到dataSource数据源中
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"00"]]) {
//                    [_dataSource replaceObjectAtIndex:24 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"01"]]) {
//                    [_dataSource replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"02"]]) {
//                    [_dataSource replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"03"]]) {
//                    [_dataSource replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"04"]]) {
//                    [_dataSource replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"05"]]) {
//                    [_dataSource replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"06"]]) {
//                    [_dataSource replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"07"]]) {
//                    [_dataSource replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"08"]]) {
//                    [_dataSource replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"09"]]) {
//                    [_dataSource replaceObjectAtIndex:8 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"10"]]) {
//                    [_dataSource replaceObjectAtIndex:9 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"11"]]) {
//                    [_dataSource replaceObjectAtIndex:10 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"12"]]) {
//                    [_dataSource replaceObjectAtIndex:11 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"13"]]) {
//                    [_dataSource replaceObjectAtIndex:12 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"14"]]) {
//                    [_dataSource replaceObjectAtIndex:13 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"15"]]) {
//                    [_dataSource replaceObjectAtIndex:14 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"16"]]) {
//                    [_dataSource replaceObjectAtIndex:15 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"17"]]) {
//                    [_dataSource replaceObjectAtIndex:16 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"18"]]) {
//                    [_dataSource replaceObjectAtIndex:17 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"19"]]) {
//                    [_dataSource replaceObjectAtIndex:18 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"20"]]) {
//                    [_dataSource replaceObjectAtIndex:19 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"21"]]) {
//                    [_dataSource replaceObjectAtIndex:20 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"22"]]) {
//                    [_dataSource replaceObjectAtIndex:21 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
//                if ([pp.shijian isEqualToString:[string_day_time stringByAppendingString:@"23"]]) {
//                    [_dataSource replaceObjectAtIndex:22 withObject:[NSString stringWithFormat:@"%@",pp.wendu]];
//                }
                
                
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
- (IBAction)todayButtonAction:(id)sender {
    [self.todayButton setTitle:@"今天" forState:0];
  
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSString *string_day_time = [formatter stringFromDate:date] ;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
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
                    });
                    
                });
                
                
            }else if (_zhongjian<0){
                _zhongjian ++;
                [SVProgressHUD showImage:[UIImage imageNamed:@"user_warning"] status:@"到顶了！"];
                self.zuoButton.enabled=NO;
            }
    }
    else{
        [SVProgressHUD showImage:[UIImage imageNamed:@"user_warning"] status:@"没有历史数据"];
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
            NSString*day=[[_today objectAtIndex:_zhongjian]substringWithRange:NSMakeRange(6,2)];;
            NSLog(@"%@-%@-%@",yesr,month,day);
            NSString*dstr=[[[[yesr stringByAppendingString:@"-"] stringByAppendingString:month] stringByAppendingString:@"-"] stringByAppendingString:day];
            [self.todayButton setTitle:dstr forState:0];
              [self chazhao:[_today objectAtIndex:_zhongjian]];
            NSLog(@"%@",_today[_zhongjian]);
            
            [self.todayButton setTitle:dstr forState:0];
            
            //                [self chazhao:[_today objectAtIndex:_zhongjian]];
            NSLog(@"33333%@",_today[_zhongjian]);
            
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
    
    [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
        __weak typeof(self) weakSelf = self;
        
      
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
-(void)datePickerDonePressed:(THDatePickerViewController *)datePicker{
    self.curDate = datePicker.date;
     NSLog(@"%@",[_formatter stringFromDate:_curDate]);
    [_todayButton setTitle:[_formatter2 stringFromDate:_curDate] forState:0];
    [self chazhao:[_formatter stringFromDate:_curDate]];
   
    
    [self dismissSemiModalView];
}

-(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker{
    //[self.datePicker slideDownAndOut];
    [self dismissSemiModalView];
}





@end
