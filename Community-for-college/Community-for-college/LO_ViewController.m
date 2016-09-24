//
//  LO_ViewController.m
//  Camera
//
//  Created by 石云雷 on 14-7-15.
//  Copyright (c) 2014年 www.lanou3g.com. All rights reserved.
//
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#import "LO_ViewController.h"
#import "NSObject+alertView.h"
@interface LO_ViewController ()
{
    AVCaptureDevice *device;
}

@property(nonatomic, strong) AVCaptureSession *avSession;

@end

@implementation LO_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.title = @"相册";
    
    
    _imageView = [[UIImageView alloc]initWithFrame:(CGRectMake((self.view.frame.size.width - 200) /2, 100, 200, 200))];
    _imageView.image = [UIImage imageNamed:@"artWorkImage.png"];
    [self.view addSubview:_imageView];
    
    //启动照相机按钮
    UIButton *camera_Button = [[UIButton alloc]initWithFrame:(CGRectMake((WIDTH - 100) / 2, CGRectGetMaxY(_imageView.frame) + 30, 100, 30))];
    [camera_Button addTarget:self action:@selector(cameraButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [camera_Button setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [camera_Button setTitle:@"照相机" forState:(UIControlStateNormal)];
    [self.view addSubview:camera_Button];
    
    //关闭闪光灯按钮
    UIButton *closeLightButton = [[UIButton alloc]initWithFrame:(CGRectMake((WIDTH - 100) / 2, CGRectGetMaxY(camera_Button.frame) + 30, 100, 30))];
    [closeLightButton setTitle:@"关闭闪光灯" forState:(UIControlStateNormal)];
    [closeLightButton addTarget:self action:@selector(closeFlashlight:) forControlEvents:(UIControlEventTouchUpInside)];
    [closeLightButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [self.view addSubview:closeLightButton];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark ------ 关闭闪光灯 ------
- (void)closeFlashlight:(id)sender {
    
    if (device.torchMode == AVCaptureTorchModeOn) { // 如果闪光灯已经打开，那么把闪光灯关闭
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration]; // 解除对设备硬件的独占
    }
    [NSObject alterString:@"闪光灯已经为您关闭"];
}

#pragma mark ------ 调用系统相机 ------
- (void)cameraButton:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相机" otherButtonTitles:@"图片库",@"闪光灯", nil];//UIActionSheet初始化，并设置delegate
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"打开系统照相机");
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;//设置UIImagePickerController的代理，同时要遵循UIImagePickerControllerDelegate，UINavigationControllerDelegate协议
                picker.allowsEditing = YES;//设置拍照之后图片是否可编辑，如果设置成可编辑的话会在代理方法返回的字典里面多一些键值。PS：如果在调用相机的时候允许照片可编辑，那么用户能编辑的照片的位置并不包括边角。
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;//UIImagePicker选择器的类型，UIImagePickerControllerSourceTypeCamera调用系统相机
                [self presentViewController:picker animated:YES completion:nil];
            }
            else{
                //如果当前设备没有摄像头
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"哎呀，当前设备没有摄像头。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
        case 1:
        {
            NSLog(@"打开系统图片库");
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                picker.delegate = self;
                picker.allowsEditing = YES;//是否可以对原图进行编辑
                
                //打开相册选择照片
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"图片库不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
        case 2:
        {
            NSLog(@"调用系统闪关灯");
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]; // 返回用于捕获视频数据的设备（摄像头）
                if (![device hasTorch]) {
                    NSLog(@"没有闪光灯");
                }else{
                    [device lockForConfiguration:nil]; // 请求独占设备的硬件性能
                    if (device.torchMode == AVCaptureTorchModeOff) {
                        [device setTorchMode: AVCaptureTorchModeOn]; // 打开闪光灯
                    }
                }
            }
            else
            {
                //如果当前设备没有摄像头
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"哎呀，当前设备没有摄像头。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            
            break;
        }
        case 3:
        {
            NSLog(@"取消");
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
#pragma mark - 拍照/选择图片结束
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"如果允许编辑%@",info);//picker.allowsEditing= YES允许编辑的时候 字典会多一些键值。
    //获取图片
    //    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//把图片存到图片库
        self.imageView.image = image;
    }else{
        self.imageView.image = image;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - 取消拍照/选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
