//
//  yonghuViewController.h
//  Newthermometer
//
//  Created by 莫福见 on 16/2/23.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol passButtonSenderDelegate<NSObject>

-(void)passSender:(int)sender;

@end




@interface yonghuViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate>{
    
    
        

}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconimageviewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconimageviewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconimagebuttonW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconimagebuttonH;

@property (weak, nonatomic) IBOutlet UILabel *sexlabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconimageView;
@property (weak, nonatomic) IBOutlet UILabel *agetext;
@property (weak, nonatomic) IBOutlet UILabel *hightText;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *weihtText;

@property (weak, nonatomic) IBOutlet UIButton *savebutton;
@property (weak, nonatomic) IBOutlet UIButton *tizhongbutton;
@property (weak, nonatomic) IBOutlet UIButton *shengaobutton;
@property (weak, nonatomic) IBOutlet UIButton *xingbiebutton;
@property (weak, nonatomic) IBOutlet UIButton *xingmingbutton;
@property (weak, nonatomic) IBOutlet UIButton *touxianbutton;
@property (weak, nonatomic) IBOutlet UIButton *nianlingbutton;

@property (weak, nonatomic) IBOutlet UIImageView *infotouxian;
@property (weak, nonatomic) IBOutlet UIImageView *infoname;
@property (weak, nonatomic) IBOutlet UIImageView *infosex;
@property (weak, nonatomic) IBOutlet UIImageView *infoweiht;
@property (weak, nonatomic) IBOutlet UIImageView *infoheigt;
@property (weak, nonatomic) IBOutlet UIImageView *infoage;

@property (strong, nonatomic) id <passButtonSenderDelegate>passSenderdelegate;
@end
