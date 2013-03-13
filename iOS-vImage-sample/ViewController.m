//
//  ViewController.m
//  iOS-vImage-sample
//
//  Created by JOJOAGOGOGO on 13/03/11.
//  Copyright (c) 2013年 JOJOAGOGOGO. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap
    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.imageView addGestureRecognizer:tap];
    
    self.scrollView.contentSize = CGSizeMake(500, 50);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addButton];

}


- (void)addButton {
    int x = 50 + 2;
    int width =50;
    int height = 50;
    int fontSize = 12;

    NSMutableDictionary *btns = [NSMutableDictionary dictionary];
    [btns setObject:@"grayscale:" forKey:@"Gray"];
    [btns setObject:@"blur:" forKey:@"Blur"];
    [btns setObject:@"britenWhite:" forKey:@"BrWhite"];
    [btns setObject:@"edgeDetection:" forKey:@"Edge"];
    [btns setObject:@"emboss:" forKey:@"Emboss"];
    [btns setObject:@"invert:" forKey:@"Invert"];
    [btns setObject:@"sepia:" forKey:@"Sepia"];
    [btns setObject:@"unsharpen:" forKey:@"Usharp"];

    NSArray *keys = [btns allKeys];

    keys = [keys sortedArrayUsingSelector:@selector(compare:)];
    
    for (int i = 0; i < [keys count]; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSString *strSel = [btns objectForKey:key];
        NSLog(@"key: %@, value: %@\n",
              [keys objectAtIndex:i],
              [btns objectForKey:[keys objectAtIndex:i]]);
    
        // @selector(method:)
        SEL sel = NSSelectorFromString(strSel);
        UIButton *uiButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        uiButton.frame = CGRectMake((i * x) + 5, 5, width, height);
        [uiButton setTitle:key forState:UIControlStateNormal];
        [uiButton addTarget:self action:sel forControlEvents:   UIControlEventTouchUpInside];
        uiButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [self.scrollView addSubview:uiButton];
    }
}

-(void)tapAction:(id)sender
{
    angle += 90;
    // TODO
    if(angle == 360){
        angle=0;
        self.imageView.image = srcImage;
    }else{
        self.imageView.image = [self rotateImage:srcImage angle:angle];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"memory waring");
}

- (IBAction)selectPhoto:(id)sender {
    [SVProgressHUD dismiss];
    mPicker = [[UIImagePickerController alloc] init];
    mPicker.delegate = self;
    mPicker.allowsEditing = YES;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"[ Take or Select Photo ]"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Take Photo",@"Select Photo", nil];
        [actionSheet showInView: self.view];
    }else{
        mPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:mPicker animated:YES completion:NULL];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != actionSheet.cancelButtonIndex)
    {
        if (buttonIndex == 0) {
            mPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else if (buttonIndex == 1) {
            mPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self presentViewController:mPicker animated:YES completion:NULL];
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    angle=0;
    
    srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 向きの修正 TODO
    srcImage = [self fixOrientation:srcImage];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = srcImage;
}

- (IBAction)refreshPhoto:(id)sender {
    [SVProgressHUD dismiss];
    self.imageView.image = srcImage;
}

- (IBAction)removeSelectedPhoto:(id)sender {
    self.imageView.image = NULL;
    srcImage = NULL;
}

- (IBAction)savePhoto:(id)sender {
    [SVProgressHUD show];

    UIImage *image = self.imageView.image;
    UIImageWriteToSavedPhotosAlbum( image, self, @selector(finishExport:didFinishSavingWithError:contextInfo:), NULL );
}
- (void)finishExport:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [SVProgressHUD dismiss];
}

- (IBAction)grayscale:(id)sender {
    self.imageView.image = [srcImage grayscale];
}

- (IBAction)blur:(id)sender {
    self.imageView.image = [srcImage gaussianBlurWithBias:0];
}

- (IBAction)britenWhite:(id)sender {
    self.imageView.image = [srcImage brightenWithValue:100.0];
}

- (IBAction)edgeDetection:(id)sender {
    self.imageView.image = [srcImage edgeDetectionWithBias:0];
}

- (IBAction)emboss:(id)sender {
    self.imageView.image = [srcImage embossWithBias:0];
}

- (IBAction)invert:(id)sender {
    self.imageView.image = [srcImage invert];
}

- (IBAction)sepia:(id)sender {
    self.imageView.image = [srcImage sepia];
}

- (IBAction)unsharpen:(id)sender {
    self.imageView.image = [srcImage unsharpenWithBias:0];
}
- (UIImage *)fixOrientation:(UIImage *)img {
    if (img.imageOrientation == UIImageOrientationUp) return img;
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (img.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, img.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, img.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (img.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }

    CGContextRef ctx = CGBitmapContextCreate(NULL, img.size.width, img.size.height,
                                             CGImageGetBitsPerComponent(img.CGImage), 0,
                                             CGImageGetColorSpace(img.CGImage),
                                             CGImageGetBitmapInfo(img.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (img.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.height,img.size.width), img.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.width,img.size.height), img.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *_img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return _img;
}


- (UIImage *) rotateImage:(UIImage *)img angle:(int)_angle
{
    CGImageRef imgRef = [img CGImage];
    CGContextRef context;
    
    switch (_angle) {
        case 90:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.height, img.size.width);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, M_PI/2.0);
            break;
        case 180:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.width, img.size.height));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.width, 0);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI);
            break;
        case 270:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI/2.0);
            break;
        default:
            return img;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, img.size.width, img.size.height), imgRef);
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return ret;
}

@end
