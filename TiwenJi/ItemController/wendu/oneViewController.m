//
//  oneViewController.m
//  Newthermometer
//
//  Created by 莫福见 on 16/2/22.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//  此注释仅仅为提交用

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
@property(nonatomic,strong)NSTimer*reconnectTimer15;
@property(nonatomic,strong)NSString*currentWendu;
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
//    [self.GbaojingTimer invalidate];
//    self.GbaojingTimer=nil;
//    [self.DbaojingTimer invalidate];
//    self.DbaojingTimer=nil;
//    [_Gdaoji invalidate];
//    _Gdaoji=nil;
//    [_Ddaoji invalidate];
//    _Ddaoji=nil;
    
    
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
        [self.wenbutton setTitle:NSLocalizedString(@"ScanDevice", nil) forState:0];
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
        
        //连接成功后，取消扫描
        [weakbaby cancelScan];
    
    }];
    
    //查找到特征值的时候的回调
    [babycao setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"查找到特征值 特征值为== %@", service.characteristics[0]);
        
        [weakSelf insertRowToTableView:service];
        
        //获取设备上保存的数据
        [weakSelf getDataAtDisconnect];
        
        if (![weakSelf.reconnectTimer isValid]) {
            //前30秒，每三秒钟获取一次数据

            //经过测试得出的结论，如果定时器的时间超过5秒，进入后台后很快就会停止
            weakSelf.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:weakSelf selector:@selector(huoquwendu) userInfo:nil repeats:YES];
            
            //30秒后，每十秒钟获取一次温度
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf.reconnectTimer invalidate];
//                weakSelf.reconnectTimer=nil;
                
//                weakSelf.reconnectTimer15 = [NSTimer scheduledTimerWithTimeInterval:15 target:weakSelf selector:@selector(huoquwendu) userInfo:nil repeats:YES];
            });

            //重新开辟一个15秒的定时器，来获取温度，该定时器可在后台运行
        }
        
        
        [weakSelf.chongliangTimer invalidate];
        weakSelf.chongliangTimer=nil;
        
    }];
    
    //断开连接时候的回调
    [babycao setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备断开，当前设备状态 == %ld",(long)weakSelf.Peripheral.state);
        NSLog(@"peripheral == %ld",(long)peripheral.state);
        
        //温度按钮设置为扫描设备的文本
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.Peripheral.state == 1) {
                [weakSelf.wenbutton setTitle:NSLocalizedString(@"ScanDevice", nil) forState:0];
            }
        });
        
        //关闭掉获取温度的定时器
