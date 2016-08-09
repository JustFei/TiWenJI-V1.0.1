//
//  lanyalianjieViewController.m
//  Newthermometer
//
//  Created by 莫福见 on 16/2/27.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "lanyalianjieViewController.h"
#import "PulsingHaloLayer.h"
#import "SVProgressHUD.h"
#import "oneViewController.h"
#import "TabBarViewController.h"


@interface lanyalianjieViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BabyBluetooth *baby;
    NSMutableArray *peripherals;
    NSMutableArray *peripheralsAD;
    NSTimer*layerTimer;

    LanYaLianJieWaitingForDataCallBack _lanYaLianJieWaitingForDataCallBack;
}

@property (nonatomic, weak) PulsingHaloLayer *halo;
@property(nonatomic,strong)CBCharacteristic*bluetoothviewCharacteristic;
@property(nonatomic,strong)CBPeripheral*bluetoothPeripheral;



@end

@implementation lanyalianjieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    peripherals = [[NSMutableArray alloc]init];
    peripheralsAD = [[NSMutableArray alloc]init];
  
   
    baby = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
    [self startlayer];
    layerTimer = [NSTimer timerWithTimeInterval:8 target:self selector:@selector(stoplayer) userInfo:nil repeats:NO];
        [layerTimer setFireDate: [[NSDate date]dateByAddingTimeInterval:8]];
    [[NSRunLoop currentRunLoop] addTimer:layerTimer forMode:NSRunLoopCommonModes];
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"lanyaviewDidAppear");
    baby.scanForPeripherals().begin();
    
    [self labereload];
    
    

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.halo.position = self.beaconView.center;
}
-(void)labereload{
    NSArray*arry=[baby findConnectedPeripherals];
    if (arry.count>0) {
        for (CBPeripheral*Peripheral in arry) {
            NSString*string=@"已连接";
            self.label.text=[string stringByAppendingString:Peripheral.name];
        }
        
        self.beaconView.image=[UIImage imageNamed:@"blue_connect.png"];
        [self.duankaiSwitch setOn:YES];
        self.duankaiSwitch.enabled=YES;
        
        NSLog(@"dianliang=%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"dianliang"]);
        
        self.dianlianglabel.text=[ NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"dianliang"]];
  
    }
    else
    {
        self.beaconView.image=[UIImage imageNamed:@"unconnet"];
        self.label.text=@"未连接设备";
        [self.duankaiSwitch setOn:NO];
        self.duankaiSwitch.enabled=NO;
    }
}

-(void)startlayer{
    // basic setup
    PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    self.halo = layer;
    [self.beaconView.superview.layer insertSublayer:self.halo below:self.beaconView.layer];
    self.halo.position = self.beaconView.center;
    self.halo.haloLayerNumber = 2;
    self.halo.radius = 100;
    self.halo.animationDuration = 2.7;
    [self.halo setBackgroundColor:[UIColor redColor].CGColor];
    layerTimer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(stoplayer) userInfo:nil repeats:NO];
    [layerTimer setFireDate: [[NSDate date]dateByAddingTimeInterval:10]];
    [[NSRunLoop currentRunLoop] addTimer:layerTimer forMode:NSRunLoopCommonModes];
}
-(void)stoplayer{
     [self.halo removeFromSuperlayer];
    
}

- (void)setLanYaLianJieWaitingForDataCallBack:(LanYaLianJieWaitingForDataCallBack)callback
{
    _lanYaLianJieWaitingForDataCallBack = callback;
}

#pragma mark - 蓝牙连接委托
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(baby) weakBaby = baby;
    
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
                    }
    }];
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"service.UUID.UUIDString==%@",service.UUID.UUIDString);
      
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
       // NSLog(@"%@",[peripheral.identifier UUIDString]);
      
      
        [weakSelf insertTableView:peripheral advertisementData:advertisementData];
    }];
    
     //连接设备成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
      
        NSString*string=@"已连接";
        NSLog(@"已连接成功的设备的identifier=%@",[peripheral.identifier UUIDString]);
        
        [[NSUserDefaults standardUserDefaults]setValue:[peripheral.identifier UUIDString] forKey:@"identifier" ];
        
        
        weakSelf.label.text=[string stringByAppendingString:peripheral.name];
        weakSelf.beaconView.image=[UIImage imageNamed:@"blue_connect.png"];
        weakSelf.duankaiSwitch.enabled=YES;
        [weakSelf.duankaiSwitch setOn:YES];
        
