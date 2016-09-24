//
//  LO_ViewController.h
//  Camera
//
//  Created by 石云雷 on 14-7-15.
//  Copyright (c) 2014年 www.lanou3g.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LO_ViewController : UIViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImageView *imageView;

@end
