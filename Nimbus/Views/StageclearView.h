//
//  StageclearView.h
//  Nimbus
//
//  Created by Apple on 2014/5/14.
//
//

#import <UIKit/UIKit.h>

@interface StageclearView : UIView
//@property (nonatomic) int rank;
-(void) updateLabel: (NSNumber *) rank;
-(id)initWithRank:(NSNumber *)rank;
@end
