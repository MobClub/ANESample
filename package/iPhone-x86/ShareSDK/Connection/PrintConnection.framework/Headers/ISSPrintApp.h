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
#import "SSPrintErrorInfo.h"
#import <ShareSDK/ShareSDKPlugin.h>

/**
 *	@brief	打印应用协议
 */
@protocol ISSPrintApp <ISSPlatformApp>

/**
 *	@brief	打印
 *
 *  @param  jobName 作业名称
 *	@param 	text 	文本内容
 *	@param 	pic 	图片内容
 *  @param  container   容器
 *  @param  result  返回回调
 */
- (void)printWithJobName:(NSString *)jobName
                    text:(NSString *)text
                     pic:(id<ISSCAttachment>)pic
               container:(UIViewController *)container
                  result:(SSShareResultEvent)result;


@end
