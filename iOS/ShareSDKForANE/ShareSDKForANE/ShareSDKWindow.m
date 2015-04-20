//
//  ShareSDKWindow.m
//  ShareSDKForANE
//
//  Created by 冯 鸿杰 on 14-3-20.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import "ShareSDKWindow.h"
#import <ShareSDK/ShareSDK.h>

@interface RootViewController : UIViewController
{
@private
    UIView *_contentView;
}

/**
 *	@brief	内容视图
 */
@property (nonatomic, readonly) UIView *contentView;

@end

@implementation RootViewController

@synthesize contentView = _contentView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    Class SSFacade = NSClassFromString(@"SSFacade");
    return [[SSFacade sharedInstance] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

-(BOOL)shouldAutorotate
{
    //iOS6下旋屏方法
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //iOS6下旋屏方法
    Class SSFacade = NSClassFromString(@"SSFacade");
    return [[SSFacade sharedInstance] interfaceOrientationMask];
}

- (UIView *)contentView
{
    if (_contentView == nil)
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        [self.view addSubview:_contentView];
        [_contentView release];
    }
    
    return _contentView;
}

@end

@implementation ShareSDKWindow

@synthesize contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert;
        self.rootViewController = [[[RootViewController alloc] init] autorelease];
        self.hidden = YES;
    }
    
    return self;
}

- (UIView *)contentView
{
    return ((RootViewController *)self.rootViewController).contentView;
}

- (void)show
{
    self.hidden = NO;
    [self makeKeyAndVisible];
    [self becomeKeyWindow];
}

- (void)close
{
    [self resignKeyWindow];
    self.hidden = YES;
}

@end
