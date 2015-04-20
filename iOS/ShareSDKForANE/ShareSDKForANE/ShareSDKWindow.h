//
//  ShareSDKWindow.h
//  ShareSDKForANE
//
//  Created by 冯 鸿杰 on 14-3-20.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareSDKWindow : UIWindow

/**
 *	@brief	内容视图
 */
@property (nonatomic,readonly) UIView *contentView;

/**
 *	@brief	显示窗口
 */
- (void)show;

/**
 *	@brief	关闭窗口
 */
- (void)close;


@end
