//
//  oneViewController.m
//  Newthermometer
//
//  Created by 莫福见 on 16/2/22.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "oneViewController.h"
#import "wenduchuli.h"
#import "JAYColor.h"
#import  "JAYChart.h"
#import "SVProgressHUD.h"
#define channelOnPeropheralView @"FistViewController"
#import "AppDelegate.h"
#import "Test.h"
#import <AudioToolbox/AudioToolbox.h>
#import "TabBarViewController.h"
#import "gaowenbaojinView.h"
#import "UIViewController+MJPopupViewController.h"
#import "diwenbaojingView.h"


@interface oneViewController ()<MJSecondPopupDelegate,dwbjViewPopupDelegate>{
    gaowenbaojinView*secondDetailViewController;
    diwenbaojingView*dwViewController;
}

@property(nonatomic,strong)CBPeripheral*Peripheral;
@property(nonatomic,strong)CBCharacteristic*viewCharacteristic;
@property(nonatomic,strong)NSTimer*reconnectTimer;
@property(nonatomic,strong)NSString*wendu;
@property(nonatomic,strong)NSTimer*reconnectblurtooth;
@property(nonatomic,strong)NSTimer*chongliangTimer;
@property(nonatomic,strong)NSTimer*GbaojingTimer;
@property(nonatomic,strong)NSTimer*Gdaoji;
@property(nonatomic,strong)NSTimer*DbaojingTimer;
@property(nonatomic,strong)NSTimer*Ddaoji;
@property(nonatomic,strong)NSTimer*xianshidaojishi;
@property(nonatomic,strong)NSMutableArray*mutableArrsy;
@property(nonatomic ,strong)AppDelegate*myappdelegate2;
@property(nonatomic ,assign)BOOL Gbiao;
@property(nonatomic ,assign)BOOL Dbiao;
@property(nonatomic ,assign)int Gdaojishi;
@property(nonatomic ,assign)int Ddaojishi;
@property(nonatomic ,assign)int xianshidaojishiTime;
@property(nonatomic ,strong)NSUserDefaults*user;
@property(nonatomic ,strong) wenduchuli *wenduchuli;
@property(nonatomic ,strong)NSString*wen;



@property (nonatomic, weak) JAYLineChart * lineChart;
@end

@implementation oneViewController

- (void)viewDidLoad {
    NSLog(@"oneviewDidLoad");

   
    [super viewDidLoad];
    self.myappdelegate2=[UIApplication sharedApplication].delegate;
    _xianshidaojishiTime=15;
    _wenduchuli=[[wenduchuli alloc]init];
    _mutableArrsy=[[NSMutableArray alloc]init];
   
     babycao=[BabyBluetooth shareBabyBluetooth];
    [self babyDelegate1];
    _webview.delegate = self;
    _webview.scalesPageToFit = YES;
    _webview.opaque = NO;
    _webview.backgroundColor = [UIColor clearColor];
    _webview.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    
    //所有的资源都在source.bundle这个文件夹里
    NSString* htmlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"source.bundle/index.html"];
    
    NSURL* url = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webview loadRequest:request];
    
    _user=[NSUserDefaults standardUserDefaults];
    _wendu=@"19.00";
    
    _Gdaojishi=[[_user stringForKey:@"baojingjiege"] intValue]*60 ;
     _Ddaojishi=[[_user stringForKey:@"baojingjiege"] intValue]*60 ;
    
    //[self time];
    
}

#pragma mark - 高低温报警
-(void)time{
    NSLog(@"%ld",(long)self.Peripheral.state);
    if (self.Peripheral.state!=0) {
        
        
        _Gbiao = [[NSUserDefaults standardUserDefaults] boolForKey:@"Gswitch"]?YES:NO;
        _Dbiao = [[NSUserDefaults standardUserDefaults] boolForKey:@"Dswitch"]?YES:NO;
        
        
        if (![self.GbaojingTimer isValid]) {
            self.GbaojingTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(Gbaojing) userInfo:nil repeats:YES];
        }
        
        if (![self.DbaojingTimer isValid]) {
            self.DbaojingTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(Dbaojing) userInfo:nil repeats:YES];
        }
    }
}


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"oneviewWillAppear");

