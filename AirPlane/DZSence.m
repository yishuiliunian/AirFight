//
//  DZSence.m
//  AirPlane
//
//  Created by stonedong on 14-6-19.
//  Copyright (c) 2014年 stonedong. All rights reserved.
//

#import "DZSence.h"
#import "DZSprite.h"

@interface DZSence ()
{
    NSTimer* _motionTimer;
    
    CGFloat _lastTimeInterval;
    CGFloat _currentTimeInterval;
    
    NSMutableDictionary* _spriteCacheMap;
}
@end

@implementation DZSence

- (void) commonInit
{
    _allSprite = [NSMutableArray new];
    _lastTimeInterval = 0;
    _currentTimeInterval = 0;
    _spriteCacheMap = [NSMutableDictionary dictionary];
    _running = NO;
}

- (DZSprite*) dequeueSpriteByIdentifier:(NSString*)identifier
{
    NSMutableSet* set = _spriteCacheMap[identifier];
    DZSprite* sprite = [set anyObject];
    if (sprite) {
        [set removeObject:sprite];
    }
    return sprite;
}

- (void) endqueueSprite:(DZSprite*)sprite byIdentifier:(NSString*)identifier
{
    if (!sprite) {
        return;
    }
    NSMutableSet* set = _spriteCacheMap[identifier];
    if (!set) {
        set = [NSMutableSet set];
        _spriteCacheMap[identifier] = set;
    }
    [set addObject:sprite];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void) startShow
{
    if (_motionTimer.isValid) {
        return;
    }
    _running = YES;
    _motionTimer = [NSTimer scheduledTimerWithTimeInterval:0.016 target:self selector:@selector(updatePosition:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_motionTimer forMode:NSDefaultRunLoopMode];
}

- (void) updatePosition:(NSTimer*)timer
{
    [self setNeedsLayout];
    _currentTimeInterval += 0.016;
}

- (void) updateAllSprites
{
    CGFloat time = _currentTimeInterval - _lastTimeInterval;
//    NSLog(@"time is %f",time);
    NSArray* allSprite = [_allSprite copy];
    for (DZSprite* sprite in allSprite) {
        if (CGRectIntersectsRect(self.bounds, sprite.frame)) {
            CGRect rect =  [sprite nextPositionForTimeInterval:time];
            sprite.frame = rect;
            if (!CGRectContainsRect(self.bounds, rect)) {
                [self endqueueSprite:sprite byIdentifier:sprite.identifier];
                if ([self.delegate respondsToSelector:@selector(sence:didMoveOutSprite:)]) {
                    [self.delegate sence:self didMoveOutSprite:sprite];
                }
            } else {
                [_spriteCacheMap[sprite.identifier] removeObject:sprite];
            }
            if ([self.delegate respondsToSelector:@selector(sence:didUpdateSpritePositon:)]) {
                [self.delegate sence:self didUpdateSpritePositon:sprite];
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(senceUpdateAllSprites:)]) {
        [self.delegate senceUpdateAllSprites:self];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self updateAllSprites];
    _lastTimeInterval = _currentTimeInterval;
}

- (void) addSprite:(DZSprite *)sprite atPosition:(CGRect)position
{
    NSAssert(sprite, @"传入的精灵是空的！！！shit");
    [self addSubview:sprite];
    sprite.frame = position;
    [_allSprite addObject:sprite];
}

- (void) removeSprete:(DZSprite *)sprite
{
    NSAssert(sprite, @"传入的精灵是空的！！！shit");
    [sprite removeFromSuperview];
    [_allSprite removeObject:sprite];
}

- (NSArray*) allSpriteByIdentifier:(NSString *)identifier
{
    NSArray* allS = [_allSprite copy];
    NSMutableArray* allIdenS = [NSMutableArray new];
    for (DZSprite* sprite  in allS) {
        if ([sprite.identifier isEqualToString:identifier]) {
            [allIdenS addObject:sprite];
        }
    }
    return allIdenS;
}

- (void) pause
{
    _running = NO;
    [_motionTimer invalidate];
    _motionTimer = nil;
}
@end
