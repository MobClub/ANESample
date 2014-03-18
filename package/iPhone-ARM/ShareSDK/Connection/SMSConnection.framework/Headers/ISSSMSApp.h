//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import "SSSMSErrorInfo.h"
#import <ShareSDK/ShareSDK.h>

/**
 *	@brief	短信应用协议
 */
@protocol ISSSMSApp <ISSPlatformApp>

/**
 *	@brief	设置视图委托
 *
 *	@param 	viewDelegate 	视图委托
 */
- (void)setViewDelegate:(id<ISSViewDelegate>)viewDelegate;

/**
 *	@brief	发送短信息
 *
 *	@param 	text 	文本信息
 *  @param  container   容器
 *  @param  viewDelegate    视图委托
 *  @param  result  返回回调
 */
- (void)sendText:(NSString *)text
       container:(UIViewController *)container
    viewDelegate:(id<ISSViewDelegate>)viewDelegate
          result:(SSShareResultEvent)result;


@end