//    if (self.Peripheral.state == 0) {
        [self lianjie];
//    }

}

-(void)viewDidAppear:(BOOL)animated{
    
    
    NSLog(@"oneviewDidAppear");
    NSLog(@"%ld",(long)self.Peripheral.state);
    if (self.Peripheral.state!=0) {
        
        
        _Gbiao = [[NSUserDefaults standardUserDefaults] boolForKey:@"Gswitch"]?YES:NO;
        _Dbiao = [[NSUserDefaults standardUserDefaults] boolForKey:@"Dswitch"]?YES:NO;
        
        
        if (![self.GbaojingTimer isValid]) {
            self.GbaojingTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(Gbaojing) userInfo:nil repeats:YES];
        }
        
        if (![self.DbaojingTimer isValid]) {
            self.DbaojingTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(Dbaojing) userInfo:nil repeats:YES];
        }
    }
   
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"oneviewWillDisappear");
    [self.GbaojingTimer invalidate];
    self.GbaojingTimer=nil;
    [self.DbaojingTimer invalidate];
    self.DbaojingTimer=nil;
    [_Gdaoji invalidate];
    _Gdaoji=nil;
    [_Ddaoji invalidate];
    _Ddaoji=nil;
    
    
}


-(void)lianjie{
    NSArray*arry=[babycao findConnectedPeripherals];
    NSLog(@" findConnectedPeripherals=%@",arry);
    if (arry.count>0)
    {
        for (CBPeripheral*per in arry)
        {
            self.Peripheral=per;
        }
        
        [self reloaddataforbulettoh];
    }
    else
    {
        [self.wenbutton setTitle:@"扫描设备" forState:0];
    }
}

/**
 *  断开后重连方法
 */
-(void)chonglian{
    NSLog(@"重连中。。。。。");

        [self reloaddataforbulettoh];

}

/**
 *  重连方法
 */