//        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"温度特征值写入成功");
    }];
    
   //设置查找到Characteristics的block
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        [weakSelf insertRowToTableView:service];
    
    }];
    
    //设备断开委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"zhu已断开");
        weakSelf.label.text=@"未连接设备";
        
        weakSelf.beaconView.image=[UIImage imageNamed:@"unconnet"];
       
        weakSelf.duankaiSwitch.enabled=NO;
        [weakSelf.duankaiSwitch setOn:NO];
        
        //断开连接后，在连接条件回复后，可连接
        if ([[peripheral.identifier UUIDString]isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"identifier"]]) {
            [weakBaby.centralManager connectPeripheral:peripheral options:nil];
//            [weakSelf reloadDataBluetooth];
        }
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)back:(id)sender {
    
//                TabBarViewController*vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TabBarViewController"];
//    
//                [self presentViewController:vc animated:YES completion:^{
//    
//                }];
    
//    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark 已连接的CBCharacteristic和设置通知

-(void)insertRowToTableView:(CBService *)service{
    NSLog(@"========================%@",[service.characteristics objectAtIndex:0]);
    self.bluetoothviewCharacteristic=[service.characteristics objectAtIndex:0];
    [self setnotificationison];
}

//获取温度
-(void)huoqudianliang{
    
    unsigned char sendStr[16];
    
    sendStr[0] = 0xFC;
    sendStr[1] = 0x07;
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
    [self.bluetoothPeripheral writeValue:data forCharacteristic:self.bluetoothviewCharacteristic type:CBCharacteristicWriteWithResponse];
}

//设置时间
- (void)setTime
{
    unsigned char sendStr[16];
    
    sendStr[0] = 0xFC;
    sendStr[1] = 0x00;//设置时间标识为00
    sendStr[2] = 0x16;//YY
    sendStr[3] = 0x08;//MM
    sendStr[4] = 0x09;//DD
    sendStr[5] = 0x16;//hh
    sendStr[6] = 0x18;//mm
    sendStr[7] = 0x30;//ss
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
    
    //根据当前时间来设置写入特征值还不会
    NSInteger YY = [sendString substringWithRange:NSMakeRange(4, 2)].integerValue;
    NSInteger MM = [sendString substringWithRange:NSMakeRange(6, 2)].integerValue;
    NSInteger DD = [sendString substringWithRange:NSMakeRange(8, 2)].integerValue;
    NSInteger hh = [sendString substringWithRange:NSMakeRange(10, 2)].integerValue;
    NSInteger mm = [sendString substringWithRange:NSMakeRange(12, 2)].integerValue;
    NSInteger ss = [sendString substringWithRange:NSMakeRange(14, 2)].integerValue;
    NSLog(@"数字命令 == yy:%ld,MM:%ld,dd:%ld,hh:%ld,mm:%ld,ss:%ld",YY,MM,DD,hh,mm,ss);
    NSString *YY16 = [NSString stringWithFormat:@"0x%@",[[NSString alloc] initWithFormat:@"%1lx",(long)YY]];
    NSString *MM16 = [NSString stringWithFormat:@"0x%@",[[NSString alloc] initWithFormat:@"%1lx",(long)MM]];
    NSString *DD16 = [NSString stringWithFormat:@"0x%@",[[NSString alloc] initWithFormat:@"%1lx",(long)DD]];
    NSString *hh16 = [NSString stringWithFormat:@"0x%@",[[NSString alloc] initWithFormat:@"%1lx",(long)hh]];
    NSString *mm16 = [NSString stringWithFormat:@"0x%@",[[NSString alloc] initWithFormat:@"%1lx",(long)mm]];
    NSString *ss16 = [NSString stringWithFormat:@"0x%@",[[NSString alloc] initWithFormat:@"%1lx",(long)ss]];
    NSLog(@"十六进制 == %@/%@/%@ %@：%@：%@",YY16,MM16,DD16,hh16,mm16,ss16);
//    sendStr[2] = YY16.intValue;
//    sendStr[3] = MM16.intValue;
//    sendStr[4] = DD16.intValue;
//    sendStr[5] = hh16.intValue;
//    sendStr[6] = mm16.intValue;
//    sendStr[7] = ss16.intValue;
    
//    NSDate *nowDate = [NSDate date];
//    NSDateFormatter *datefomat = [[NSDateFormatter alloc] init];
//    [datefomat setDateFormat:@"yyyy"];
//    int yyyy = [[datefomat stringFromDate:nowDate] intValue];
//    yyyy = yyyy % 100;
//    [datefomat setDateFormat:@"MM"];
//    int MM = [[datefomat stringFromDate:nowDate] intValue];
//    [datefomat setDateFormat:@"dd"];
//    int DD = [[datefomat stringFromDate:nowDate] intValue];
//    [datefomat setDateFormat:@"hh"];
//    int hh = [[datefomat stringFromDate:nowDate] intValue];
//    [datefomat setDateFormat:@"mm"];
//    int mm = [[datefomat stringFromDate:nowDate] intValue];
//    [datefomat setDateFormat:@"ss"];
//    int ss = [[datefomat stringFromDate:nowDate] intValue];
//    sendStr[2] = yyyy;
//    sendStr[3] = MM;
//    sendStr[4] = DD;
//    sendStr[5] = hh;
//    sendStr[6] = mm;
//    sendStr[7] = ss;
    
//    NSLog(@"数字命令 ==yyyy:%d, MM:%d,dd:%d,hh:%d,mm:%d,ss:%d",yyyy,MM,DD,hh,mm,ss);
    
    NSData *data = [NSData dataWithBytes:sendStr length:16];
     [data bytes];
//    NSLog(@"%@",[data bytes]);
#warning 暂时关闭设置时间功能
//    [self.bluetoothPeripheral writeValue:data forCharacteristic:self.bluetoothviewCharacteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark  设置通知
-(void)setnotificationison{
    
    
    [baby notify:self.bluetoothPeripheral
     characteristic:self.bluetoothviewCharacteristic
              block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                  
                  [self insertReadValues:characteristics];
                  
              }];
    [self huoqudianliang];
    [self setTime];
}

#pragma mark - 通过特征返回的值计算出电量
-(void)insertReadValues:(CBCharacteristic *)characteristics{
    NSLog(@"返回的电量=%@",characteristics.value);
    if ([characteristics.value bytes]!=nil) {
        const unsigned char *hexBytesLight = [characteristics.value bytes];
        //NSLog(@"------------======------%@",[NSString stringWithFormat:@"%02x", hexBytesLight[14]]);
        
        NSString *Str1 = [NSString stringWithFormat:@"%02x", hexBytesLight[0]];
        
        //如果获取到的值的第一个字节是不是“07”，如果是，就对数值进行操作，不是就舍去
        if ([Str1 isEqualToString:@"07"]) {
        
            if (![[NSString stringWithFormat:@"%02x", hexBytesLight[14]] isEqualToString:@"00"]) {
                NSLog(@"berbarbaerb===%@",[NSString stringWithFormat:@"%02x", hexBytesLight[14]]);
                NSString*dianliang=[NSString stringWithFormat:@"%02x", hexBytesLight[14]];
                
                for(int i=0;i<dianliang.length;i++)
                {
                    /// 两位16进制数转化后的10进制数
                    
                    unichar hex_char1 = [dianliang characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
                    int int_ch1;
                    if(hex_char1 >= '0' && hex_char1 <='9')
                        int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
                    else if(hex_char1 >= 'A' && hex_char1 <='F')
                        int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
                    else
                        int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
                    i++;
                    
                    unichar hex_char2 = [dianliang characterAtIndex:i]; ///两位16进制数中的第二位(低位)
                    int int_ch2;
                    if(hex_char2 >= '0' && hex_char2 <='9')
                        int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
                    else if(hex_char1 >= 'A' && hex_char1 <='F')
                        int_ch2 = hex_char2-55; //// A 的Ascll - 65
                    else
                        int_ch2 = hex_char2-87; //// a 的Ascll - 97
                    
                    int qian= int_ch1+int_ch2;
                    NSLog(@"电量是：%d",qian);
                    self.dianlianglabel.text=[NSString stringWithFormat:@"%d",qian];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }
            }
        }
        if ([Str1 isEqualToString:@"00"]) {
            NSLog(@"时间设置成功，时间为 == %s",hexBytesLight);
        }else if ([Str1 isEqualToString:@"80"]) {
            NSLog(@"时间设置失败，失败校验为 == %s",hexBytesLight);
        }
    }

}
#pragma mark -扫描到的CBPeripheral插入tableview
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData{
    if(![peripherals containsObject:peripheral]){
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        [peripherals addObject:peripheral];
        [peripheralsAD addObject:advertisementData];
        [self.tableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - tabledelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return peripherals.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"cell"];
    CBPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];
    NSDictionary *ad = [peripheralsAD objectAtIndex:indexPath.row];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
    NSString *localName;
    if ([ad objectForKey:@"kCBAdvDataLocalName"]) {
        localName = [NSString stringWithFormat:@"%@",[ad objectForKey:@"kCBAdvDataLocalName"]];
    }else{
        localName = peripheral.name;
    }
    
    cell.textLabel.text = localName;
    
    
    return cell;

   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    //停止扫描
    
    [baby cancelScan];
     [baby cancelAllPeripheralsConnection];
   
    NSLog(@"indexPath.row=%ld",(long)indexPath.row);
    self.bluetoothPeripheral=[peripherals objectAtIndex:indexPath.row];
    
    [self reloadDataBluetooth];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)reloadDataBluetooth
{
    baby.having(self.bluetoothPeripheral).connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}


#pragma 手动断开
- (IBAction)duankai:(id)sender {
    if ([self.duankaiSwitch isOn]) {
        
    }
    else{
        //[baby cancelNotify:self.bluetoothPeripheral characteristic:self.bluetoothviewCharacteristic];
        [baby cancelAllPeripheralsConnection];
    
        self.label.text=@"未连接设备";
        self.beaconView.image=[UIImage imageNamed:@"unconnet"];
        self.duankaiSwitch.enabled=NO;

//        TabBarViewController*vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        
//        [self presentViewController:vc animated:YES completion:^{
//            
//        }];
    
    }
    
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.viewH.constant=[UIScreen mainScreen].bounds.size.height*0.4;
    self.searchImageH.constant=[UIScreen mainScreen].bounds.size.height*0.4/2;
    self.searchImageH.constant=[UIScreen mainScreen].bounds.size.height*0.4/2;
    
}




@end
