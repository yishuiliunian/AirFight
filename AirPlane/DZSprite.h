//
//  DZSprite.h
//  AirPlane
//
//  Created by stonedong on 14-6-19.
//  Copyright (c) 2014年 stonedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZSprite : UIImageView
@property (nonatomic, strong) NSString* identifier;
- (instancetype) initWithImageName:(NSString*)imageName;

- (CGRect) nextPositionForTimeInterval:(CGFloat)time;

@end