-(void)reloaddataforbulettoh{
    
    //这里错误，此处的self.Peripheral不一定是设置的时候的点击确认的那个设备
    NSLog(@"体温计设备名称 == %@",self.Peripheral.name);
    
    //这里判断再次连接的蓝牙设备是否是启动app后连接的设备，如果是，则连接，不是就继续搜索
    babycao.having(self.Peripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}

#pragma mark - 蓝牙连接代理模块
-(void)babyDelegate1{
    
    __weak typeof(self) weakSelf = self;
    
    __weak typeof(babycao) weakbaby = babycao;
    
    //找到设备的委托
    [babycao setBlockOnDiscoverToPeripheralsAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"找到设备，名称 == %@",peripheral);
        
        [weakSelf reloaddataforbulettoh];
        
    }];

    //连接成功的时候回调
    [babycao setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"成功连接设备，名称== %@",peripheral.name);
    
    }];
    
    //断开连接时候的回调
    [babycao setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备断开，当前设备状态 == %ld",(long)weakSelf.Peripheral.state);
        NSLog(@"peripheral == %ld",(long)peripheral.state);
        
        //温度按钮设置为扫描设备的文本
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.Peripheral.state == 1) {
                [weakSelf.wenbutton setTitle:@"扫描设备" forState:0];
            }
        });
        
        //关闭掉获取温度的定时器
        [weakSelf.reconnectTimer invalidate];
        weakSelf.reconnectTimer = nil;
        
        NSLog(@"重连设备名称 == %@", peripheral.name);
        
        //还没有连接上，就会被执行，所以获取不到历史数据
        //断开连接后，在连接条件回复后，可连接
        NSString *historyID = [[NSUserDefaults standardUserDefaults] objectForKey:@"identifier"];
        NSLog(@"上次连接的设备id == %@",historyID);
        if ([[peripheral.identifier UUIDString]isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"identifier"]]) {
            [weakbaby.centralManager connectPeripheral:peripheral options:nil];
            
            //在完成历史数据加载后，再重新加载数据
            [weakSelf reloaddataforbulettoh];
        }
        
    }];
    
    //查找到特征值的时候的回调
    [babycao setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"查找到特征值 特征值为== %@", service.characteristics[0]);
        
        [weakSelf insertRowToTableView:service];
        
        [weakSelf getDataAtDisconnect];
        
        if (![weakSelf.reconnectTimer isValid]) {
            //前30秒，每三秒钟获取一次数据
            weakSelf.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:weakSelf selector:@selector(huoquwendu) userInfo:nil repeats:YES];
            //30秒后，每十秒钟获取一次温度
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.reconnectTimer invalidate];
                weakSelf.reconnectTimer=nil;
                weakSelf.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:weakSelf selector:@selector(huoquwendu) userInfo:nil repeats:YES];
            });
            
        }
        
        [weakSelf.chongliangTimer invalidate];
        weakSelf.chongliangTimer=nil;
        
    }];
    
    [babycao setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        if (error) {
            NSLog(@"特征写入失败，原因为== %@",[error localizedDescription]);
        }else {
            NSLog(@"特征值写入成功");
        }
    }];
    
    //特征写入成功的委托
    [babycao setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {
        if (error) {
            NSLog(@"特征值写入失败，原因是==%@",[error localizedDescription]);
        }else {
        NSLog(@"特征值写入成功");
        }
    }];
    
    //characteristic订阅状态改变的block
    [babycao setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"订阅特征状态");
        
        if (characteristic.value) {
            [weakSelf insertReadValues:characteristic];
        }
    }];
    
    
}

//获取设备上保存的数据
- (void)getDataAtDisconnect
{
    unsigned char sendStr[16];
    
    sendStr[0] = 0xFC;
    sendStr[1] = 0x05;
    sendStr[2] = 0x00;
    sendStr[3] = 0x00;
    sendStr[4] = 0x00;
    sendStr[5] = 0x00;
    sendStr[6] = 0x00;
    sendStr[7] = 0x00;
    sendStr[8] = 0x00;
    sendStr[9] = 0x00;
    sendStr[10] = 0x00;
    sendStr[11] = 0x00;
    sendStr[12] = 0x00;
    sendStr[13] = 0x00;
    sendStr[14] = 0x00;
    sendStr[15] = 0x00;
    
    NSData *data = [NSData dataWithBytes:sendStr length:16];
    
    NSLog(@"特征写入前为 == %@", self.viewCharacteristic);
    
    //写characteristic
    [self.Peripheral writeValue:data forCharacteristic:self.viewCharacteristic type:CBCharacteristicWriteWithResponse];
    
    NSLog(@"特征写后为 == %@", self.viewCharacteristic);
}

#pragma mark 已连接的CBCharacteristic和设置通知

-(void)insertRowToTableView:(CBService *)service{
    NSLog(@"11111111111111");
    NSLog(@"连接到CBC，设置通知，特征===%@",service.characteristics);

    self.viewCharacteristic=[service.characteristics objectAtIndex:0];
    NSLog(@"uuid===%@",self.viewCharacteristic);
    [self setnotificationison];
    
}

