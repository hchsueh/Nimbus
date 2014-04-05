//
//  PatternCollection.h
//  Nimbus
//
//  Created by Apple on 2014/4/4.
//
//

#import "Pattern.h"

@interface PatternCollection : NSObject

@property (nonatomic, strong) NSMutableArray *patternsInCollection;

-(instancetype) initWithFirstPattern;
-(NSMutableArray *) matchWithPatternsInCollection: (UIImage *) playerDrawnImage;

@end
