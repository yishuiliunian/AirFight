//
//  DZSprite.m
//  AirPlane
//
//  Created by stonedong on 14-6-19.
//  Copyright (c) 2014年 stonedong. All rights reserved.
//

#import "DZSprite.h"
#import "DZImageCache.h"
@implementation DZSprite


- (instancetype) initWithImageName:(NSString *)imageName
{
    self = [super init];
    if (!self) {
        return self;
    }
    self.image = DZCachedImageByName(imageName);
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGRect) nextPositionForTimeInterval:(CGFloat)time
{
    return self.frame;
}
@end
