//
//  DZSenceViewController.h
//  AirPlane
//
//  Created by stonedong on 14-6-19.
//  Copyright (c) 2014年 stonedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZSence.h"
@interface DZSenceViewController : UIViewController <DZSenceDelegate>
@property (nonatomic, strong, readonly) DZSence* sence;
@end
