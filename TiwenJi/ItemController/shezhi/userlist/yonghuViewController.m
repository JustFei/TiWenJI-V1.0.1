//
//  yonghuViewController.m
//  Newthermometer
//
//  Created by 莫福见 on 16/2/23.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "yonghuViewController.h"
#import "UIViewController+MJPopupViewController.h"

#import "AppDelegate.h"
#import "WenduData.h"
#import "testViewController.h"
#import "otherpopViewController.h"

#import "Test.h"





@interface yonghuViewController ()<MJSecondPopupDelegate,testDelegate>{
     UIImage *image;
    otherpopViewController*secondDetailViewController;
    BOOL trun;
    testViewController*nameview;
}
@property(nonatomic ,strong)AppDelegate*myappdelegate;
@property(nonatomic,strong)NSMutableArray*datasuore;
@end

@implementation yonghuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self iconSeting];
     self.datasuore=[[NSMutableArray alloc]init];
     self.myappdelegate=[UIApplication sharedApplication].delegate;
    self.savebutton.enabled=NO;
    self.tizhongbutton.enabled=NO;
    self.shengaobutton.enabled=NO;
    self.nianlingbutton.enabled=NO;
    self.xingbiebutton.enabled=NO;
    self.xingmingbutton.enabled=NO;
    self.touxianbutton.enabled=NO;
    [self set];
    
    UISwipeGestureRecognizer*swpi=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [swpi setDirection:UISwipeGestureRecognizerDirectionDown];
    [[self view]addGestureRecognizer:swpi];
}
-(void)set{
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"iconimage"];
    
    if(imageData != nil)
    {
        UIImage*image1= [UIImage imageWithData:imageData];
        [self.iconimageView setImage:image1];
        
    }
    else
    {
        [self.iconimageView setImage:[UIImage imageNamed:@"icon"]];
    }
    
    NSString*name=[[NSUserDefaults standardUserDefaults] objectForKey:@"suername"];
    
    if (name==nil)
    {
        self.nameText.text=NSLocalizedString(@"UserName", nil);
    }
    else
    {
        self.nameText.text=name;
    }
    
    NSString*age=[[NSUserDefaults standardUserDefaults] objectForKey:@"suerage"];
    
    if (age==nil)
    {
        self.agetext.text=@"0";
    }
    else
    {
        self.agetext.text=age;
    }
 
    NSString*height=[[NSUserDefaults standardUserDefaults] objectForKey:@"suerheight"];
    
    if (height==nil)
    {
        self.hightText.text=@"0";
    }
    else
    {
        self.hightText.text=height;
    }
    
     NSString*weiht=[[NSUserDefaults standardUserDefaults] objectForKey:@"suerweiht"];
    if (weiht==nil)
    {
        self.weihtText.text=@"0";
    }
    else
    {
        self.weihtText.text=weiht;
    }
    
    BOOL sex= [[NSUserDefaults standardUserDefaults] objectForKey:@"suersex"];
    if (sex==1)
    {
        self.sexlabel.text=NSLocalizedString(@"Gender", nil);
    }
    else
    {
        self.sexlabel.text=NSLocalizedString(@"GenderFmale", nil);
    }
  
    
}