-(void)huoquwendu{
   
    unsigned char sendStr[16];
    
    sendStr[0] = 0xFC;
    sendStr[1] = 0x04;
    sendStr[2] = 0x00;
    sendStr[3] = 0x00;
    sendStr[4] = 0x00;
    sendStr[5] = 0x00;
    sendStr[6] = 0x00;
    sendStr[7] = 0x00;
    sendStr[8] = 0x00;
    sendStr[9] = 0x00;
    sendStr[10] = 0x00;
    sendStr[11] = 0x00;
    sendStr[12] = 0x00;
    sendStr[13] = 0x00;
    sendStr[14] = 0x00;
    sendStr[15] = 0x00;
    
    
   
  
    NSData *data = [NSData dataWithBytes:sendStr length:16];
    
    NSLog(@"特征写入前为 == %@", self.viewCharacteristic);
    
    //写characteristic
    [self.Peripheral writeValue:data forCharacteristic:self.viewCharacteristic type:CBCharacteristicWriteWithResponse];

    NSLog(@"特征写后为 == %@", self.viewCharacteristic);
    
}


#pragma mark  设置通知
-(void)setnotificationison{
    
       NSLog(@"设置通知");
    [babycao notify:self.Peripheral
  characteristic:self.viewCharacteristic
           block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
              
               [self insertReadValues:characteristics];
               
           }];
}
#pragma mark 解析通知返回来的温度数据
//协议写入成功后通知回来的值
-(void)insertReadValues:(CBCharacteristic *)characteristics{
    
    NSLog(@"返回的温度%@",characteristics.value);
    
    if ([self.viewCharacteristic.value bytes]!=nil) {
        const unsigned char *hexBytesLight = [self.viewCharacteristic.value bytes];
        
        NSString *Str1 = [NSString stringWithFormat:@"%02x", hexBytesLight[0]];
        NSLog(@"标识符 = %@",Str1);
        
        //如果获取到的值的第一个字节是不是“04”，如果是，就对数值进行操作，不是就舍去
        if ([Str1 isEqualToString:@"04"]) {
            
            NSString *battery = [NSString stringWithFormat:@"%02x", hexBytesLight[13]];
            NSString *battery2 = [NSString stringWithFormat:@"%02x", hexBytesLight[14]];
            
            _wen=[_wenduchuli pass:battery xiaoshu:battery2];
            [self.wenbutton setTitle:[_wen stringByAppendingString:@"°C"]forState:0];
            
            NSLog(@"获取到的温度值== %@",_wen);
            
            if ([_wen floatValue]>[_wendu floatValue]) {
                _wendu=_wen;
            }
            NSLog(@"最大的温度=%@",_wendu);
            
            //取得当前时间，x轴
            NSDate* nowDate = [[NSDate alloc]init];
            
            NSLog(@"当前时间 == %@",nowDate);
            
            NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970] * 1000;
            
            NSLog(@"当前时间 == %f",nowTimeInterval);
            
//            NSString *YY = [NSString stringWithFormat:@"%02x", hexBytesLight[7]];
//            NSString *MM = [NSString stringWithFormat:@"%02x", hexBytesLight[8]];
//            NSString *DD = [NSString stringWithFormat:@"%02x", hexBytesLight[9]];
//            NSString *hh = [NSString stringWithFormat:@"%02x", hexBytesLight[10]];
//            NSString *mm = [NSString stringWithFormat:@"%02x", hexBytesLight[11]];
//            NSString *ss = [NSString stringWithFormat:@"%02x", hexBytesLight[12]];
//            
//            NSTimeInterval tiwenjiTimeInterval = [self stringByYYYY:YY MM:MM DD:DD hh:hh mm:mm ss:ss];
//            //换了温度计上的时间后，在图表中显示不正确，暂时不考虑替换
//            NSLog(@"温度计时间 == %f",tiwenjiTimeInterval);
            
            //随机温度，y轴
            float temperature =[_wen floatValue];
            if (temperature!=0) {
                
                //温度低于30度就不显示在折线图上
                if (temperature<30) {
                    NSMutableString* jsStr = [[NSMutableString alloc] initWithCapacity:0];
                    [jsStr appendFormat:@"updateData(%f,%d)",nowTimeInterval,30];
                    
                    [_webview stringByEvaluatingJavaScriptFromString:jsStr];
                }
                else{
                    NSLog(@"temperature=%0.2f",temperature);
                    NSMutableString* jsStr = [[NSMutableString alloc] initWithCapacity:0];
                    [jsStr appendFormat:@"updateData(%f,%0.2f)",nowTimeInterval,temperature];
                    
                    [_webview stringByEvaluatingJavaScriptFromString:jsStr];
                }
                
            }
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"suername"]==nil) {
                NSLog(@"用户为空");
                
            }
            else{
                [self saveCoreData2];
            }
        }
        //获取设备上在断开连接期间保存的数据个数
        if ([Str1 isEqualToString:@"05"]) {
            NSString *battery = [NSString stringWithFormat:@"%02x", hexBytesLight[13]];
            NSString *battery2 = [NSString stringWithFormat:@"%02x", hexBytesLight[14]];
            NSString *sumHistory = [NSString stringWithFormat:@"%@%@",battery,battery2];
            
            NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([sumHistory UTF8String],0,16)];
            NSLog(@"历史温度记录 10进制 %@",temp10);
            //转成数字
            int cycleNumber = [temp10 intValue];
            NSLog(@"记录数字 ：%d",cycleNumber);
            
            //000c 条数据，
            NSLog(@"设备上保存了%ld数据",(long)[sumHistory integerValue]);
            
            
            //如果有历史温度，就保存到数据库中，（后期如果可以，就展示在当前温度界面）
            if ([temp10 integerValue] > 0) {
                //获取历史温度
                [self gitHistoryT];
            }
        }
        
        //获取每一个历史记录
        if ([Str1 isEqualToString:@"06"]) {
            NSString *battery = [NSString stringWithFormat:@"%02x", hexBytesLight[13]];
            NSString *battery2 = [NSString stringWithFormat:@"%02x", hexBytesLight[14]];
            
            _wen=[_wenduchuli pass:battery xiaoshu:battery2];
            
            if ([_wen floatValue]>[_wendu floatValue]) {
                _wendu=_wen;
            }
            NSLog(@"最大的温度=%@",_wendu);
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"suername"]==nil) {
                NSLog(@"用户为空");
                
            }
            else{
                [self saveCoreData2];
            }
        }
    }
}

