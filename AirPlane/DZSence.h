//
//  DZSence.h
//  AirPlane
//
//  Created by stonedong on 14-6-19.
//  Copyright (c) 2014年 stonedong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DZSence;
@class DZSprite;
@protocol DZSenceDelegate <NSObject>
- (void) sence:(DZSence*)sence didUpdateSpritePositon:(DZSprite*)sprite;
- (void) sence:(DZSence *)sence didMoveOutSprite:(DZSprite *)sprite;
- (void) senceUpdateAllSprites:(DZSence*)senece;
@end

@class DZSprite;
@interface DZSence : UIView
{
    NSMutableArray* _allSprite;
}
@property (nonatomic, assign, readonly) BOOL running;
@property (nonatomic, weak) id<DZSenceDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray* sprites;
- (void) addSprite:(DZSprite*)sprite atPosition:(CGRect)position;
- (void) removeSprete:(DZSprite*)sprite;
- (void) startShow;
- (void) pause;
- (DZSprite*) dequeueSpriteByIdentifier:(NSString*)identifier;
- (void) endqueueSprite:(DZSprite*)sprite byIdentifier:(NSString*)identifier;

- (NSArray*) allSpriteByIdentifier:(NSString*)identifier;
@end
