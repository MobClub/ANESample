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
#import "SSLinkedInUser.h"
#import "SSLinkedInErrorInfo.h"
#import "SSLinkedInCredential.h"
#import "SSLinkedInShare.h"
#import <ShareSDK/ShareSDKPlugin.h>

/**
 *	@brief	LinkedIn请求方式
 */
typedef enum
{
	SSLinkedInRequestMethodGet = 0, /**< GET方式 */
	SSLinkedInRequestMethodPost = 1, /**< POST方式 */
	SSLinkedInRequestMethodMultipartPost = 2 /**< Multipart POST方式，用于上传文件的api接口 */
}
SSLinkedInRequestMethod;

@protocol ISSLinkedInApp <ISSPlatformApp>

/**
 *	@brief	获取应用Key
 *
 *	@return	应用Key
 */
- (NSString *)apiKey;

/**
 *	@brief	获取应用密钥
 *
 *	@return	应用密钥
 */
- (NSString *)secretKey;

/**
 *	@brief	获取应用回调地址
 *
 *	@return	应用回调地址
 */
- (NSString *)redirectUri;

/**
 *	@brief	调用开放平台API
 *
 *	@param 	path 	路径
 *	@param 	params 	请求参数,可以为一个ISSCParameters协议对象，也可以为一个NSDictionary对象,为NSDicationary对象时仅在以POST方式提交时有效。
 *  @param  user    授权用户,如果传入nil则表示默认的授权用户
 *  @param  result  返回回调
 *  @param  fault   失败回调
 */
- (void)api:(NSString *)path
     method:(SSLinkedInRequestMethod)method
     params:(id)params
       user:(id<ISSPlatformUser>)user
     result:(void(^)(id responder))result
      fault:(void(^)(CMErrorInfo *error))fault;

/**
 *	@brief	分享内容
 *
 *	@param 	comment 	对内容的评论
 *	@param 	title 	标题
 *	@param 	description 	内容描述
 *	@param 	url 	内容链接
 *	@param 	image 	内容图片
 *	@param 	visibility 	可见
 *  @param  result  回调方法
 */
- (void)shareWithComment:(NSString *)comment
                   title:(NSString *)title
             description:(NSString *)description
                     url:(NSString *)url
                   image:(NSString *)image
              visibility:(NSString *)visibility
                  result:(SSShareResultEvent)result;


@end
