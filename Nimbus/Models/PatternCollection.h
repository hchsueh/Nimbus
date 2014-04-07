//
//  PatternCollection.h
//  Nimbus
//
//  Created by Apple on 2014/4/4.
//
//

#import <Foundation/Foundation.h>
#import "Pattern.h"

@interface PatternCollection : NSObject

@property (nonatomic, strong) NSMutableArray *patternsInCollection;

-(instancetype) initWithFirstPattern;
-(NSMutableArray *) matchWithImage: (UIImage *) playerDrawnImage;

@end