-(void)iconSeting{
    
    self.iconimageView.layer.masksToBounds=YES;
    self.iconimageView.layer.cornerRadius=self.iconimageView.bounds.size.width*0.5;
    self.iconimageView.layer.cornerRadius=[UIScreen mainScreen].bounds.size.width*0.3/2;

    
    
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    [self refreshdata];
    [self.tableview reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
    [self.datasuore removeAllObjects];
    
}
-(void)refreshdata{
    NSFetchRequest*requst=[[NSFetchRequest alloc]initWithEntityName:@"WenduData"];
    NSArray*result=[self.myappdelegate.managedObjectContext executeFetchRequest:requst error:nil];
    [self.datasuore addObjectsFromArray:result];
}


#pragma mark 名字VIEW弹出按钮
- (IBAction)NamePopOutButton:(id)sender {
    
}

#pragma mark 年龄身高体重选择VIEW弹出
- (IBAction)popOutbButton:(id)sender {
    UIButton*button=sender;
    NSLog(@"%ld",(long)button.tag);
    if (button.tag==1) {
        nameview=nil;
        nameview=[[testViewController alloc]initWithNibName:@"testViewController" bundle:nil];
        nameview.Delegate=self;
        [self presentPopupViewController:nameview animationType:MJPopupViewAnimationFade];
    }else{
     secondDetailViewController = nil;
   secondDetailViewController= [[otherpopViewController alloc]initWithNibName:@"otherpopViewController" bundle:nil];
      secondDetailViewController.delegate = self;
    
    [self presentPopupViewController:secondDetailViewController animationType:MJPopupViewAnimationFade];
    
    self.passSenderdelegate=secondDetailViewController;
      [self.passSenderdelegate passSender:(int)button.tag];
    
    }
}

#pragma mark - 头像选择按钮
- (IBAction)changeiconimageButton:(id)sender {
    NSLog(@"选择头像按钮");
    NSLog(@"icon");
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  
                                  initWithTitle:@"请选择"
                                  
                                  delegate:self
                                  
                                  cancelButtonTitle:@"取消"
                                  
                                  destructiveButtonTitle:nil
                                  
                                  otherButtonTitles:@"相机",@"相册",nil];
    
    [actionSheet showInView:self.view];
    
    
}
#pragma UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    NSLog(@"buttonIndex = [%ld]",(long)buttonIndex);
    
    switch (buttonIndex) {
            
        case 0://照相机
            
        {
            [self camera];
            
            
        }
            
            break;
            
            
            
        case 1://本地相簿
            
        {
            
            [self potolist];
            
        }
            
            
            break;
            
        default:
            
            break;
            
    }
    
}
#pragma mark -从摄像头获取照片
-(void)camera{
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) { //若不可用，弹出警告框
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"无可用摄像头" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert1 show];
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    /**
     *      UIImagePickerControllerSourceTypePhotoLibrary  ->所有资源文件夹
     UIImagePickerControllerSourceTypeCamera        ->摄像头
     UIImagePickerControllerSourceTypeSavedPhotosAlbum ->内置相册
     */
    imagePicker.delegate = self;    //设置代理，遵循UINavigationControllerDelegate,UIImagePickerControllerDelegate协议
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
#pragma mark -从相册获取照片
-(void)potolist{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
#pragma mark - 拍照协议方法的实现
//协议方法，选择完毕以后，呈现在imageShow里面
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"info>>>%@",info);  //UIImagePickerControllerMediaType,UIImagePickerControllerOriginalImage,UIImagePickerControllerReferenceURL
    NSString *mediaType = info[@"UIImagePickerControllerMediaType"];
    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
        
        UIImage *imageb= [info objectForKey:UIImagePickerControllerOriginalImage];
        //        userImageView.image = image;
        UIGraphicsBeginImageContext(self.iconimageView.frame.size);
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = CGPointZero;
        thumbnailRect.size.width  = [UIScreen mainScreen].bounds.size.height*0.2;
        thumbnailRect.size.height = [UIScreen mainScreen].bounds.size.height*0.2;
        
        [imageb drawInRect:thumbnailRect];
        
        UIImage*bbb = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self.iconimageView setImage:bbb];
        //        UIImage*bbb=[];
        NSLog(@"image>>>%@",bbb);
        
        //        NSUserDefaults *userDefalults = [NSUserDefaults standardUserDefaults];
        //        [userDefalults setObject:userImageView.image forKey:@"Image"];
        //        [userDefalults synchronize];
        
        NSData *imageData = UIImagePNGRepresentation(image); //PNG格式
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"userName"];
        
        //通过判断picker的sourceType，如果是拍照则保存到相册去
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    //  else  当然可能是视频，这里不作讨论~方法是类似的~
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
}

- (IBAction)AddButton:(id)sender {

        
        
        
        
 
        self.savebutton.enabled=YES;
        self.tizhongbutton.enabled=YES;
        self.shengaobutton.enabled=YES;
        self.nianlingbutton.enabled=YES;
        self.xingbiebutton.enabled=YES;
        self.xingmingbutton.enabled=YES;
        self.touxianbutton.enabled=YES;
    
        [self.savebutton setBackgroundColor:[UIColor blueColor]];
        
         self.infotouxian.image=[UIImage imageNamed:@"user_edit.png"];
        self.infoname.image=[UIImage imageNamed:@"user_edit.png"];
        self.infoage.image=[UIImage imageNamed:@"user_edit.png"];
        self.infoheigt.image=[UIImage imageNamed:@"user_edit.png"];
        self.infoweiht.image=[UIImage imageNamed:@"user_edit.png"];
        self.infosex.image=[UIImage imageNamed:@"user_edit.png"];

    
    
}

