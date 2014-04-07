//
//  Pattern.m
//  Nimbus
//
//  Created by Apple on 2014/4/4.
//
//

#import "Pattern.h"

@interface Pattern()

@property (nonatomic, strong) NSMutableArray *patternPixelInGrayscale;

- (NSMutableArray*) getRGBAsFromImage:(UIImage*) image;
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage;
- (NSNumber*) getPixelColorAtLocation:(CGPoint)point ofImage:(UIImage *) image;

@end

@implementation Pattern

-(void) addFirstPatternPixel
{
    self.patternPixelInGrayscale = [NSMutableArray arrayWithArray:[self getRGBAsFromImage:self.patternImage]];
//    self.patternPixelInGrayscale = [self getRGBAsFromImage:self.patternImage];
    NSLog(@"addFirstPatternPixel, array count: %d", [self.patternPixelInGrayscale count]);

}

-(float) match:(UIImage *) playerDrawnImage
{
    float score = 0;
    
    NSMutableArray *standard = [NSMutableArray arrayWithArray: [self getRGBAsFromImage:self.patternImage]];
    
//    NSLog(@"isNil? %d",[self.patternPixelInGrayscale isEqual:nil]);
//    
//    NSLog(@"standard == self.patternPixelInGrayscale? %d", [standard isEqualToArray:self.patternPixelInGrayscale]);
    
    for( int i=0; i<10000 ; i++)
    {
        NSNumber *num1 = [standard objectAtIndex:i];
        NSNumber *num2 = [self.patternPixelInGrayscale objectAtIndex:i];
        if( [num1 floatValue]!= [num2 floatValue]){
            NSLog(@"oops!!!!!!!QQ at %d; %f != %f", i, [num1 floatValue], [num2 floatValue]);
        }
    }
    
    NSMutableArray *player   = [NSMutableArray arrayWithArray:[self getRGBAsFromImage:playerDrawnImage]];
    
    NSInteger count = [standard count];
//    NSLog(@"array count: %d",count);
//    NSInteger count2 = [self.patternPixelInGrayscale count];
//    NSLog(@"array count2: %d",count2);

//    NSInteger countPlayerImage = [player count];
//    NSLog(@"player array count: %d", countPlayerImage);
    
    for(int i=0 ; i<count ; i++)
    {        
        score += fabsf( [[standard objectAtIndex:i] floatValue]
                        - [[player objectAtIndex:i] floatValue] );
    }
    
    return score;
}

- (NSMutableArray*) getRGBAsFromImage:(UIImage*)image
{
    
    int width = image.size.width;
    int height = image.size.height;
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:width*height];
    
    for( int i=0 ; i<width ; i++)
    {
        for( int j=0 ; j<height ; j++)
        {
            NSNumber *newNum = [self getPixelColorAtLocation:CGPointMake((float)i, (float)j) ofImage:image];
            [result addObject:newNum];
        }
    }
    return result;
}

- (NSNumber*) getPixelColorAtLocation:(CGPoint)point ofImage:(UIImage *) image
{
//    UIColor* color = nil;
    NSNumber *grayValue = nil;
    
    CGImageRef inImage = image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil; /* error */ }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
//        int red = data[offset+1];
//        int green = data[offset+2];
//        int blue = data[offset+3];
//        NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
//        if(alpha != 0) NSLog(@"get non-zero alpha! alpha: %d",alpha);
        grayValue = [NSNumber numberWithFloat:alpha/255.0];
//        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return grayValue;
//    return color;
}



- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}


@end
