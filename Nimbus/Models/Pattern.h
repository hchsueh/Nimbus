//
//  Pattern.h
//  Nimbus
//
//  Created by Apple on 2014/4/4.
//
//

#import <Foundation/Foundation.h>

@interface Pattern : NSObject

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) UIImage *patternImage;
@property (nonatomic, strong, readwrite) UIImage *guardianImage;

-(instancetype) initWithFirstPattern;
-(float) match: (UIImage *) playerDrawnImage;

@end