- (void)gitHistoryT
{
    unsigned char sendStr[16];
    
    sendStr[0] = 0xFC;
    sendStr[1] = 0x06;
    sendStr[2] = 0x00;
    sendStr[3] = 0x00;
    sendStr[4] = 0x00;
    sendStr[5] = 0x00;
    sendStr[6] = 0x00;
    sendStr[7] = 0x00;
    sendStr[8] = 0x00;
    sendStr[9] = 0x00;
    sendStr[10] = 0x00;
    sendStr[11] = 0x00;
    sendStr[12] = 0x00;
    sendStr[13] = 0x00;
    sendStr[14] = 0x00;
    sendStr[15] = 0x00;
    
    
    
    
    NSData *data = [NSData dataWithBytes:sendStr length:16];
    
    //写characteristic
    [self.Peripheral writeValue:data forCharacteristic:self.viewCharacteristic type:CBCharacteristicWriteWithResponse];
}

//处理时间
- (NSTimeInterval)stringByYYYY: (NSString *)YYYY MM:(NSString *)MM DD:(NSString *)DD hh:(NSString *)hh mm:(NSString *)mm ss:(NSString *)ss
{
    //@"2016-08-09 02:24:10 +0000"
    NSString *string = [NSString stringWithFormat:@"20%@-%@-%@ %@:%@:%@",YYYY ,DD ,MM ,hh ,mm ,ss] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [[NSDate alloc] init];
    // voila!
    date = [dateFormatter dateFromString:string];
    NSLog(@"体温计时间 = %@", date);
    
    //date to timestamp
    NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
    return timeInterval;
}


