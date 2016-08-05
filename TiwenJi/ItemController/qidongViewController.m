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
        //NSLog(@"%@",[peripheral.identifier UUIDString]);
        
        
        [weakSelf insertCBPeripheral:peripheral ];
    }];
    //连接设备成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        
    
        
    
        
    }];
    
    
    
    
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
    [self huoqudianliang];
}
-(void)insertReadValues:(CBCharacteristic *)characteristics{
        if ([characteristics.value bytes]!=nil) {
        const unsigned char *hexBytesLight = [characteristics.value bytes];
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
                [[NSUserDefaults standardUserDefaults] setInteger:qian forKey:@"dianliang"];
                
                
            }
        }
        
    }
    

    
    TabBarViewController*vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    
    [self presentViewController:vc animated:YES completion:^{}];
    
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
                    NSString*str=@"上次次使用设备:";
                    
                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"是否连接" message:[str stringByAppendingString:self.qidongperipheral.name] delegate:self cancelButtonTitle:@"不连接" otherButtonTitles:@"连接", nil];
                    [alert show];
                    [_yanshi invalidate];
                    _yanshi=nil;
            }
        }
        else
        {
              NSLog(@"没有使用过的设备");
  
            
            TabBarViewController*vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TabBarViewController"];
            
            [self presentViewController:vc animated:YES completion:^{}];
        }
       
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0)
    {
        
    }
    else
    {
             baby.having(self.qidongperipheral).connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    }
    TabBarViewController*vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    
    [self presentViewController:vc animated:YES completion:^{}];
    
}

@end