- (IBAction)changsexButton:(id)sender {
    NSLog(@"sex");
    
    //获取当前设备的语言
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    if ([preferredLang isEqualToString:@"zh-Hans"]) {
        //如果是简体中文就按照男女来设置
        if ([self.sexlabel.text isEqualToString:@"女"]) {
            self.sexlabel.text=NSLocalizedString(@"Gender", nil);
        }
        else{
            self.sexlabel.text=NSLocalizedString(@"GenderFmale", nil);
        }
    }else {
        //如果是其他语言的话就设置Fmale
        if ([self.sexlabel.text isEqualToString:@"Fmale"]) {
            self.sexlabel.text = NSLocalizedString(@"Gender", nil);
        }else {
            self.sexlabel.text = NSLocalizedString(@"GenderFmale", nil);
        }
    }
    
    
}

#pragma mark  保存到数据库
- (IBAction)saveButton:(id)sender {
    NSLog(@"保存信息按钮");
    self.savebutton.enabled=NO;
    self.tizhongbutton.enabled=NO;
    self.shengaobutton.enabled=NO;
    self.nianlingbutton.enabled=NO;
    self.xingbiebutton.enabled=NO;
    self.xingmingbutton.enabled=NO;
    self.touxianbutton.enabled=NO;
    
    self.infotouxian.image=[UIImage imageNamed:@""];
    self.infoname.image=[UIImage imageNamed:@""];
    self.infoage.image=[UIImage imageNamed:@""];
    self.infoheigt.image=[UIImage imageNamed:@""];
    self.infoweiht.image=[UIImage imageNamed:@""];
    self.infosex.image=[UIImage imageNamed:@""];
    
    
    NSData *data;
    if (UIImagePNGRepresentation(self.iconimageView.image) == nil) {
        data = UIImageJPEGRepresentation(self.iconimageView.image, 1);
    } else {
        data = UIImagePNGRepresentation(self.iconimageView.image);
    }
   
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"WenduData" inManagedObjectContext:self.myappdelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * agePre = [NSPredicate predicateWithFormat:@"name like[cd] %@",self.nameText.text];
    [fetchRequest setPredicate:agePre];
    NSError * requestError = nil;
    NSArray * persons = [self.myappdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    if ([persons count]>0) {
        for (WenduData*pp in persons) {
            
            pp.name=self.nameText.text;
            [self updateuser:pp];
        }
    }
    else
    {
        
        // 创建实体
        WenduData * newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"WenduData" inManagedObjectContext:self.myappdelegate.managedObjectContext];
        // 赋值
        if (newPerson != nil)
        {
            newPerson.name=self.nameText.text;
            newPerson.age=self.agetext.text;
            newPerson.sex=self.sexlabel.text;
            newPerson.height=self.hightText.text;
            newPerson.weiht=self.weihtText.text;
            newPerson.iconImage=data;
            
            
            // 保存数据
            if ([self.myappdelegate.managedObjectContext save:nil])
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
    
    [self.datasuore removeAllObjects];
    [self refreshdata];
    
    [self.tableview reloadData];
    
    UIAlertView *saveSuccessView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil, nil];
    [saveSuccessView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateuser:(WenduData*)user{
    
    [self.datasuore removeAllObjects];
    NSData *data;
    if (UIImagePNGRepresentation(self.iconimageView.image) == nil) {
        
        data = UIImageJPEGRepresentation(self.iconimageView.image, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(self.iconimageView.image);
    }
    
    user.name=self.nameText.text;
    user.age=self.agetext.text;
    user.sex=self.sexlabel.text;
    user.height=self.hightText.text;
    user.weiht=self.weihtText.text;
    user.iconImage=data;
    [self.myappdelegate.managedObjectContext save:nil];
    NSLog(@"已更新");
    
    
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)action{
    if (action.direction==UISwipeGestureRecognizerDirectionDown) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    CGFloat mainboundsheight=[UIScreen mainScreen].bounds.size.height;
    CGFloat mainboundswidth=[UIScreen mainScreen].bounds.size.width;
    self.cellheight.constant=mainboundsheight*0.05;
    
    self.iconimageviewH.constant=mainboundswidth*0.3;
    self.iconimageviewW.constant=mainboundswidth*0.3;
    
    self.iconimagebuttonH.constant=mainboundswidth*0.3;
    self.iconimagebuttonW.constant=mainboundswidth*0.3;
}


#pragma mark - tabledelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return self.datasuore.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[self.tableview dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textAlignment=UITextAlignmentCenter;
        WenduData*des=self.datasuore[indexPath.row];
        cell.textLabel.text=des.name;
        cell.backgroundColor=[UIColor clearColor];
       
      
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ;
  
    NSLog(@"这里退出POP 还要传数据过去");
    WenduData*des=self.datasuore[indexPath.row];
    self.nameText.text=des.name;
    self.hightText.text=des.height;
    self.weihtText.text=des.weiht;
    
    //获取当前设备的语言
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    if ([preferredLang isEqualToString:@"zh-Hans"]) {
        //如果是简体中文就按照男女来设置
        if ([self.sexlabel.text isEqualToString:@"女"]) {
            self.sexlabel.text=NSLocalizedString(@"Gender", nil);
        }
        else{
            self.sexlabel.text=NSLocalizedString(@"GenderFmale", nil);
        }
    }else {
        //如果是其他语言的话就设置Fmale
        if ([self.sexlabel.text isEqualToString:@"Fmale"]) {
            self.sexlabel.text = NSLocalizedString(@"Gender", nil);
        }else {
            self.sexlabel.text = NSLocalizedString(@"GenderFmale", nil);
        }
    }
//    self.sexlabel.text = des.sex;
    
    self.agetext.text=des.age;
    self.iconimageView.image=[UIImage imageWithData:des.iconImage];
   
    NSData *imageData = UIImagePNGRepresentation([UIImage imageWithData: des.iconImage]); //PNG格式
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"iconimage"];
    [[NSUserDefaults standardUserDefaults] setValue:des.name forKey:@"suername"];
     [[NSUserDefaults standardUserDefaults] setValue:des.height forKey:@"suerheight"];
     [[NSUserDefaults standardUserDefaults] setValue:des.weiht forKey:@"suerweiht"];
     [[NSUserDefaults standardUserDefaults] setValue:des.sex forKey:@"suersex"];
     [[NSUserDefaults standardUserDefaults] setValue:des.age forKey:@"suerage"];
        
        
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ;
    return 40;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}
-(BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//删除用户时的操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   WenduData*newmodels=self.datasuore[indexPath.row];
   
    
    //CoreData请求命令集
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    //实体描述，即表明为Test，
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Test" inManagedObjectContext:self.myappdelegate.managedObjectContext];
    //给这个命令指定一个表：Test
    [fetchRequest setEntity:entity];
    //谓词
    NSPredicate * agePre = [NSPredicate predicateWithFormat:@"name like[cd] %@",newmodels.name];
    
    NSLog(@"沙盒 == %@, 当前选中 == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"suername"] ,newmodels.name);
    
    //给命令具体执行内容，内容为查找，查找 name为沙盒中存储的suername
    [fetchRequest setPredicate:agePre];
    NSError * requestError = nil;
    //执行这个命令，获得结果persons
    NSArray * persons = [self.myappdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    NSLog(@"persons == %@, count = %lu",persons ,(unsigned long)persons.count);
    
    if (!requestError) {
        NSLog(@"aaa");
        for (Test *object in persons) {
            NSLog(@"eee");
            NSLog(@"%@", object);
            [self.myappdelegate.managedObjectContext deleteObject:object];
        }
    }
    
    
    
    [self.datasuore removeObject:newmodels];
    [self.myappdelegate.managedObjectContext deleteObject:newmodels];
    [self.myappdelegate saveContext];
    [self.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}
- (void)NcancelButtonClicked:(testViewController*)secondDetailViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    nameview = nil;
    
}
- (void)NokButtonClicked:(testViewController *)aSecondDetailViewController Labelstring:(NSString*)labelstring{
    self.nameText.text=labelstring;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    nameview = nil;
    
}

- (void)cancelButtonClicked:(otherpopViewController *)aSecondDetailViewController
{
    NSLog(@"tuichipop");
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    secondDetailViewController = nil;
}
- (void)okButtonClicked:(otherpopViewController *)aSecondDetailViewController item:(NSString*)Item sender:(int)Sender
{
    NSLog(@"tuichipop");
    NSLog(@"Item=%@",Item);
    NSLog(@"Sender=%d",Sender);
    switch (Sender) {
        case 3:
            self.agetext.text=Item;
            break;
        case 4:
            self.hightText.text=Item;
            break;
        case 5:
            self.weihtText.text=Item ;
            break;
            
        default:
            break;
    }
    
    
    
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    secondDetailViewController = nil;
}

@end

