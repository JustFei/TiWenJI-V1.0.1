//
//  wenduchuli.m
//  TiwenJi
//
//  Created by 莫福见 on 16/3/15.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "wenduchuli.h"

@implementation wenduchuli
-(NSString*)pass:(NSString*)zhengshu xiaoshu:(NSString*)xiaoshu{
    int qian = 0;
    int hou = 0;
    NSString*lsat;
    NSString*ling=@"0";
    for(int i=0;i<zhengshu.length;i++)
    {
        /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [zhengshu characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [zhengshu characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        qian= int_ch1+int_ch2;
        
        
    }
    
    
    
    for(int i=0;i<xiaoshu .length;i++)
    {
        /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [xiaoshu characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [xiaoshu characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        hou = int_ch1+int_ch2;
        
        
    }
    NSString *shengshustr=[NSString stringWithFormat:@"%d",qian];
    NSString*dian=@".";
    NSString*newstr=[shengshustr stringByAppendingString:dian];
    if (hou<10) {
        
         NSString*xiaoshustr=[ling stringByAppendingString:[NSString stringWithFormat:@"%d",hou] ];
        lsat=[newstr stringByAppendingString:xiaoshustr];
    }
    else
    {
    NSString*xiaoshustr=[NSString stringWithFormat:@"%d",hou];
    
        lsat=[newstr stringByAppendingString:xiaoshustr];
    }
    return lsat;
}
@end