-(void)Gbaojing{
    
    if (_Gbiao)
    {
        
                NSLog(@"Gyes");
            if ([_wen floatValue]>[[_user objectForKey:@"gaowenLabel"]floatValue])
            {
               
                
                
                secondDetailViewController=nil;
                secondDetailViewController=[[gaowenbaojinView alloc]initWithNibName:@"gaowenbaojinView" bundle:nil];
                secondDetailViewController.delegate=self;
                [self presentPopupViewController:secondDetailViewController animationType:MJPopupViewAnimationFade];
                
                self.passSenderdelegate=secondDetailViewController;
                [self.passSenderdelegate passSender:[[[NSUserDefaults standardUserDefaults] objectForKey:@"suername"] stringByAppendingString:@" 当前温度为"] Wendu:[_wen stringByAppendingString:@"°C"]];
                
#warning 高温警报代码
//                这里做高温报警处理
//                设置高温一秒后push
                NSDate *pushDate =  [NSDate dateWithTimeIntervalSinceNow:1];
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                
                if (notification != nil) {
                    // 设置推送时间
                    
                    notification.fireDate = pushDate;
                    
                    // 设置时区
                    
                    notification.timeZone = [NSTimeZone defaultTimeZone];
                    
                    // 设置重复间隔
                    //notification.repeatInterval = kCFCalendarUnitDay;
                    
                    // 推送声音
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    
                    // 推送内容
                    notification.alertBody = @"高温警报";
                    
                    //显示在icon上的红色圈中的数子
                    notification.applicationIconBadgeNumber = 1;
                    
                    //设置userinfo 方便在之后需要撤销的时候使用
                    NSDictionary *info = [NSDictionary dictionaryWithObject:@"gaowen"forKey:@"key"];
                    
                    notification.userInfo = info;
                    
                    //添加推送到UIApplication
                    UIApplication *app = [UIApplication sharedApplication];
                    
                    [app scheduleLocalNotification:notification];
                    
                }
                
                    NSLog(@"温度高于报警温度  开始报警");
                
                    if ([_user boolForKey:@"GZswitch"]) {
                   
                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        
                    }
                    if ([_user boolForKey:@"GLswitch"]) {
                        
                        
                        AudioServicesPlaySystemSound(1021);
                    }
                    
                    
                   [_GbaojingTimer setFireDate:[NSDate distantFuture]];

            }
    }
    else
    {
        NSLog(@"高温报警未开启");
        
    }
  
    
 
}
-(void)Dbaojing{
    
    if (_Dbiao)
    {
          NSLog(@"Dyes");
       
        //防止初始温度获取不到值的情况下，造成体温警报
        if (_wen == NULL) {
            return;
        }
        if ([_wen floatValue]<[[_user objectForKey:@"diwenLabel"]floatValue])
        {
            dwViewController=nil;
            dwViewController=[[diwenbaojingView alloc]initWithNibName:@"diwenbaojingView" bundle:nil];
            dwViewController.delegate=self;
            NSLog(@"低温警报时的温度为 == %@",_wen);
            [self presentPopupViewController:dwViewController animationType:MJPopupViewAnimationFade];
            
            self.passSenderdelegate=dwViewController;
            [self.passSenderdelegate passSender:[[[NSUserDefaults standardUserDefaults] objectForKey:@"suername"] stringByAppendingString:@" 当前温度为"] Wendu:[_wen stringByAppendingString:@"°C"]];
           
#warning 低温警报代码
            //这里做高温报警处理
            //设置低温一秒后push
            NSDate *pushDate =  [NSDate dateWithTimeIntervalSinceNow:1];
            
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            
            if (notification != nil) {
                // 设置推送时间
                
                notification.fireDate = pushDate;
                
                // 设置时区
                
                notification.timeZone = [NSTimeZone defaultTimeZone];
                
                // 设置重复间隔
                //notification.repeatInterval = kCFCalendarUnitDay;
                
                // 推送声音
                notification.soundName = UILocalNotificationDefaultSoundName;
                
                // 推送内容
                notification.alertBody = @"低温警报！";
                
                //显示在icon上的红色圈中的数子
                
                notification.applicationIconBadgeNumber = 1;
                
                //设置userinfo 方便在之后需要撤销的时候使用
                
                NSDictionary *info = [NSDictionary dictionaryWithObject:@"diwen"forKey:@"key1"];
                
                notification.userInfo = info;
                
                //添加推送到UIApplication
                
                UIApplication *app = [UIApplication sharedApplication];
                
                [app scheduleLocalNotification:notification];
                
            }

            NSLog(@"温度低于低温报警温度  开始报警");
            
            if ([_user boolForKey:@"DZ"]) {
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
               
            }
            if ([_user boolForKey:@"DLswitch"]) {
                
               
                AudioServicesPlaySystemSound(1075);
            }
            
            
            [_DbaojingTimer setFireDate:[NSDate distantFuture]];
         
        }
    }
    else
    {
        NSLog(@"低温报警未开启");
        
    }
    
    
    
}
-(void)pandanViod{
    _Gdaojishi--;
    if (_Gdaojishi==0) {
        [_GbaojingTimer setFireDate:[NSDate distantPast]];
        [_Gdaoji invalidate];
        _Gdaoji=nil;
        _Gdaojishi=[[_user stringForKey:@"baojingjiege"] intValue]*60 ;
    }
    
    
    
    NSLog(@"------------高温倒计时判断-----------%d",_Gdaojishi);
}
-(void)DpandanViod{
    _Ddaojishi--;
    if (_Ddaojishi==0) {
        [_DbaojingTimer setFireDate:[NSDate distantPast]];
        [_Ddaoji invalidate];
        _Ddaoji=nil;
        _Ddaojishi=[[_user stringForKey:@"baojingjiege"] intValue]*60 ;
    }
    
    
    
    NSLog(@"------------低温倒计时判断-----------%d",_Ddaojishi);
}
- (void)cancelButtonClicked:(gaowenbaojinView *)aSecondDetailViewController
{
    NSLog(@"高温报警View  不再提醒");
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    secondDetailViewController = nil;
}
- (void)okButtonClicked:(gaowenbaojinView *)aSecondDetailViewController
{
    NSLog(@"高温报警View  稍后提醒");
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    secondDetailViewController = nil;
     _Gdaoji=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pandanViod) userInfo:nil repeats:YES];
}
-(void)dwcancelButtonClicked:(ViewController *)secondDetailViewController{
    NSLog(@"低温报警View  不再提醒");
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    dwViewController = nil;
    
}
-(void)dwokButtonClicked:(ViewController *)aSecondDetailViewController{
    NSLog(@"低温报警View  不再提醒");
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    dwViewController = nil;
     _Ddaoji=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(DpandanViod) userInfo:nil repeats:YES];
}


