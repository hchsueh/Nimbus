//
//  Pattern.m
//  Nimbus
//
//  Created by Apple on 2014/4/4.
//
//

#import "Pattern.h"
#import <opencv2/opencv.hpp>


@interface Pattern()

- (cv::Mat) cvMatFromUIImage:(UIImage *)image;
- (cv::Mat) cvMatWithImage:(UIImage *)image;
- (UIImage*) imageFromCVMat: (cv::Mat& ) image;
- (UIImage *) imageWithCVMat:(const cv::Mat&)cvMat;

@end

@implementation Pattern

-(float) match:(UIImage *) playerDrawnImage
{
    float score = -1;
    
    cv::Mat MatPlayer = [self cvMatFromUIImage:playerDrawnImage];
    cv::Mat MatPattern = [self cvMatFromUIImage:self.patternImage];
    
    cv::cvtColor(MatPlayer, MatPlayer, CV_RGB2GRAY);
    cv::cvtColor(MatPattern, MatPattern, CV_RGB2GRAY);
    
    std::vector<std::vector<cv::Point> > contoursPlayer;
    std::vector<std::vector<cv::Point> > contoursPattern;
    
    cv::findContours(MatPlayer, contoursPlayer, cv::RETR_LIST, cv::CHAIN_APPROX_NONE);
    cv::findContours(MatPattern, contoursPattern, cv::RETR_LIST, cv::CHAIN_APPROX_NONE);
    
    NSLog(@"contoursPlayer size: %lu", contoursPlayer.size());
    NSLog(@"contoursPattern size: %lu", contoursPattern.size());
    
    //turn UIImage into Mat, findContours, matchShape
    
    
    return score;
}

-(UIImage *) retrievePattern
{
    cv::Mat matPattern = [self cvMatFromUIImage:self.patternImage];
//    cv::Mat matPattern = [self cvMatWithImage:self.patternImage];
    UIImage* image = [self imageFromCVMat:matPattern];
//    UIImage* image = [self UIImageFromCVMat:matPattern];
//    UIImage *image = [self imageWithCVMat:matPattern];
    return image;
//    return self.patternImage;
}


- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to    data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);

//    cv::cvtColor(cvMat, cvMat, CV_BGR2RGB);
    return cvMat;
}

- (UIImage*) imageFromCVMat: (cv::Mat& ) image
{
    NSData *data = [NSData dataWithBytes:image.data length:image.
                    elemSize()*image.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (image.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(image.cols,   //width
                                        
                                        image.rows,   //height
                                        8,            //bits per component
                                        8*image.elemSize(),//bits per pixel
                                        image.step.p[0],   //bytesPerRow
                                        colorSpace,   //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,//bitmap info
                                        provider,     //CGDataProviderRef
                                        NULL,         //decode
                                        false,        //should interpolate
                                        kCGRenderingIntentDefault  //intent
                                        );
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

- (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                     // Width
                                        cvMat.rows,                                     // Height
                                        8,                                              // Bits per component
                                        8 * cvMat.elemSize(),                           // Bits per pixel
                                        cvMat.step[0],                                  // Bytes per row
                                        colorSpace,                                     // Colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
                                        provider,                                       // CGDataProviderRef
                                        NULL,                                           // Decode
                                        false,                                          // Should interpolate
                                        kCGRenderingIntentDefault);                     // Intent
    
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}

-(cv::Mat)cvMatWithImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

@end