//        [weakSelf.reconnectTimer15 invalidate];
//        weakSelf.reconnectTimer15 = nil;
        
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
    
    //特征写入状态回调
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
    [self setTime];
}
#pragma mark 解析通知返回来的温度数据
//协议写入成功后通知回来的值
-(void)insertReadValues:(CBCharacteristic *)characteristics{
    
    NSLog(@"返回的温度%@",characteristics.value);
    
    if ([self.viewCharacteristic.value bytes]!=nil) {
        const unsigned char *hexBytesLight = [self.viewCharacteristic.value bytes];
        
        NSString *Str1 = [NSString stringWithFormat:@"%02x", hexBytesLight[0]];
        NSLog(@"标识符 = %@",Str1);
        
        if ([Str1 isEqualToString:@"00"]) {
            NSString *YY = [NSString stringWithFormat:@"%02x", hexBytesLight[9]];
            NSString *MM = [NSString stringWithFormat:@"%02x", hexBytesLight[10]];
            NSString *DD = [NSString stringWithFormat:@"%02x", hexBytesLight[11]];
            NSString *hh = [NSString stringWithFormat:@"%02x", hexBytesLight[12]];
            NSString *mm = [NSString stringWithFormat:@"%02x", hexBytesLight[13]];
            NSString *ss = [NSString stringWithFormat:@"%02x", hexBytesLight[14]];
            
            NSLog(@"时间设置成功，时间为 == %@-%@-%@ %@:%@:%@",YY ,MM ,DD ,hh ,mm ,ss);
        }else if ([Str1 isEqualToString:@"80"]) {
            NSLog(@"时间设置失败，失败校验为 == %s",hexBytesLight);
        }
        
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
//            NSDate* nowDate = [[NSDate alloc]init];
//            NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
//            [nowDateFormatter setDateFormat:@"yyyyMMddHHmm"];
//            NSString *nowDateStr = [nowDateFormatter stringFromDate:nowDate];
//            NSString *nowmmStr = [nowDateStr substringFromIndex:10];
//            NSLog(@"%@",nowmmStr);
//            
//            NSLog(@"当前时间 == %@",nowDate);
            
//            NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970] * 1000;
            
            //1470899984907.288086
//            NSLog(@"！！！！！！！！！当前时间 == %f",nowTimeInterval);
            
            NSString *YY = [NSString stringWithFormat:@"%02x", hexBytesLight[7]];
            NSString *MM = [NSString stringWithFormat:@"%02x", hexBytesLight[8]];
            NSString *DD = [NSString stringWithFormat:@"%02x", hexBytesLight[9]];
            NSString *hh = [NSString stringWithFormat:@"%02x", hexBytesLight[10]];
            NSString *mm = [NSString stringWithFormat:@"%02x", hexBytesLight[11]];
            NSString *ss = [NSString stringWithFormat:@"%02x", hexBytesLight[12]];

            NSTimeInterval tiwenjiTimeInterval = [self stringByYYYY:YY MM:MM DD:DD hh:hh mm:mm ss:ss];
//            //换了温度计上的时间后，已经替换
            //1470899980000.000000
            NSLog(@"？？？？？？？？？？温度计时间 == %f",tiwenjiTimeInterval);
            
            //随机温度，y轴
            float temperature =[_wen floatValue];
            if (temperature!=0) {
                _currentWendu = [NSString stringWithFormat:@"%0.2f",temperature];
                //温度低于30度就不显示在折线图上
                if (temperature<30) {
                    NSMutableString* jsStr = [[NSMutableString alloc] initWithCapacity:0];
                    [jsStr appendFormat:@"updateData(%f,%d)",tiwenjiTimeInterval,30];
                    
                    [_webview stringByEvaluatingJavaScriptFromString:jsStr];
                }
                else{
                    NSLog(@"temperature=%0.2f",temperature);
                    NSMutableString* jsStr = [[NSMutableString alloc] initWithCapacity:0];
                    [jsStr appendFormat:@"updateData(%f,%0.2f)",tiwenjiTimeInterval,temperature];
                    
                    [_webview stringByEvaluatingJavaScriptFromString:jsStr];
                }
                
            }
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"suername"]==nil) {
                NSLog(@"用户为空");
                
            }
            else{
                //每隔五分钟存储一次数据
                NSInteger mmTime = [mm integerValue];
                if (mmTime % 5 == 0) {
                    NSLog(@"存储时的时间 == %ld",(long)mmTime);
                    NSString *string_day = [NSString stringWithFormat:@"20%@%@%@%@%@",YY,MM,DD,hh,mm];
                    
                    [self saveCoreData2: string_day];
                }
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
            
            NSString *YY = [NSString stringWithFormat:@"%02x", hexBytesLight[7]];
            NSString *MM = [NSString stringWithFormat:@"%02x", hexBytesLight[8]];
            NSString *DD = [NSString stringWithFormat:@"%02x", hexBytesLight[9]];
            NSString *hh = [NSString stringWithFormat:@"%02x", hexBytesLight[10]];
            NSString *mm = [NSString stringWithFormat:@"%02x", hexBytesLight[11]];
            NSString *ss = [NSString stringWithFormat:@"%02x", hexBytesLight[12]];
            
            NSTimeInterval tiwenjiTimeInterval = [self stringByYYYY:YY MM:MM DD:DD hh:hh mm:mm ss:ss];
            //            //换了温度计上的时间后，已经替换
            //1470899980000.000000
            NSLog(@"？？？？？？？？？？温度计时间 == %f",tiwenjiTimeInterval);
            
            //随机温度，y轴
            float temperature =[_wen floatValue];
            
            if (temperature!=0) {
                _currentWendu = [NSString stringWithFormat:@"%0.2f",temperature];
                //温度低于30度就不显示在折线图上
                if (temperature<30) {
                    NSMutableString* jsStr = [[NSMutableString alloc] initWithCapacity:0];
                    [jsStr appendFormat:@"updateData(%f,%d)",tiwenjiTimeInterval,30];
                    
                    [_webview stringByEvaluatingJavaScriptFromString:jsStr];
                }
                else{
                    NSLog(@"temperature=%0.2f",temperature);
                    NSMutableString* jsStr = [[NSMutableString alloc] initWithCapacity:0];
                    [jsStr appendFormat:@"updateData(%f,%0.2f)",tiwenjiTimeInterval,temperature];
                    
                    [_webview stringByEvaluatingJavaScriptFromString:jsStr];
                }
                
            }

            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"suername"]==nil) {
                NSLog(@"用户为空");
                
            }
            else{
                NSInteger mmTime = [mm integerValue];
                if (mmTime % 5 == 0) {
                    NSLog(@"存储时的时间 == %ld",(long)mmTime);
                    NSString *string_day = [NSString stringWithFormat:@"20%@%@%@%@%@",YY,MM,DD,hh,mm];
                    
                    [self saveCoreData2: string_day];
                }
            }
        }
    }
}

