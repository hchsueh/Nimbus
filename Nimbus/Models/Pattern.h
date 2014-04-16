//
//  Pattern.h
//  Nimbus
//
//  Created by Apple on 2014/4/4.
//
//

#import <Foundation/Foundation.h>

@interface Pattern : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *patternImage;
@property (nonatomic, strong) UIImage *guardianImage;

-(float) match: (UIImage *) playerDrawnImage;

@end
