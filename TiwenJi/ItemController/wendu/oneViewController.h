//
//  oneViewController.h
//  Newthermometer
//
//  Created by 莫福见 on 16/2/22.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

@protocol onepassButtonSenderDelegate<NSObject>

-(void)passSender:(NSString*)mingz Wendu:(NSString*)wendu;

@end
@interface oneViewController : UIViewController<UIWebViewDelegate,UITextFieldDelegate>{
@public
    BabyBluetooth *babycao;
}
@property (strong, nonatomic) id <onepassButtonSenderDelegate>passSenderdelegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonH;
@property (weak, nonatomic) IBOutlet UIButton *wenbutton;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vieww;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Viewh;


-(void)lianjie;
@end