//设置时间
- (void)setTime
{
    unsigned char sendStr[16];
    
    sendStr[0] = 0xFC;
    sendStr[1] = 0x00;//设置时间标识为00
    //    sendStr[2] = 0x00;//YY
    //    sendStr[3] = 0x00;//MM
    //    sendStr[4] = 0x00;//DD
    //    sendStr[5] = 0x00;//hh
    //    sendStr[6] = 0x00;//mm
    //    sendStr[7] = 0x00;//ss
    sendStr[8] = 0x00;
    sendStr[9] = 0x00;
    sendStr[10] = 0x00;
    sendStr[11] = 0x00;
    sendStr[12] = 0x00;
    sendStr[13] = 0x00;
    sendStr[14] = 0x00;
    sendStr[15] = 0x00;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* s1 = [df stringFromDate:today];
    NSDate* date = [df dateFromString:s1];
    //转换时间格式
    NSDateFormatter*df2 = [[NSDateFormatter alloc]init];//格式化
    [df2 setDateFormat:@"yyyyMMddHHmmss"];
    //改为中国时区
    [df2 setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    NSString *todayStr =[df2 stringFromDate:date];
    
    NSString *sendString = [NSString stringWithFormat:@"FC00%@0000000000000000",[todayStr substringWithRange:NSMakeRange(2, 12)]];
    NSLog(@"%@",sendString);
    
    //根据当前时间来设置写入特征值已经搞定
    int YY = [sendString substringWithRange:NSMakeRange(4, 2)].intValue;
    int MM = [sendString substringWithRange:NSMakeRange(6, 2)].intValue;
    int DD = [sendString substringWithRange:NSMakeRange(8, 2)].intValue;
    int hh = [sendString substringWithRange:NSMakeRange(10, 2)].intValue;
    int mm = [sendString substringWithRange:NSMakeRange(12, 2)].intValue;
    int ss = [sendString substringWithRange:NSMakeRange(14, 2)].intValue;
#pragma mark - 十进制转换BCD编码实现
    //这里是将十进制的数字转换成BCD码格式，这样就可以写入特征了
    DectoBCD(YY, &sendStr[2], 2);
    DectoBCD(MM, &sendStr[3], 2);
    DectoBCD(DD, &sendStr[4], 2);
    DectoBCD(hh, &sendStr[5], 2);
    DectoBCD(mm, &sendStr[6], 2);
    DectoBCD(ss, &sendStr[7], 2);
    
    NSData *data = [NSData dataWithBytes:sendStr length:16];
    [data bytes];
    [self.Peripheral writeValue:data forCharacteristic:self.viewCharacteristic type:CBCharacteristicWriteWithResponse];
}

///////////////////////////////////////////////////////// //
// 功能：十进制转 BCD 码 //
// 输入： int Dec                      待转换的十进制数据 //      int length                   BCD 码数据长度 //
// 输出： unsigned char *Bcd           转换后的 BCD 码 //
// 返回： 0  success //
// 思路：原理同 BCD 码转十进制 //
//////////////////////////////////////////////////////////
int DectoBCD(int Dec, unsigned char *Bcd, int length)
{
    int i;
    int temp = Dec;
    for(i=length-1;i>=0;i--)
        //这里由于我们是两位数两位数传进来，所以不需要简历循环
        //    {temp=Dec%100;
        Bcd[i]=((temp/10)<<4)+((temp%10)&0x0F);
    //        Dec/=100;
    NSLog(@"%s",Bcd);
    printf("%s",Bcd);
    //    }
    
    return 0;
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
    NSString *string = [NSString stringWithFormat:@"20%@-%@-%@ %@:%@:%@",YYYY ,MM ,DD ,hh ,mm ,ss] ;
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
    //修改沙盒里面高温报警的值
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [user setBool:0 forKey:@"Gswitch"];
    [user setBool:0 forKey:@"GLswitch"];
    [user setBool:0 forKey:@"GZswitch"];
    
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
    
    //修改沙盒里面高温报警的值
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [user setBool:0 forKey:@"Dswitch"];
    [user setBool:0 forKey:@"DLswitch"];
    [user setBool:0 forKey:@"DZ"];
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
-(void)saveCoreData2:(NSString *)string_day{
    
    //NSDate *date = [NSDate date];
//    ÷NS÷DateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYYMMddhhmm"];
//    NSString *string_day= [ [formatter stringFromDate:date] substringToIndex:12];
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
        
        //判断存储的时间是否存在于数据库中，如果存在，就更新温度数据，如果不存在就创建新的对象存储数据
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
                newPerson.wendu=_currentWendu;
                
                
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
    
    //做个判断，如果数据库中的温度小于当前温度，就替换掉，否则不作操作
    if (user.wendu <_currentWendu) {
        user.wendu = _currentWendu;
    }
    
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
 