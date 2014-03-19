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
#import "SSFacebookUser.h"
#import "SSFacebookErrorInfo.h"
#import "SSFacebookPost.h"
#import "ISSFacebookAddFriendDialog.h"
#import <ShareSDK/ShareSDKPlugin.h>

/**
 *	@brief	Facebook请求方式
 */
typedef enum
{
	SSFacebookRequestMethodGet = 0, /**< GET方式 */
	SSFacebookRequestMethodPost = 1, /**< POST方式 */
	SSFacebookRequestMethodMultipartPost = 2, /**< Multipart POST方式，用于上传文件的api接口 */
    SSFacebookRequestMethodDelete = 3   /**< DELETE方式 */
}
SSFacebookRequestMethod;

/**
 *	@brief	显示添加好友对话框
 */
typedef void(^SSFacebookShowAddFriendDialog) (UIViewController *viewController);

/**
 *	@brief	关闭添加好友对话框
 */
typedef void(^SSFacebookCloseAddFriendDialog) (UIViewController *viewController);

/**
 *	@brief	Facebook应用协议
 */
@protocol ISSFacebookApp <ISSPlatformApp>

/**
 *	@brief	获取应用Key
 *
 *	@return	应用Key
 */
- (NSString *)appKey;

/**
 *	@brief	获取应用密钥
 *
 *	@return	应用密钥
 */
- (NSString *)appSecret;

/**
 *	@brief	获取SSO回调地址
 *
 *	@return	SSO回调地址
 */
- (NSString *)ssoCallbackUrl;

/**
 *	@brief	设置添加好友对话框处理器
 *
 *	@param 	showHandler 	显示处理器
 *  @param  closeHandler    关闭处理器
 */
- (void)setAddFriendDialogWithShowHandler:(SSFacebookShowAddFriendDialog)showHandler
                             closeHandler:(SSFacebookCloseAddFriendDialog)closeHandler;
							 
/**
 *	@brief	设置添加好友对话框委托
 *
 *	@param 	delegate 	委托
 */
- (void)setAddFriendDialogDelegate:(id<ISSViewDelegate>)delegate;

/**
 *	@brief	调用开放平台API
 *
 *	@param 	path 	路径
 *	@param 	params 	请求参数
 *  @param  user    授权用户,如果传入nil则表示默认的授权用户
 *  @param  result  返回回调
 *  @param  fault   失败回调
 */
- (void)api:(NSString *)path
     method:(SSFacebookRequestMethod)method
     params:(id<ISSCParameters>)params
       user:(id<ISSPlatformUser>)user
     result:(void(^)(id responder))result
      fault:(void(^)(CMErrorInfo *error))fault;

/**
 *	@brief	发布消息
 *
 *	@param 	message 	消息
 *  @param  result      返回回调
 */
- (void)feedWithMessage:(NSString *)message
                 result:(SSShareResultEvent)result;

/**
 *	@brief	发布消息
 *
 *	@param 	message 	消息
 *	@param 	source 	附件图片
 *  @param  result  返回回调
 */
- (void)feedWithMessage:(NSString *)message
                 source:(id<ISSCAttachment>)source
                 result:(SSShareResultEvent)result;
				 
/**
 *	@brief	获取文章信息
 *
 *	@param 	postId 	文章ID
 */
- (void)getPostWithId:(NSString *)postId
               result:(void(^)(BOOL result, id post, CMErrorInfo *error))result;


@end