//将最高温存储到数据库当中(将时间作为参数传入进来，按照设备上的时间进行存储)
-(void)saveCoreData2{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddhhmm"];
    NSString *string_day= [ [formatter stringFromDate:date] substringToIndex:12];
    NSLog(@"存储一次数据，时间为 == %@",string_day);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"suername"])
    {
        NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription * entity = [NSEntityDescription entityForName:@"Test" inManagedObjectContext:self.myappdelegate2.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate * agePre = [NSPredicate predicateWithFormat:@"shijian like %@",string_day];
        [fetchRequest setPredicate:agePre];
        NSError * requestError = nil;
        NSArray * persons = [self.myappdelegate2.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
        if ([persons count]>0)
        {
            for (Test*pp in persons)
            {
                
                pp.shijian=string_day;
                [self updateuser:pp];
            }
        }
        else
        {
            // 创建实体
            Test * newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:self.myappdelegate2.managedObjectContext];
            // 赋值
            if (newPerson != nil)
            {
                newPerson.name=[[NSUserDefaults standardUserDefaults] objectForKey:@"suername"];
                newPerson.shijian=string_day;
                newPerson.wendu=_wendu;
                
                
                // 保存数据
                if ([self.myappdelegate2.managedObjectContext save:nil])
                {
                    NSLog(@"success");
                }
                else
                {
                    NSLog(@"failed to save the context error ");
                }
                
            }
            
            else
            {
                NSLog(@"failed to create the new person");
                
            }
            
        }
        
    }
    else
    {
        NSLog(@"未选择用户无法保持数据");
    }
    
    
    
}
-(void)updateuser:(Test*)user{
    
    
    user.wendu=_wendu;
    
    
    
    
    //更新数据
    [self.myappdelegate2.managedObjectContext save:nil];
    NSLog(@"已更新");
    
    
}
-(void)saveCoreData{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddhh"];
    [formatter2 setDateFormat:@"YYYYMMdd"];
    NSString *string_day_time = [[formatter stringFromDate:date] substringToIndex:10];
    NSString *string_day = [formatter2 stringFromDate:date];
    
    
    for (int i=1; i<=24; i++)
        
    {
        
        if (i<10)
        {
            NSString*AA=[[string_day stringByAppendingString:@"0"]stringByAppendingString:[NSString stringWithFormat:@"%i",i]];
            if ([AA isEqualToString:string_day_time]) {
                
                // 创建实体
                Test * newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:self.myappdelegate2.managedObjectContext];
                // 赋值
                if (newPerson != nil)
                    
                {
                    if (![_wendu isEqualToString:@"0.0"]) {
                        newPerson.name=[[NSUserDefaults standardUserDefaults] objectForKey:@"suername"];
                        newPerson.shijian=AA;
                        newPerson.wendu=_wendu;
                        
                        // 保存数据
                        if ([self.myappdelegate2.managedObjectContext save:nil])
                        {
                            NSLog(@"--------------------------------------------success");
                        }
                        else
                        {
                            NSLog(@"failed to save the context error ");
                        }
                    }
                }
                
                else
                {
                    NSLog(@"failed to create the new person");
                    
                }
                
                
            }
            
            
        }
        else
        {
            NSString*AA=[string_day stringByAppendingString:[NSString stringWithFormat:@"%i",i]];
            if ([AA isEqualToString:string_day_time]) {
                // 创建实体
                Test * newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:self.myappdelegate2.managedObjectContext];
                // 赋值
                if (newPerson != nil)
                    
                {
                    
                    newPerson.name=[[NSUserDefaults standardUserDefaults] objectForKey:@"suername"];
                    newPerson.shijian=AA;
                    newPerson.wendu=_wendu;
                    
                    // 保存数据
                    if ([self.myappdelegate2.managedObjectContext save:nil])
                    {
                        NSLog(@"--------------------------------------------success");
                    }
                    else
                    {
                        NSLog(@"failed to save the context error ");
                    }
                    
                }
                
                else
                {
                    NSLog(@"failed to create the new person");
                    
                }
                
                
                
            }
        }
        
    }
    
    
    
    
    
    
    
    
}


#pragma mark - delegate of webview
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.imageH.constant=[UIScreen mainScreen].bounds.size.height*0.25;
    self.imageW.constant=[UIScreen mainScreen].bounds.size.height*0.25;
    self.buttonH.constant=[UIScreen mainScreen].bounds.size.height*0.25;
    self.buttonW.constant=[UIScreen mainScreen].bounds.size.height*0.25;
    self.webH.constant=[UIScreen mainScreen].bounds.size.height*0.55;
    self.webW.constant=[UIScreen mainScreen].bounds.size.height*0.55;
    self.vieww.constant=[UIScreen mainScreen].bounds.size.width;
    self.Viewh.constant=[UIScreen mainScreen].bounds.size.height*0.55;
}


@end
 