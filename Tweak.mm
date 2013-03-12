#import <SpringBoard/SpringBoard.h>
#import <libactivator/libactivator.h>
#import "VLMHarlemShake.h"

@interface SBIconController ()
-(SBIconListView *)currentRootIconList;
@end

@interface SBIconViewMap : NSObject
+ (SBIconViewMap *)homescreenMap;
- (UIView *)iconViewForIcon:(SBIcon *)icon;
@end

@interface SBAwayView ()
- (id)dateHeaderView;
@end

@interface FBSBHarlemShake : NSObject<LAListener>
{
    BOOL _animating;
    VLMHarlemShake *_harlemShake;
}
@end

@implementation FBSBHarlemShake

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
    if (_animating)
    {
        return;
    }
    
    UIView *lonerView = nil;
    NSString *mode = event.mode;

    if ([mode isEqualToString:@"springboard"])
    {
        SBIconListView *listView = [[%c(SBIconController) sharedInstance] currentRootIconList];
        
        NSArray *icons = [listView icons];
        SBIcon *icon = [icons objectAtIndex:(arc4random() % [icons count])];
        SBIconViewMap *map = [%c(SBIconViewMap) homescreenMap];
        lonerView = [map iconViewForIcon:icon];
        
    } else if ([mode isEqualToString:@"lockscreen"])
    {
        SBAwayController *awayController = [%c(SBAwayController) sharedAwayController];
        [awayController restartDimTimer:32.0f];
        
        SBAwayView *awayView = [awayController awayView];
        lonerView = [awayView dateHeaderView];
    }
    
    if (lonerView != nil)
    {
        event.handled = YES;
        _animating = YES;
        
        if (_harlemShake)
        {
            [_harlemShake release];
            _harlemShake = nil;
        }
        
        _harlemShake = [[VLMHarlemShake alloc] initWithLonerView:lonerView];
        [_harlemShake shakeWithCompletion:^{
            _animating = NO;
        }];
    }
}

-(void)dealloc
{
    [_harlemShake release];
    [super dealloc];
}

+ (void)load
{
    if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) { return; }
	@autoreleasepool {
        [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.filippobiga.harlem"];
    }
}

@end
