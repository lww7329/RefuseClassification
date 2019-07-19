//
//  SelectPhotoManager.m
//  SelectPhoto
//
//  Created by 吉祥 on 2017/8/29.
//  Copyright © 2017年 jixiang. All rights reserved.
//

#import "SelectPhotoManager.h"
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>
@implementation SelectPhotoManager {
    //图片名
    NSString *_imageName;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _canEditPhoto = YES;
    }
    return self;
}

//开始选择照片
- (void)startSelectPhotoWithImageName:(NSString *)imageName{
    _imageName = imageName;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"选择图片"];
//    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
    [alertControllerStr addAttribute:NSFontAttributeName value:nAdaptedSystemFontWithSize(17) range:NSMakeRange(0, 4)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
 
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectPhotoWithType:0];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选择" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectPhotoWithType:1];
    }]];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
}

//根据类型选取照片
- (void)startSelectPhotoWithType:(SelectPhotoType)type andImageName:(NSString *)imageName {
    _imageName = imageName;
    UIImagePickerController *ipVC = [[UIImagePickerController alloc] init];
    //设置跳转方式
    ipVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    if (_canEditPhoto) {
        //设置是否可对图片进行编辑
        ipVC.allowsEditing = YES;
    }
    
    ipVC.delegate = self;
    if (type == PhotoCamera) {
        NSLog(@"相机");
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            NSLog(@"没有摄像头");
            if (_errorHandle) {
                _errorHandle(@"没有摄像头");
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备不支持拍照" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];
            [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
            return ;
        }
        
        //相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
            authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
        {
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:[NSDictionary dictionary] completionHandler:nil];
            }
            return ;
        }
        
        ipVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else{
        NSLog(@"相册");
        
        //相册权限
        if([UIDevice currentDevice].systemVersion.floatValue >= 9.0f){
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusRestricted ||
                status == PHAuthorizationStatusDenied) {
                //无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url options:[NSDictionary dictionary] completionHandler:nil];
                }
                return;
            }
        }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author ==kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
                //无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url options:[NSDictionary dictionary] completionHandler:nil];
                }
                return ;
            }
#pragma clang diagnostic pop
        }
        
        ipVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [[self getCurrentVC] presentViewController:ipVC animated:YES completion:nil];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    
    if (_superVC) {
        return _superVC;
    }
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
        
    }else{
        result = window.rootViewController;
    }
    return result;
}

#pragma mark 方法
-(void)selectPhotoWithType:(int)type {
    if (type == 2) {
        NSLog(@"取消");
    }else{
        if(self.updateFlagHandle){
            self.updateFlagHandle();
        }
        
        UIImagePickerController *ipVC = [[UIImagePickerController alloc] init];
        //设置跳转方式
        ipVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        if (_canEditPhoto) {
            //设置是否可对图片进行编辑
            ipVC.allowsEditing = YES;
        }
        
        ipVC.delegate = self;
        if (type == 0) {
            NSLog(@"相机");
            BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
            if (!isCamera) {
                NSLog(@"没有摄像头");
                if (_errorHandle) {
                    _errorHandle(@"没有摄像头");
                }
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备不支持拍照" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                }]];
                [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
                return ;
            }
            
            //相机权限
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
                authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"为了扫描识别垃圾,需要开启App的相机权限" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }]];
                [alertController addAction: [UIAlertAction actionWithTitle: @"去设置" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    // 无权限 引导去开启
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication]canOpenURL:url]) {
                        [[UIApplication sharedApplication]openURL:url options:[NSDictionary dictionary] completionHandler:nil];
                    }
                }]];
                [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
                return ;
            }
            
            ipVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }else{
            NSLog(@"相册");
            
            //相册权限
            if([UIDevice currentDevice].systemVersion.floatValue >= 9.0f){
                PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
                if (status == PHAuthorizationStatusRestricted ||
                    status == PHAuthorizationStatusDenied) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"为了读取照片识别垃圾,需要开启App的相册权限" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    }]];
                    [alertController addAction: [UIAlertAction actionWithTitle: @"去设置" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        // 无权限 引导去开启
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication]canOpenURL:url]) {
                            [[UIApplication sharedApplication]openURL:url options:[NSDictionary dictionary] completionHandler:nil];
                        }
                    }]];
                    [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
                    return ;
                }
            }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
                if (author ==kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"为了读取照片识别垃圾,需要开启App的相册权限" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    }]];
                    [alertController addAction: [UIAlertAction actionWithTitle: @"去设置" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        // 无权限 引导去开启
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication]canOpenURL:url]) {
                            [[UIApplication sharedApplication]openURL:url options:[NSDictionary dictionary] completionHandler:nil];
                        }
                    }]];
                    [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
                    return ;
                }
#pragma clang diagnostic pop
            }
            
            ipVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [[self getCurrentVC] presentViewController:ipVC animated:YES completion:nil];
    }
}

#pragma mark -----------------imagePickerController协议方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"info = %@",info);
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (image == nil) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    //图片旋转
    if (image.imageOrientation != UIImageOrientationUp) {
        //图片旋转
        image = [self fixOrientation:image];
    }
    if (_imageName==nil || _imageName.length == 0) {
        //获取当前时间,生成图片路径
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:date];
        _imageName = [NSString stringWithFormat:@"photo_%@.png",dateStr];
    }

    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectPhotoManagerDidFinishImage:)]) {
        [_delegate selectPhotoManagerDidFinishImage:image];
    }
    
    if (_successHandle) {
        _successHandle(self,image);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(selectPhotoManagerDidError:)]) {
        [_delegate selectPhotoManagerDidError:nil];
    }
    if (_errorHandle) {
        _errorHandle(@"撤销");
    }
}

#pragma mark 图片处理方法
//图片旋转处理
- (UIImage *)fixOrientation:(UIImage *)aImage {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

