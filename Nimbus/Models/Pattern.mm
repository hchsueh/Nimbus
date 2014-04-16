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

-(cv::Mat) cvMatWithImage:(UIImage *)image;


@end

@implementation Pattern

-(float) match:(UIImage *) playerDrawnImage
{
    float score = -1;
    
    cv::Mat MatPlayer = [self cvMatWithImage:playerDrawnImage];
    cv::Mat MatPattern = [self cvMatWithImage:self.patternImage];
    
    cv::cvtColor(MatPlayer, MatPlayer, CV_BGR2GRAY);
    cv::cvtColor(MatPattern, MatPattern, CV_BGR2GRAY);
    
    std::vector<std::vector<cv::Point> > contoursPlayer;
    std::vector<std::vector<cv::Point> > contoursPattern;
    
    cv::findContours(MatPlayer, contoursPlayer, cv::RETR_LIST, cv::CHAIN_APPROX_NONE);
    cv::findContours(MatPattern, contoursPattern, cv::RETR_LIST, cv::CHAIN_APPROX_NONE);
    
    NSLog(@"contoursPlayer size: %lu", contoursPlayer.size());
    NSLog(@"contoursPattern size: %lu", contoursPattern.size());
    
    //turn UIImage into Mat, findContours, matchShape
    
    
    return score;
}

-(cv::Mat) cvMatWithImage:(UIImage *)image
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
