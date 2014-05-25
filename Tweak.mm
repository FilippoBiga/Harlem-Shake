#import <SpringBoard/SpringBoard.h>
#import <libactivator/libactivator.h>
#import "VLMHarlemShake.h"

// iOS 5+6 declarations
@interface SBAwayView : UIView
-(UIView *)dateHeaderView;
@end

@interface SBAwayController : NSObject
+(SBAwayController *)sharedAwayController;
-(SBAwayView *)awayView;
-(void)restartDimTimer:(float)delay;
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
        Class controllerClass = %c(SBAwayController);
        
        if (controllerClass)
        {
            SBAwayController *awayController = [controllerClass sharedAwayController];
            [awayController restartDimTimer:32.0f];
            
            SBAwayView *awayView = [awayController awayView];
            lonerView = [awayView dateHeaderView];

            
        } else {
            
            [[%c(SBBacklightController) sharedInstance] resetLockScreenIdleTimerWithDuration:32.0f];
            
            SBLockScreenManager *manager = [%c(SBLockScreenManager) sharedInstance];
            SBLockScreenViewController *viewController = (SBLockScreenViewController *)manager.lockScreenViewController;
            SBLockScreenView *lockScreenView = [viewController lockScreenView];
            
            lonerView = (UIView *)lockScreenView.dateView;
        }
        
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


+ (void)load
{
    if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"])
    {
        @autoreleasepool {
            
            [[LAActivator sharedInstance] registerListener:[FBSBHarlemShake new]
                                                   forName:@"com.filippobiga.harlem"];
        }
    }
}

-(void)dealloc
{
    [_harlemShake release];
    [super dealloc];
}

@end
