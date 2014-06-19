//
//  DZAutoMoveSprite.m
//  AirPlane
//
//  Created by stonedong on 14-6-19.
//  Copyright (c) 2014年 stonedong. All rights reserved.
//

#import "DZAutoMoveSprite.h"

@interface DZAutoMoveSprite ()
{
    
}
@end

@implementation DZAutoMoveSprite

- (void) commonInit
{
    _moveSpeed = 0;
}
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    [self commonInit];
    return self;
}

- (CGRect) nextPositionForTimeInterval:(CGFloat)time
{
    CGRect rect = self.frame;
    rect.origin.y = rect.origin.y + _moveSpeed * time;
        return rect;
}

@end
