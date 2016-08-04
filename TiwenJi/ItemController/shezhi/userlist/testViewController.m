//
//  testViewController.m
//  TiwenJi
//
//  Created by 莫福见 on 16/4/11.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "testViewController.h"


@interface testViewController ()
@property (strong, nonatomic) IBOutlet UITextField *String;

@end

@implementation testViewController
@synthesize Delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ok:(id)sender {
    if (self.String.text.length<=0) {
        NSLog(@"名字不能为空");
    }
    else
    {
        if (self.Delegate && [self.Delegate respondsToSelector:@selector(NokButtonClicked:Labelstring:)]) {
            [self.Delegate NokButtonClicked:self Labelstring:self.String.text ];
        }
    }
}
- (IBAction)cancle:(id)sender {
    [self.Delegate NcancelButtonClicked:self];
}
- (IBAction)done:(id)sender {
    NSLog(@"///////////");
}
- (IBAction)exit:(id)sender {
    NSLog(@"00000000000");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
