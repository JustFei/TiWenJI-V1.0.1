//
//  qidongViewController.m
//  TiwenJi
//
//  Created by 莫福见 on 16/3/23.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "qidongViewController.h"
#import "TabBarViewController.h"

@interface qidongViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong) CBPeripheral *qidongperipheral;
@property(nonatomic,strong) NSTimer*yanshi;
@property(nonatomic,assign)int daojishi;
@property(nonatomic,assign)TabBarViewController*vc;
@property(nonatomic,strong)CBCharacteristic*qiongdongviewCharacteristic;
@end

@implementation qidongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"qidongViewController viewDidLoad");
    _daojishi=4;
    baby = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate ];
    
    baby.scanForPeripherals().begin().stop(5);
    
    _yanshi=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(caozhou) userInfo:nil repeats:YES];
    
      _vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TabBarViewController"];
}


-(void)babyDelegate{
    //设置扫描到设备的委托
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"%@",peripheral.name);
        
        [weakSelf insertCBPeripheral:peripheral ];
    }];
    //连接设备成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"成功连接了设备%@",peripheral.name);
        
    }];
    
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"连接上次设备失败");
        [weakSelf presentToMian];
    }];
    
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        //如果发现服务失败，跳转到主界面
        if (error) {
            UIAlertView *showFailView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hint", nil) message:NSLocalizedString(@"HintInfo", nil) delegate:weakSelf cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [showFailView show];
        }
    }];
    
    //设置查找到Characteristics的block
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
         [weakSelf insertRowToTableView:service];
    }];
    
}

#pragma mark 已连接的CBCharacteristic和设置通知

-(void)insertRowToTableView:(CBService *)service{
    
    self.qiongdongviewCharacteristic=[service.characteristics objectAtIndex:0];
    [self setnotificationison];
    
}
#pragma mark  设置通知
-(void)setnotificationison{
    
    
    [baby notify:self.qidongperipheral
     characteristic:self.qiongdongviewCharacteristic
              block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                  
                  [self insertReadValues:characteristics];
                  
              }];
//    [self huoqudianliang];
    [self setTime];
}

-(void)insertReadValues:(CBCharacteristic *)characteristics{
    if ([characteristics.value bytes]!=nil) {
        const unsigned char *hexBytesLight = [characteristics.value bytes];
        
        NSString *Str1 = [NSString stringWithFormat:@"%02x", hexBytesLight[0]];
        
        //如果获取到的值的第一个字节是不是“07”，如果是，就对数值进行操作，不是就舍去
//        if ([Str1 isEqualToString:@"07"]) {
//            if (![[NSString stringWithFormat:@"%02x", hexBytesLight[14]] isEqualToString:@"00"]) {
//                NSLog(@"berbarbaerb===%@",[NSString stringWithFormat:@"%02x", hexBytesLight[14]]);
//                NSString*dianliang=[NSString stringWithFormat:@"%02x", hexBytesLight[14]];
//                
//                for(int i=0;i<dianliang.length;i++)
//                {
//                    /// 两位16进制数转化后的10进制数
//                    
//                    unichar hex_char1 = [dianliang characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
//                    int int_ch1;
//                    if(hex_char1 >= '0' && hex_char1 <='9')
//                        int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
//                    else if(hex_char1 >= 'A' && hex_char1 <='F')
//                        int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
//                    else
//                        int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
//                    i++;
//                    
//                    unichar hex_char2 = [dianliang characterAtIndex:i]; ///两位16进制数中的第二位(低位)
//                    int int_ch2;
//                    if(hex_char2 >= '0' && hex_char2 <='9')
//                        int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
//                    else if(hex_char1 >= 'A' && hex_char1 <='F')
//                        int_ch2 = hex_char2-55; //// A 的Ascll - 65
//                    else
//                        int_ch2 = hex_char2-87; //// a 的Ascll - 97
//                    
//                    int qian= int_ch1+int_ch2;
//                    [[NSUserDefaults standardUserDefaults] setInteger:qian forKey:@"dianliang"];
//                }
//            }
//        }
        
        //设置时间
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
        
    }
    
    [self presentToMian];
    
//    TabBarViewController*vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TabBarViewController"];
//    
//    //延迟3秒推送到主界面
//    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    //        [self presentViewController:vc animated:YES completion:^{}];
//    //    });
//    
//    
//    [self presentViewController:vc animated:YES completion:^{}];
    
    
}
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
    [self.qidongperipheral writeValue:data forCharacteristic:self.qiongdongviewCharacteristic type:CBCharacteristicWriteWithResponse];
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
    [self.qidongperipheral writeValue:data forCharacteristic:self.qiongdongviewCharacteristic type:CBCharacteristicWriteWithResponse];
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

-(void)insertCBPeripheral:(CBPeripheral*)per{
    if ([[per.identifier UUIDString]isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"identifier"]]) {
        self.qidongperipheral=per;
    }
  
}
-(void)caozhou{
    _daojishi--;
    if (_daojishi==0) {
        if (self.qidongperipheral!=nil) {
            NSLog(@"%ld",(long)self.qidongperipheral.state);
            if (self.qidongperipheral.state!=0) {
                TabBarViewController*vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        
                [self presentViewController:vc animated:YES completion:^{}];
                [_yanshi invalidate];
                _yanshi=nil;
            }
            else
            {
                    NSLog(@"最后一次使用设备不为空");
                    NSLog(@"======%@",self.qidongperipheral);
                    NSString*str=NSLocalizedString(@"LastPer", nil);
                    
                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"QidongTitle", nil) message:[str stringByAppendingString:self.qidongperipheral.name] delegate:self cancelButtonTitle:NSLocalizedString(@"QidongCancel", nil) otherButtonTitles:NSLocalizedString(@"QidongSure", nil), nil];
                    [alert show];
                    [_yanshi invalidate];
                    _yanshi=nil;
            }
        }
        else
        {
              NSLog(@"没有使用过的设备");

            [self presentToMian];
            
//            TabBarViewController*vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TabBarViewController"];
//            
//            [self presentViewController:vc animated:YES completion:^{}];
        }
       
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0)
    {
        //不连接上次设备，直接跳转
        [self presentToMian];
    }
    else
    {
             baby.having(self.qidongperipheral).connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    }
}

- (void)presentToMian
{
    TabBarViewController*vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    
    [self presentViewController:vc animated:YES completion:^{}];
}

@end
