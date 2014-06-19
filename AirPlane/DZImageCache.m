//
//  DZImageCache.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-15.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZImageCache.h"
#import "DZMemoryCache.h"
#import "DZSingletonFactory.h"
@implementation DZImageCache

+ (DZImageCache*) shareCache
{
    return DZSingleForClass([DZImageCache class]);
}

- (UIImage*) cachedImageForName:(NSString*)name
{
    NSArray* comps = [name componentsSeparatedByString:@"."];
    NSCAssert(comps.count <= 2, @"image name error %@", name);
    NSString* fileName = nil;
    NSString* fileType = nil;
    if (comps.count == 1) {
        fileName = name;
        fileType = @"png";
    }
    else
    {
        fileName = comps[0];
        fileType = comps[1];
    }
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    return [self cachedImageFroPath:path];
}

- (UIImage*) cachedImageFroPath:(NSString*)path
{
    UIImage* image = [DZMemoryShareCache objectForKey:path];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            [DZMemoryShareCache setObject:image forKey:path];
        }
    }
    return image;
}

@end
