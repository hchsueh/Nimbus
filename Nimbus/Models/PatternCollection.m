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
        NSLog(@"LALALA initWithFirstPattern called!");
        
        //temporarily adding the first pattern to collection just for testing
        Pattern *pattern = [[Pattern alloc] init];
        pattern.name = @"Baby Golden Snitch";
        pattern.patternImage = [UIImage imageNamed:@"BabyGoldenSnitchPattern"];
        pattern.guardianImage = nil;
        NSLog(@"initWithFirstPattern, patternImage w:%f, h:%f", pattern.patternImage.size.width, pattern.patternImage.size.height);
        [pattern addFirstPatternPixel];
        
        _patternsInCollection = [[NSMutableArray alloc] init];
        [_patternsInCollection addObject:pattern];
    }
    return self;
}

-(NSMutableArray *) matchWithImage:(UIImage *)playerDrawnImage
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:[NSNumber numberWithBool:NO]];
    NSLog(@"playerDrawnImage w:%f, h:%f", playerDrawnImage.size.width, playerDrawnImage.size.height);
    //do matching and conditioning
    for( Pattern *pattern in self.patternsInCollection)
    {
        float score = [pattern match: playerDrawnImage];
        NSLog(@"now matching with pattern with name: %@", pattern.name);
        if(score <= 100.0) //threshold!!!!!!!!!!!!
        {
            [result replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
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
