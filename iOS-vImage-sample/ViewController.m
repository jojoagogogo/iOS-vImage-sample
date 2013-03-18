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
    
    self.scrollView.contentSize = CGSizeMake(1200, 50);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addButton];

}


- (void)addButton {
    int x = 50 + 2;
    int width =50;
    int height = 50;
    int fontSize = 12;

    NSMutableDictionary *btns = [NSMutableDictionary dictionary];
    [btns setObject:@"grayscale:" forKey:@"01.Gray"];
    [btns setObject:@"blur:" forKey:@"02.Blur"];
    [btns setObject:@"britenWhite:" forKey:@"03.BrWhi"];
    [btns setObject:@"edgeDetection:" forKey:@"04.Edge"];
    [btns setObject:@"emboss:" forKey:@"05.Embo"];
    [btns setObject:@"invert:" forKey:@"06.Invert"];
    [btns setObject:@"sepia:" forKey:@"07.Sepia"];
    [btns setObject:@"unsharpen:" forKey:@"08.sharp"];

    [btns setObject:@"enhance:" forKey:@"09.Enha"];
    [btns setObject:@"redEyeCorrection:" forKey:@"10.REye"];
    [btns setObject:@"scaleByFactor:" forKey:@"11.sclF"];
    [btns setObject:@"scaleToFitSize:" forKey:@"12.sclT"];

    //UIImage+Rotating
    [btns setObject:@"rotateInDegrees:" forKey:@"13.RtDe"];
    [btns setObject:@"rotateInRadians:" forKey:@"14.RtInR"];
    [btns setObject:@"verticalFlip:" forKey:@"15.VertF"];
    [btns setObject:@"horizontalFlip:" forKey:@"16.HorF"];

    //UIImage+Reflection
    [btns setObject:@"reflectedImageWH:" forKey:@"17.RefI"];
    //UIImage+Resizing
    [btns setObject:@"cropToSize:" forKey:@"18.Crop"];
    

    
    
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

- (IBAction)enhance:(id)sender {
    self.imageView.image = [srcImage autoEnhance];
}

- (IBAction)redEyeCorrection:(id)sender {
    self.imageView.image = [srcImage redEyeCorrection];
}

- (IBAction)scaleByFactor:(id)sender {
    self.imageView.image = [srcImage scaleByFactor:0.5f];
}

- (IBAction)scaleToFitSize:(id)sender {
                                                    //w h
    self.imageView.image = [srcImage scaleToFitSize:CGSizeMake(50,100)];
}

- (IBAction)rotateInDegrees:(id)sender {
    self.imageView.image = [srcImage rotateInDegrees:217.0f];
}

- (IBAction)rotateInRadians:(id)sender {
    self.imageView.image = [srcImage rotateInRadians:M_PI_2];
}

- (IBAction)verticalFlip:(id)sender {
    self.imageView.image = [srcImage verticalFlip];
}

- (IBAction)horizontalFlip:(id)sender {
    self.imageView.image = [srcImage horizontalFlip];
}

- (IBAction)reflectedImageWH:(id)sender {
    self.imageView.image = [srcImage reflectedImageWithHeight:srcImage.size.height fromAlpha:0.0f toAlpha:0.5f];
}

- (IBAction)cropToSize:(id)sender {
    self.imageView.image = [srcImage cropToSize:CGSizeMake(srcImage.size.width * 0.5, srcImage.size.height * 0.5) usingMode:NYXCropModeCenter];
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
