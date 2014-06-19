//
//  DZAirFightViewController.m
//  AirPlane
//
//  Created by stonedong on 14-6-19.
//  Copyright (c) 2014年 stonedong. All rights reserved.
//

#import "DZAirFightViewController.h"
#import "DZAutoMoveSprite.h"
#import "DZImageCache.h"
#import "HexColor.h"
static NSString* const kDZAnemySpriteIdentifier = @"enemy";
static NSString* const kDZFireSpriteIdentifer = @"fire";

@interface DZAirFightViewController ()
{
    NSTimer* _addObjectTimer;
    
    UILabel* _scoleLabel;
    
    NSInteger _score;
}
@property (nonatomic, strong) DZSprite* myAirPlane;
@property (nonatomic, strong) UIImageView* pasueImageView;
@end

@implementation DZAirFightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) addAutoDownSpirteSpeed:(CGFloat)speed
                     idenfifier:(NSString*)identifier
                      imageName:(NSString*)name
                         startY:(CGFloat)startY
{
    CGRect(^RandomRect)(void) = ^(void) {
        CGRect rect = CGRectZero;
        UIImage* image = DZCachedImageByName(name);
        rect.size = image.size;
        rect.origin = CGPointMake(320*(rand()%255/(CGFloat)255.0f), startY - image.size.height + 1);
        return rect;
    };
    DZAutoMoveSprite* spirite =  (DZAutoMoveSprite*)[self.sence dequeueSpriteByIdentifier:identifier];
    if (!spirite) {
        spirite = [[DZAutoMoveSprite alloc] initWithImageName:name];
    }
    spirite.moveSpeed = speed;
    spirite.identifier = identifier;
    [self.sence addSprite:spirite atPosition:RandomRect()];
}

- (void) addEnemySprite
{
    [self addAutoDownSpirteSpeed:60 + rand()%5 idenfifier:kDZAnemySpriteIdentifier imageName:@"enemy" startY:0];
}

- (void) addFireSprite
{
    UIImage* image = DZCachedImageByName(@"plane-rear-fire");
    CGRect rect = self.myAirPlane.frame;
    rect.origin.x += 20;
    rect.size = image.size;
    NSString* identifier = @"fire";
    DZAutoMoveSprite* spirite =  (DZAutoMoveSprite*)[self.sence dequeueSpriteByIdentifier:identifier];
    if (!spirite) {
        spirite = [[DZAutoMoveSprite alloc] initWithImageName:@"plane-rear-fire"];
    }
    spirite.moveSpeed = -100;
    spirite.identifier = identifier;
    [self.sence addSprite:spirite atPosition:rect];

}
- (void) addCloudSpriteStartY:(CGFloat)startY
{
    NSArray* names = @[@"cloud1", @"cloud2", @"cloud3"];
    NSString* name = names[rand()%3];
    [self addAutoDownSpirteSpeed:20 idenfifier:name imageName:name startY:startY];
}

- (void) sence:(DZSence *)sence didMoveOutSprite:(DZSprite *)sprite
{
    
}
- (void) showScore
{
    _scoleLabel.text = [@(_score) stringValue];
}
- (void) sence:(DZSence *)sence didUpdateSpritePositon:(DZSprite *)sprite
{
    [self.sence bringSubviewToFront:_scoleLabel];
    if ([sprite.identifier hasPrefix:@"cloud"]) {
        [self.sence insertSubview:sprite atIndex:0];
    }

    
}

- (void) senceUpdateAllSprites:(DZSence *)senece
{
    NSArray* allEnemys = [self.sence allSpriteByIdentifier:kDZAnemySpriteIdentifier];
    NSArray* allFire = [self.sence allSpriteByIdentifier:kDZFireSpriteIdentifer];
    for (DZSprite* s  in allEnemys) {
        BOOL willBreak = NO;
        for (DZSprite* f  in allFire) {
            if (CGRectIntersectsRect(s.frame, f.frame)) {
                if (CGRectIntersectsRect(self.view.bounds, s.frame) && CGRectIntersectsRect(self.view.bounds, f.frame)) {
                    [self.sence removeSprete:s];
                    [self.sence removeSprete:f];
                    _score++;
                    [self showScore];
                    willBreak = YES;
                    break;
                }
            }
        }
        if (willBreak) {
            break;
        }
        if (CGRectIntersectsRect(s.frame, self.myAirPlane.frame)) {
            _score = 0;
            [self showScore];
            [self.sence removeSprete:s];
            [self pause];
            UIAlertView* alertView =[[UIAlertView alloc] initWithTitle:@"失败！" message:@"被击毁了" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }
    }
    
}
- (void) handleAddObject:(NSTimer*)timer
{
    static int i = 0;
    i++;
    if (i % 2 == 0) {
        [self addEnemySprite];
    }
    if (i % 10 == 0) {
        [self addCloudSpriteStartY:0];
    }
    if (self.myAirPlane && i%2 == 0) {
        [self addFireSprite];
    }
}
- (void) addInitCloud
{
    for (int i = 0 ; i < 5; i++) {
        [self addCloudSpriteStartY:i*70];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scoleLabel = [UILabel new];
    [self.sence addSubview:_scoleLabel];
    _scoleLabel.frame = CGRectMake(10, 10, 40, 40);
    _scoleLabel.backgroundColor = [UIColor clearColor];
    _score = 0;
    [self showScore];
    self.sence.backgroundColor = [UIColor colorWithHexString:@"c1c7c8"];
    [self addInitCloud];

    // Do any additional setup after loading the view.
    _pasueImageView = [UIImageView new];
    _pasueImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGest.numberOfTapsRequired = 1;
    [_pasueImageView addGestureRecognizer:tapGest];
    [self.view addSubview:_pasueImageView];
    
    _pasueImageView.frame = CGRectMake(CGRectGetMaxX(_scoleLabel.frame)+ 20, 10, 50, 50);
    _pasueImageView.backgroundColor = [UIColor greenColor];
    
}

- (void) handleTap:(UITapGestureRecognizer*)tap
{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        if (self.sence.running) {
            [self pause];
        } else
        {
            [self start];
        }
    }
}
- (void) setStartButton
{
}

- (void) setPauseButton
{

}
- (void) pause
{
    [self.sence pause];
    [_addObjectTimer invalidate];
    _addObjectTimer  = nil;
}
- (void) start
{
    _addObjectTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(handleAddObject:) userInfo:nil repeats:YES];
    [self.sence startShow];
    [self addEnemySprite];
}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (!self.myAirPlane) {
        UIImage* planeImage = DZCachedImageByName(@"plane");
        self.myAirPlane = [[DZSprite alloc] initWithImageName:@"plane"];
        CGSize size = planeImage.size;
        CGFloat startX =( CGRectGetWidth(self.view.frame) - size.width ) /2;
        CGRect rect  = CGRectMake(startX, CGRectGetHeight(self.view.frame) - size.height, size.width, size.height);
        self.myAirPlane.identifier = @"myPlane";
        [self.sence addSprite:self.myAirPlane atPosition:rect];
    }
}



- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    CGRect rect = self.myAirPlane.frame;
    rect.origin = CGPointMake(point.x - rect.size.width/2, point.y  - rect.size.height/2);
    self.myAirPlane.frame = rect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
