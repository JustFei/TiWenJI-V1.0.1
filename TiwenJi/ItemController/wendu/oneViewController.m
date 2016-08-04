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
@property(nonatomic ,strong) wenduchuli*chuli;
@property(nonatomic ,strong)NSString*wen;



@property (nonatomic, weak) JAYLineChart * lineChart;
@end

@implementation oneViewController

- (void)viewDidLoad {
    NSLog(@"oneviewDidLoad");

   
    [super viewDidLoad];
    self.myappdelegate2=[UIApplication sharedApplication].delegate;
    _xianshidaojishiTime=15;
    _chuli=[[wenduchuli alloc]init];
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
    if ([[self.Peripheral.identifier UUIDString]isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"]]) {
        babycao.having(self.Peripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    }
    
//    babycao.having(self.Peripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}


#pragma mark - 蓝牙连接代理模块
-(void)babyDelegate1{
    
    __weak typeof(self) weakSelf = self;
    
    //成功连接设备的委托
    [babycao setBlockOnDiscoverToPeripheralsAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"%@",peripheral);
        
    }];
    
    
    
    
//    //设置扫描到设备的委托
//    [babycao setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
//        
//        NSLog(@"------------%@",peripheral.name);
//        if ([[peripheral.identifier UUIDString]isEqualToString:@"22A8135D-D3FA-3E11-FA58-85E9CA886C9C"]) {
//            NSLog(@"%@",peripheral.name);
//            
//        }
//        
//       
//    }];

   
    
    //连接成功的时候回调
    [babycao setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"one连接成功-%@",peripheral.name);
        
        if (![weakSelf.reconnectTimer isValid]) {
            weakSelf.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:weakSelf selector:@selector(huoquwendu) userInfo:nil repeats:YES];
        }
        
        [weakSelf.chongliangTimer invalidate];
        weakSelf.chongliangTimer=nil;
    }];
    
    //断开连接时候的回调
    [babycao setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"oneduankai");
        
         [weakSelf.wenbutton setTitle:@"扫描设备" forState:0];
        
        [weakSelf.reconnectTimer invalidate];
        weakSelf.reconnectTimer = nil;
        
        if (![weakSelf.chongliangTimer isValid]) {
            weakSelf.chongliangTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:weakSelf selector:@selector(chonglian) userInfo:nil repeats:YES];
        }
        
    }];
    
    //查找到特征值的时候的回调
    [babycao setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"------");
        [weakSelf insertRowToTableView:service];
        
    }];
    
    
    [babycao setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {
      
        
    }];
    
    //characteristic订阅状态改变的block
    [babycao setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {
        [weakSelf insertReadValues:characteristic];
        
    }];
    
    
}

#pragma mark 已连接的CBCharacteristic和设置通知

-(void)insertRowToTableView:(CBService *)service{
    NSLog(@"11111111111111");
    NSLog(@"service.characteristics===%@",service.characteristics);

    self.viewCharacteristic=[service.characteristics objectAtIndex:0];
    NSLog(@"uuid===%@",self.viewCharacteristic.UUID.UUIDString);
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
    [self.Peripheral writeValue:data forCharacteristic:self.viewCharacteristic type:CBCharacteristicWriteWithResponse];

    
    NSLog(@"获取温度进行时。。。。。。");
    
}
#pragma mark  设置通知
-(void)setnotificationison{
    
       NSLog(@"22222222222222");
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
       
        NSString *battery = [NSString stringWithFormat:@"%02x", hexBytesLight[13]];
        NSString *battery2 = [NSString stringWithFormat:@"%02x", hexBytesLight[14]];
        
        _wen=[_chuli pass:battery xiaoshu:battery2];
        [self.wenbutton setTitle:[_wen stringByAppendingString:@"°C"]forState:0];
        
        if ([_wen floatValue]>[_wendu floatValue]) {
            _wendu=_wen;
        }
        NSLog(@"最大的温度=%@",_wendu);
        
        //取得当前时间，x轴
      NSDate* nowDate = [[NSDate alloc]init];
     
        NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970] * 1000;
     
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
       
        
        if ([_wen floatValue]<[[_user objectForKey:@"diwenLabel"]floatValue])
        {
            
            dwViewController=nil;
            dwViewController=[[diwenbaojingView alloc]initWithNibName:@"diwenbaojingView" bundle:nil];
            dwViewController.delegate=self;
//            [self presentPopupViewController:dwViewController animationType:MJPopupViewAnimationFade];
            
            self.passSenderdelegate=dwViewController;
            [self.passSenderdelegate passSender:[[[NSUserDefaults standardUserDefaults] objectForKey:@"suername"] stringByAppendingString:@" 当前温度为"] Wendu:[_wen stringByAppendingString:@"°C"]];
           

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



-(void)saveCoreData2{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddhh"];
    NSString *string_day= [ [formatter stringFromDate:date] substringToIndex:10];
  
    
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
 