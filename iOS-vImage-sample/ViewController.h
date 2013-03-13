//
//  ViewController.h
//  iOS-vImage-sample
//
//  Created by JOJOAGOGOGO on 13/03/11.
//  Copyright (c) 2013年 JOJOAGOGOGO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "UIImage+Blurring.h"
#import "UIImage+Enhancing.h"
#import "UIImage+Filtering.h"
#import "UIImage+Masking.h"
#import "UIImage+Reflection.h"
#import "UIImage+Resizing.h"
#import "UIImage+Rotating.h"
#import "UIImage+Saving.h"


@interface ViewController: UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    UIImagePickerController *mPicker;
    UIImage *srcImage;
    int angle;
    
}
- (IBAction)selectPhoto:(id)sender;
- (IBAction)refreshPhoto:(id)sender;
- (IBAction)savePhoto:(id)sender;
- (IBAction)removeSelectedPhoto:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
