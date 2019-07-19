//
//  CheckViewController.m
//  RefuseClassification
//
//  Created by wei.z on 2019/7/17.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import "CheckViewController.h"
#import "XHScanToolController.h"
#import "MBProgressHUD+YS.h"
#import "UIImage+GIF.h"
#import "ALNetWork.h"
#import "SelectPhotoManager.h"
#import "SYToolsMethod.h"
#import "ResultViewController.h"
@interface CheckViewController ()<XHScanToolControllerDelegate>
@property(nonatomic,strong)UIButton *checkButton;
@property(nonatomic,strong)UIButton *imageButton;
@property(nonatomic,strong)UIImageView *imageView;
@property (nonatomic, strong) XHScanToolController *scanToolVC;
@property (nonatomic,strong)SelectPhotoManager *photoManager;
@property (nonatomic,copy)NSString *AT;
@end

@implementation CheckViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestAccessToken];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.checkButton];
    [self.view addSubview:self.imageButton];
}
-(SelectPhotoManager *)photoManager{
    __weak typeof(self) mySelf=self;
    if(_photoManager==nil){
        _photoManager =[[SelectPhotoManager alloc] init];
        //选取照片成功
        _photoManager.successHandle=^(SelectPhotoManager *manager,UIImage *image){
            [mySelf requestUploadPhoto:image];
        };
        _photoManager.updateFlagHandle = ^{

        };
    }
    return _photoManager;
}


-(UIButton *)checkButton{
    if(!_checkButton){
        _checkButton=[[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-nAdaptedWidthValue(200))/2, CGRectGetMaxY(self.imageView.frame)+ nAdaptedWidthValue(50), nAdaptedWidthValue(200), 40)];
        [_checkButton setTitle:@"二维码扫一扫" forState:UIControlStateNormal];
        [_checkButton addTarget:self action:@selector(checkRB) forControlEvents:UIControlEventTouchUpInside];
        _checkButton.backgroundColor=UIColorWithRGBA(69, 121, 251, 1);
        _checkButton.layer.cornerRadius = nAdaptedWidthValue(10);
        _checkButton.layer.masksToBounds=YES;
    }
    return _checkButton;
}

-(UIButton *)imageButton{
    if(!_imageButton){
        _imageButton=[[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-nAdaptedWidthValue(200))/2, CGRectGetMaxY(self.checkButton.frame)+ nAdaptedWidthValue(20), nAdaptedWidthValue(200), 40)];
        [_imageButton setTitle:@"百度AI植物识别" forState:UIControlStateNormal];
        [_imageButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
        _imageButton.backgroundColor=UIColorWithRGBA(69, 121, 251, 1);
        _imageButton.layer.cornerRadius = nAdaptedWidthValue(10);
        _imageButton.layer.masksToBounds=YES;
    }
    return _imageButton;
}
-(void)selectImage{
    [self.photoManager startSelectPhotoWithImageName:@"选择图片"];
}
-(void)checkRB{
    if (self.scanToolVC.isCameraValid && self.scanToolVC.isCameraAllowed) {
        self.scanToolVC.scanDelegate = self;
        [self presentViewController:self.scanToolVC animated:YES completion:nil];
    }else{
        if (!self.scanToolVC.isCameraAllowed) {
            [MBProgressHUD showError:@"请在设备的设置-隐私-相机中允许访问相机"];
        }else if (!self.scanToolVC.isCameraValid){
            [MBProgressHUD showError:@"请检查你的摄像头"];
        }
    }
}
-(void)requestUploadPhoto:(UIImage *)image{
    NSData* data=[SYToolsMethod zipNSDataWithImage:image];
    [self requestImageResult:data];
    
}
-(void)requestAccessToken{
    NSString *url=@"https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=&client_secret=";
    [[ALNetWork share] getWithURL:url parameters:nil finished:^(NSDictionary *dic) {
        self.AT=dic[@"access_token"];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestImageResult:(NSData *)data{
    NSString *url=[NSString stringWithFormat:@"https://aip.baidubce.com/rest/2.0/image-classify/v1/plant?access_token=%@",self.AT];
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [[ALNetWork share] postWithURL:url parameters:[NSDictionary dictionaryWithObjectsAndKeys:encodedImageStr,@"image", nil] finished:^(NSDictionary *dic) {
        NSArray *array=dic[@"result"];
        ResultViewController *c=[[ResultViewController alloc] init];
        c.dataArray=array;
        c.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:c animated:YES];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
//    [[ALNetWork share] postWithUrlAndUpLoad:url parameters:nil andDATA:data progress:^(NSProgress * downloadProgress) {
//
//    } finished:^(NSDictionary *dic) {
//        NSLog(@"%@",dic);
//    } failed:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
}
//扫码代理回调方法
- (void)scanToolController:(XHScanToolController *)scanToolController completed:(NSString *)result{
    [scanToolController dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:result,@"name",@"1",@"score", nil];
    NSArray *array=[NSArray arrayWithObjects:dic, nil];
    ResultViewController *c=[[ResultViewController alloc] init];
    c.dataArray=array;
    c.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:c animated:YES];
}
-(UIImageView *)imageView{
    if(!_imageView){
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-nAdaptedWidthValue(189)*1.3)/2, nAdaptedHeightValue(100), nAdaptedWidthValue(189)*1.3, nAdaptedWidthValue(162)*1.3)];
        NSString * filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"world" ofType:@"gif"];
        NSData * imageData = [NSData dataWithContentsOfFile:filePath];
        _imageView.image=[UIImage sd_animatedGIFWithData:imageData];
    }
    return _imageView;
}
-(XHScanToolController *)scanToolVC{
    if(!_scanToolVC){
        _scanToolVC=[[XHScanToolController alloc] init];
    }
    return _scanToolVC;
}

@end
