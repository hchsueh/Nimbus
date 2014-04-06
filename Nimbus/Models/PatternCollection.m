//
//  PatternCollection.m
//  Nimbus
//
//  Created by Apple on 2014/4/4.
//
//

#import "PatternCollection.h"

@interface PatternCollection()

@end

@implementation PatternCollection

-(instancetype) initWithFirstPattern
{
    self = [super init];
    if(self)
    {
        NSLog(@"initWithFirstPattern called!");
        
        //temporarily adding the first pattern to collection just for testing
        Pattern *pattern = [[Pattern alloc] init];
        pattern.name = @"Baby Golden Snitch";
        pattern.patternImage = [UIImage imageNamed:@"BabyGoldenSnitchPattern"];
//        pattern.guardianImage = nil;
//        [self.patternsInCollection addObject:@"NANAN"];
        [self.patternsInCollection addObject:pattern];
    }
    return self;
}

-(NSMutableArray *) patternsInCollection
{
    if (!_patternsInCollection)
    {
        _patternsInCollection = [[NSMutableArray alloc] init];
        NSLog(@"init patternsInCollection");
    }
    return _patternsInCollection;
}

-(NSMutableArray *) matchWithPatternsInCollection:(UIImage *)playerDrawnImage
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:[NSNumber numberWithBool:NO]];
    
    //do matching and conditioning
    for( Pattern *pattern in self.patternsInCollection)
    {
        float score = [pattern match: playerDrawnImage];
        
        if(score <= 100.0) //threshold!!!!!!!!!!!!
        {
            [result addObject:[NSNumber numberWithBool:YES]];
            [result addObject:[NSNumber numberWithFloat:score]];
            [result addObject:pattern.name];
            NSLog(@"Bingo! playerDrawnImage is matched with %@, and the score is: %f", pattern.name, score);
            break;
        }
        else
        {
            NSLog(@"Boo! playerDrawnImage isn't matched with %@, and the score is: %f", pattern.name, score);
        }
    }
    
    return result;
}

@end
