//
//  ShareSDKForANE.h
//  ShareSDKForANE
//
//  Created by 冯 鸿杰 on 14-3-13.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ShareSDK+Utils.h>
#import <AGCommon/UIDevice+Common.h>

#import "WeiboSDK.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <RennSDK/RennSDK.h>
//#import <GoogleOpenSource/GoogleOpenSource.h>
//#import <GooglePlus/GooglePlus.h>
//#import <Pinterest/Pinterest.h>
#import "WXApi.h"
#import "YXApi.h"

static UIView *_refView = nil;

NSString *objectToString(FREObject obj)
{
    FREObjectType type;
    FREGetObjectType(obj, &type);
    
    if (type == FRE_TYPE_STRING)
    {
        const uint8_t *appKeyCStr = NULL;
        uint32_t len = 0;
        FREGetObjectAsUTF8(obj, &len, &appKeyCStr);
        
        return [NSString stringWithCString:(const char *)appKeyCStr encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

NSInteger objectToInteger(FREObject obj)
{
    FREObjectType type;
    FREGetObjectType(obj, &type);
    
    if (type == FRE_TYPE_NUMBER)
    {
        int value;
        FREGetObjectAsInt32(obj, &value);
        
        return value;
    }
    
    return 0;
}

BOOL objectToBoolean(FREObject obj)
{
    FREObjectType type;
    FREGetObjectType(obj, &type);
    
    if (type == FRE_TYPE_BOOLEAN)
    {
        uint32_t value;
        FREGetObjectAsBool(obj, &value);
        
        return value != 0 ? YES : NO;
    }
    
    return NO;
}

NSArray *objectToArray(FREObject obj)
{
    FREObjectType type;
    FREGetObjectType(obj, &type);
    
    if (type == FRE_TYPE_ARRAY)
    {
        NSMutableArray *data = [NSMutableArray array];
        
        uint32_t len = 0;
        FREGetArrayLength(obj, &len);
        
        for (int i = 0; i < len; i++)
        {
            FREObject elm;
            FREGetArrayElementAt(obj, i, &elm);
            
            NSInteger type = objectToInteger(elm);
            [data addObject:[NSNumber numberWithInteger:type]];
        }
        
        return data;
    }
    
    return nil;
}

id<ISSContent> convertPublicContent (NSDictionary *contentDict)
{
    NSString *message = nil;
    id<ISSCAttachment> image = nil;
    NSString *title = nil;
    NSString *url = nil;
    NSString *desc = nil;
    SSPublishContentMediaType type = SSPublishContentMediaTypeText;
    
    if (contentDict)
    {
        NSString *messageStr = [contentDict objectForKey:@"text"];
        if ([messageStr isKindOfClass:[NSString class]])
        {
            message = messageStr;
        }
        
        NSString *imagePathStr = [contentDict objectForKey:@"imageUrl"];
        if ([imagePathStr isKindOfClass:[NSString class]])
        {
            if ([ShareSDK isMatchWithString:imagePathStr regex:@"\\w://.*"])
            {
                image = [ShareSDK imageWithUrl:imagePathStr];
            }
            else
            {
                image = [ShareSDK imageWithPath:imagePathStr];
            }
        }
        
        NSString *titleStr = [contentDict objectForKey:@"title"];
        if ([titleStr isKindOfClass:[NSString class]])
        {
            title = titleStr;
        }
        
        NSString *urlStr = [contentDict objectForKey:@"titleUrl"];
        if ([urlStr isKindOfClass:[NSString class]])
        {
            url = urlStr;
        }
        
        NSString *descStr = [contentDict objectForKey:@"description"];
        if ([descStr isKindOfClass:[NSString class]])
        {
            desc = descStr;
        }
        
        NSNumber *typeValue = [contentDict objectForKey:@"type"];
        if ([typeValue isKindOfClass:[NSNumber class]])
        {
            type = (SSPublishContentMediaType)[typeValue integerValue];
        }
    }
    
    id<ISSContent> contentObj =  [ShareSDK content:message
                                    defaultContent:nil
                                             image:image
                                             title:title
                                               url:url
                                       description:desc
                                         mediaType:type];
    
    if (contentDict)
    {
        NSString *siteUrlStr = nil;
        NSString *siteStr = nil;
        
        NSString *siteUrl = [contentDict objectForKey:@"siteUrl"];
        if ([siteUrl isKindOfClass:[NSString class]])
        {
            siteUrlStr = siteUrl;
        }
        
        NSString *site = [contentDict objectForKey:@"site"];
        if ([site isKindOfClass:[NSString class]])
        {
            siteStr = site;
        }
        
        if (siteUrlStr || siteStr)
        {
            [contentObj addQQSpaceUnitWithTitle:INHERIT_VALUE
                                            url:INHERIT_VALUE
                                           site:siteStr
                                        fromUrl:siteUrlStr
                                        comment:INHERIT_VALUE
                                        summary:INHERIT_VALUE
                                          image:INHERIT_VALUE
                                           type:INHERIT_VALUE
                                        playUrl:INHERIT_VALUE
                                           nswb:INHERIT_VALUE];
        }
        
        NSString *extInfoStr = nil;
        NSString *musicUrlStr = nil;
        
        NSString *extInfo = [contentDict objectForKey:@"extInfo"];
        if ([extInfo isKindOfClass:[NSString class]])
        {
            extInfoStr = extInfo;
        }
        
        NSString *musicUrl = [contentDict objectForKey:@"musicUrl"];
        if ([musicUrl isKindOfClass:[NSString class]])
        {
            musicUrlStr = musicUrl;
        }
        
        if (extInfoStr || musicUrlStr)
        {
            [contentObj addWeixinSessionUnitWithType:INHERIT_VALUE
                                             content:INHERIT_VALUE
                                               title:INHERIT_VALUE
                                                 url:INHERIT_VALUE
                                               image:INHERIT_VALUE
                                        musicFileUrl:musicUrlStr
                                             extInfo:extInfoStr
                                            fileData:INHERIT_VALUE
                                        emoticonData:INHERIT_VALUE];
            
            [contentObj addWeixinTimelineUnitWithType:INHERIT_VALUE
                                              content:INHERIT_VALUE
                                                title:INHERIT_VALUE
                                                  url:INHERIT_VALUE
                                                image:INHERIT_VALUE
                                         musicFileUrl:musicUrlStr
                                              extInfo:extInfoStr
                                             fileData:INHERIT_VALUE
                                         emoticonData:INHERIT_VALUE];
            
            [contentObj addWeixinFavUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                      thumbImage:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:musicUrlStr
                                         extInfo:extInfoStr
                                        fileData:INHERIT_VALUE
                                    emoticonData:INHERIT_VALUE];
        }
    }
    
    return contentObj;
}

void ShareSDKOpen (NSDictionary *params)
{

    if ([[params objectForKey:@"appkey"] isKindOfClass:[NSString class]])
    {
        [ShareSDK registerApp:[params objectForKey:@"appkey"]];
    }
    if ([[params objectForKey:@"enableStatistics"] isKindOfClass:[NSNumber class]])
    {
        [ShareSDK allowExchangeDataEnabled:[[params objectForKey:@"enableStatistics"] boolValue]];
    }
    
    //根据自己需要导入第三方SDK
    [WeiboSDK class];
    [ShareSDK importTencentWeiboClass:[WeiboApi class]];
//    [ShareSDK importGooglePlusClass:[GPPSignIn class] shareClass:[GPPShare class]];
    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
//    [ShareSDK importPinterestClass:[Pinterest class]];
    [ShareSDK importRenRenClass:[RennClient class]];
    [ShareSDK importWeChatClass:[WXApi class]];
    [ShareSDK importYiXinClass:[YXApi class]];
}

void ShareSDKSetPlatformConfig (NSDictionary *params)
{
    ShareType platType = ShareTypeAny;
    NSMutableDictionary *platConf = nil;
    
    if ([[params objectForKey:@"platform"] isKindOfClass:[NSNumber class]])
    {
        platType = (ShareType)[[params objectForKey:@"platform"] integerValue];
    }
    if ([[params objectForKey:@"config"] isKindOfClass:[NSDictionary class]])
    {
        platConf = [NSMutableDictionary dictionaryWithDictionary:[params objectForKey:@"config"]];
    }
    
    switch (platType)
    {
        case ShareTypeWeixiSession:
        case ShareTypeYiXinSession:
            [platConf setObject:[NSNumber numberWithInt:0] forKey:@"scene"];
            break;
        case ShareTypeWeixiTimeline:
        case ShareTypeYiXinTimeline:
            [platConf setObject:[NSNumber numberWithInt:1] forKey:@"scene"];
            break;
        case ShareTypeWeixiFav:
            [platConf setObject:[NSNumber numberWithInt:2] forKey:@"scene"];
            break;
        default:
            break;
    }
    
    [ShareSDK connectPlatformWithType:platType platform:nil appInfo:platConf];
}

void ShareSDKAuthorize (FREContext ctx, NSDictionary *params)
{
    ShareType platType = ShareTypeAny;
    if ([[params objectForKey:@"platform"] isKindOfClass:[NSNumber class]])
    {
        platType = (ShareType)[[params objectForKey:@"platform"] integerValue];
    }
    
    [ShareSDK authWithType:platType
                   options:nil
                    result:^(SSAuthState state, id<ICMErrorInfo> error) {
                        
                        NSString *code = @"SSDK_PA";
                        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     [NSNumber numberWithInteger:1],
                                                     @"action",
                                                     [NSNumber numberWithInteger:state],
                                                     @"status",
                                                     [NSNumber numberWithInteger:platType],
                                                     @"platform",
                                                     nil];
                        
                        if (state == SSAuthStateSuccess && error)
                        {
                            NSMutableDictionary *err = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:[error errorCode]] forKey:@"error_code"];
                            if ([error errorDescription])
                            {
                                [err setObject:[error errorDescription] forKey:@"error_msg"];
                            }
                            [data setObject:err forKey:@"res"];
                        }
                        
                        NSString *dataStr = [ShareSDK jsonStringWithObject:data];
                        
                        //派发事件
                        FREDispatchStatusEventAsync(ctx,
                                                    (uint8_t *)[code cStringUsingEncoding:NSUTF8StringEncoding],
                                                    (uint8_t *)[dataStr cStringUsingEncoding:NSUTF8StringEncoding]);
                        
                    }];
}

FREObject ShareSDKHasAuthroized (NSDictionary *params)
{
    ShareType platType = ShareTypeAny;
    if ([[params objectForKey:@"platform"] isKindOfClass:[NSNumber class]])
    {
        platType = (ShareType)[[params objectForKey:@"platform"] integerValue];
    }
    
    BOOL retValue = [ShareSDK hasAuthorizedWithType:platType];
    FREObject retObj = NULL;
    if (FRENewObjectFromBool(retValue, &retObj) == FRE_OK)
    {
        return retObj;
    }
    else
    {
        return NULL;
    }
}

void ShareSDKCancelAuthorize (NSDictionary *params)
{
    ShareType platType = ShareTypeAny;
    if ([[params objectForKey:@"platform"] isKindOfClass:[NSNumber class]])
    {
        platType = (ShareType)[[params objectForKey:@"platform"] integerValue];
    }
    
    [ShareSDK cancelAuthWithType:platType];
}

void ShareSDKGetUserInfo (FREContext ctx, NSDictionary *params)
{
    ShareType platType = ShareTypeAny;
    if ([[params objectForKey:@"platform"] isKindOfClass:[NSNumber class]])
    {
        platType = (ShareType)[[params objectForKey:@"platform"] integerValue];
    }
    
    [ShareSDK getUserInfoWithType:platType
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               NSString *code = @"SSDK_PA";
                               NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            [NSNumber numberWithInteger:8],
                                                            @"action",
                                                            result ? [NSNumber numberWithInteger:SSResponseStateSuccess] : [NSNumber numberWithInteger:SSResponseStateFail],
                                                            @"status",
                                                            [NSNumber numberWithInteger:platType],
                                                            @"platform",
                                                            nil];
                               
                               if (result)
                               {
                                   if ([userInfo sourceData])
                                   {
                                       [data setObject:[userInfo sourceData] forKey:@"res"];
                                   }
                               }
                               else
                               {
                                   NSMutableDictionary *err = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:[error errorCode]] forKey:@"error_code"];
                                   if ([error errorDescription])
                                   {
                                       [err setObject:[error errorDescription] forKey:@"error_msg"];
                                   }
                                   [data setObject:err forKey:@"res"];
                               }
                               
                               NSString *dataStr = [ShareSDK jsonStringWithObject:data];
                               
                               //派发事件
                               FREDispatchStatusEventAsync(ctx,
                                                           (uint8_t *)[code cStringUsingEncoding:NSUTF8StringEncoding],
                                                           (uint8_t *)[dataStr cStringUsingEncoding:NSUTF8StringEncoding]);
                           }];
}

void ShareSDKShare (FREContext ctx, NSDictionary *params)
{
//    ShareType platType = ShareTypeAny;
//    id<ISSContent> publicContent = nil;
//    if ([[params objectForKey:@"platform"] isKindOfClass:[NSNumber class]])
//    {
//        platType = (ShareType)[[params objectForKey:@"platform"] integerValue];
//    }
//    if ([[params objectForKey:@"shareParams"] isKindOfClass:[NSDictionary class]])
//    {
//        publicContent = convertPublicContent([params objectForKey:@"shareParams"]);
//    }
    
    ShareType platType = ShareTypeQQSpace;
    id<ISSContent> publicContent = [ShareSDK content:@"好耶～好高兴啊～"
                                      defaultContent:nil
                                               image:[ShareSDK imageWithUrl:@"http://f1.sharesdk.cn/imgs/2014/02/26/owWpLZo_638x960.jpg"]
                                               title:@"ShareSDK for ANE发布"
                                                 url:@"http://sharesdk.cn"
                                         description:@""
                                           mediaType:SSPublishContentMediaTypeText];
    [publicContent addQQSpaceUnitWithTitle:INHERIT_VALUE
                                       url:INHERIT_VALUE
                                      site:@"ShareSDK"
                                   fromUrl:@"http://sharesdk.cn"
                                   comment:INHERIT_VALUE
                                   summary:INHERIT_VALUE
                                     image:INHERIT_VALUE
                                      type:INHERIT_VALUE
                                   playUrl:INHERIT_VALUE
                                      nswb:INHERIT_VALUE];
    
    [ShareSDK shareContent:publicContent
                      type:platType
               authOptions:nil
              shareOptions:nil
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        NSString *code = @"SSDK_PA";
                        
                        NSMutableDictionary *resDict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:end]
                                                                                          forKey:@"end"];
                        
                        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     [NSNumber numberWithInteger:9],
                                                     @"action",
                                                     [NSNumber numberWithInteger:state] ,
                                                     @"status",
                                                     [NSNumber numberWithInteger:type],
                                                     @"platform",
                                                     resDict,
                                                     @"res",
                                                     nil];
                        
                        
                        
                        if (state == SSResponseStateSuccess)
                        {
                            if ([statusInfo sourceData])
                            {
                                [resDict setObject:[statusInfo sourceData] forKey:@"data"];
                            }
                        }
                        else if (state == SSResponseStateFail)
                        {
                            NSMutableDictionary *err = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:[error errorCode]] forKey:@"error_code"];
                            if ([error errorDescription])
                            {
                                [err setObject:[error errorDescription] forKey:@"error_msg"];
                            }
                            [resDict setObject:err forKey:@"error"];
                        }
                        
                        NSString *dataStr = [ShareSDK jsonStringWithObject:data];
                        
                        //派发事件
                        FREDispatchStatusEventAsync(ctx,
                                                    (uint8_t *)[code cStringUsingEncoding:NSUTF8StringEncoding],
                                                    (uint8_t *)[dataStr cStringUsingEncoding:NSUTF8StringEncoding]);
                        
                    }];
}

void ShareSDKOneKeyShare (FREContext ctx, NSDictionary *params)
{
    NSArray *platTypes = nil;
    id<ISSContent> publicContent = nil;
    if ([[params objectForKey:@"platforms"] isKindOfClass:[NSArray class]])
    {
        platTypes = [params objectForKey:@"platforms"];
    }
    if ([[params objectForKey:@"shareParams"] isKindOfClass:[NSDictionary class]])
    {
        publicContent = convertPublicContent([params objectForKey:@"shareParams"]);
    }
    
    [ShareSDK oneKeyShareContent:publicContent
                       shareList:platTypes
                     authOptions:nil
                    shareOptions:nil
                   statusBarTips:NO
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                              
                              NSString *code = @"SSDK_PA";
                              
                              NSMutableDictionary *resDict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:end]
                                                                                                forKey:@"end"];
                              
                              NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                           [NSNumber numberWithInteger:9],
                                                           @"action",
                                                           [NSNumber numberWithInteger:state],
                                                           @"status",
                                                           [NSNumber numberWithInteger:type],
                                                           @"platform",
                                                           resDict,
                                                           @"res",
                                                           nil];
                              
                              if (state == SSResponseStateSuccess)
                              {
                                  if ([statusInfo sourceData])
                                  {
                                      [resDict setObject:[statusInfo sourceData] forKey:@"data"];
                                  }
                              }
                              else if (state == SSResponseStateFail)
                              {
                                  NSMutableDictionary *err = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:[error errorCode]] forKey:@"error_code"];
                                  if ([error errorDescription])
                                  {
                                      [err setObject:[error errorDescription] forKey:@"error_msg"];
                                  }
                                  [resDict setObject:err forKey:@"error"];
                              }
                              
                              NSString *dataStr = [ShareSDK jsonStringWithObject:data];
                              
                              //派发事件
                              FREDispatchStatusEventAsync(ctx,
                                                          (uint8_t *)[code cStringUsingEncoding:NSUTF8StringEncoding],
                                                          (uint8_t *)[dataStr cStringUsingEncoding:NSUTF8StringEncoding]);
                              
                          }];
}

void ShareSDKShowShareMenu (FREContext ctx, NSDictionary *params)
{
        NSInteger x = 0;
        NSInteger y = 0;
        UIPopoverArrowDirection direction = UIPopoverArrowDirectionAny;
        
        NSArray *platTypes = nil;
        id<ISSContent> publicContent = nil;
        if ([[params objectForKey:@"platforms"] isKindOfClass:[NSArray class]])
        {
            platTypes = [params objectForKey:@"platforms"];
        }
        if ([[params objectForKey:@"shareParams"] isKindOfClass:[NSDictionary class]])
        {
            publicContent = convertPublicContent([params objectForKey:@"shareParams"]);
        }
        if ([[params objectForKey:@"x"] isKindOfClass:[NSNumber class]])
        {
            x = [[params objectForKey:@"x"] integerValue];
        }
        if ([[params objectForKey:@"y"] isKindOfClass:[NSNumber class]])
        {
            y = [[params objectForKey:@"y"] integerValue];
        }
        if ([[params objectForKey:@"direction"] isKindOfClass:[NSNumber class]])
        {
            direction = (UIPopoverArrowDirection)[[params objectForKey:@"direction"] integerValue];
        }
        
        id<ISSContainer> container = nil;
        if ([UIDevice currentDevice].isPad)
        {
            if (!_refView)
            {
                _refView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 1)];
            }
            
            [[UIApplication sharedApplication].keyWindow addSubview:_refView];
            
            container = [ShareSDK container];
            [container setIPadContainerWithView:_refView arrowDirect:direction];
        }
        
        [ShareSDK showShareActionSheet:container
                             shareList:platTypes
                               content:publicContent
                         statusBarTips:NO
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    NSString *code = @"SSDK_PA";
                                    
                                    NSMutableDictionary *resDict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:end]
                                                                                                      forKey:@"end"];
                                    
                                    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                 [NSNumber numberWithInteger:9],
                                                                 @"action",
                                                                 [NSNumber numberWithInteger:state],
                                                                 @"status",
                                                                 [NSNumber numberWithInteger:type],
                                                                 @"platform",
                                                                 resDict,
                                                                 @"res",
                                                                 nil];
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        if ([statusInfo sourceData])
                                        {
                                            [resDict setObject:[statusInfo sourceData] forKey:@"data"];
                                        }
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSMutableDictionary *err = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:[error errorCode]] forKey:@"error_code"];
                                        if ([error errorDescription])
                                        {
                                            [err setObject:[error errorDescription] forKey:@"error_msg"];
                                        }
                                        [resDict setObject:err forKey:@"error"];
                                    }
                                    
                                    NSString *dataStr = [ShareSDK jsonStringWithObject:data];
                                    
                                    //派发事件
                                    FREDispatchStatusEventAsync(ctx,
                                                                (uint8_t *)[code cStringUsingEncoding:NSUTF8StringEncoding],
                                                                (uint8_t *)[dataStr cStringUsingEncoding:NSUTF8StringEncoding]);
                                    
                                    if (_refView)
                                    {
                                        //移除视图
                                        [_refView removeFromSuperview];
                                    }
                                    
                                }];
}

void ShareSDKShowShareView (FREContext ctx, NSDictionary *params)
{
    ShareType platType = ShareTypeAny;
    id<ISSContent> publicContent = nil;
    if ([[params objectForKey:@"platform"] isKindOfClass:[NSNumber class]])
    {
        platType = (ShareType)[[params objectForKey:@"platform"] integerValue];
    }
    if ([[params objectForKey:@"shareParams"] isKindOfClass:[NSDictionary class]])
    {
        publicContent = convertPublicContent([params objectForKey:@"shareParams"]);
    }
    
    [ShareSDK showShareViewWithType:platType
                          container:nil
                            content:publicContent
                      statusBarTips:NO
                        authOptions:nil
                       shareOptions:nil
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 NSString *code = @"SSDK_PA";
                                 
                                 NSMutableDictionary *resDict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:end]
                                                                                                   forKey:@"end"];
                                 
                                 NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                              [NSNumber numberWithInteger:9],
                                                              @"action",
                                                              [NSNumber numberWithInteger:state],
                                                              @"status",
                                                              [NSNumber numberWithInteger:type],
                                                              @"platform",
                                                              resDict,
                                                              @"res",
                                                              nil];
                                 
                                 if (state == SSResponseStateSuccess)
                                 {
                                     if ([statusInfo sourceData])
                                     {
                                         [resDict setObject:[statusInfo sourceData] forKey:@"data"];
                                     }
                                 }
                                 else if (state == SSResponseStateFail)
                                 {
                                     NSMutableDictionary *err = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:[error errorCode]] forKey:@"error_code"];
                                     if ([error errorDescription])
                                     {
                                         [err setObject:[error errorDescription] forKey:@"error_msg"];
                                     }
                                     [resDict setObject:err forKey:@"error"];
                                 }
                                 
                                 NSString *dataStr = [ShareSDK jsonStringWithObject:data];
                                 
                                 //派发事件
                                 FREDispatchStatusEventAsync(ctx,
                                                             (uint8_t *)[code cStringUsingEncoding:NSUTF8StringEncoding],
                                                             (uint8_t *)[dataStr cStringUsingEncoding:NSUTF8StringEncoding]);
                                 
                             }];
}

void ShareSDKToast (NSDictionary *params)
{
    NSString *message = nil;
    if ([[params objectForKey:@"message"] isKindOfClass:[NSString class]])
    {
        message = [params objectForKey:@"message"];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tips"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

void ShareSDKHandleOpenURL (NSDictionary *params)
{
    NSString *url = nil;
    NSString *sourceApp = nil;
    NSString *annotation = nil;
    
    if ([[params objectForKey:@"url"] isKindOfClass:[NSString class]])
    {
        url = [params objectForKey:@"url"];
    }
    if ([[params objectForKey:@"source_app"] isKindOfClass:[NSString class]])
    {
        sourceApp = [params objectForKey:@"source_app"];
    }
    if ([[params objectForKey:@"annotation"] isKindOfClass:[NSString class]])
    {
        annotation = [params objectForKey:@"annotation"];
    }
    
    @try
    {
        [ShareSDK handleOpenURL:[NSURL URLWithString:url] sourceApplication:sourceApp annotation:annotation wxDelegate:nil];
    }
    @catch (NSException *exception)
    {
    }
}

FREObject ShareSDKUnsupportMethod (FREContext ctx, void* functionData, uint32_t argc, FREObject  argv[])
{
    return NULL;
}

FREObject ShareSDKCallMethod (FREContext ctx, void* functionData, uint32_t argc, FREObject  argv[])
{
    if (argc >= 1)
    {
        NSString *str = objectToString(argv[0]);
        NSDictionary *paramDict = [ShareSDK jsonObjectWithString:str];
        
        NSString *action = nil;
        if ([paramDict objectForKey:@"action"])
        {
            action = [paramDict objectForKey:@"action"];
            
            if ([action isEqualToString:@"initSDK"])
            {
                ShareSDKOpen([paramDict objectForKey:@"params"]);
            }
            else if ([action isEqualToString:@"setPlatformConfig"])
            {
                ShareSDKSetPlatformConfig ([paramDict objectForKey:@"params"]);
            }
            else if ([action isEqualToString:@"authorize"])
            {
                ShareSDKAuthorize (ctx, [paramDict objectForKey:@"params"]);
            }
            else if ([action isEqualToString:@"isVAlid"])
            {
                return ShareSDKHasAuthroized([paramDict objectForKey:@"params"]);
            }
            else if ([action isEqualToString:@"removeAuthorization"])
            {
                ShareSDKCancelAuthorize([paramDict objectForKey:@"params"]);
            }
            else if ([action isEqualToString:@"getUserInfo"])
            {
                ShareSDKGetUserInfo(ctx, [paramDict objectForKey:@"params"]);
            }
            else if ([action isEqualToString:@"share"])
            {
                ShareSDKShare(ctx, [paramDict objectForKey:@"params"]);
            }
            else if ([action isEqualToString:@"multishare"])
            {
                ShareSDKOneKeyShare(ctx, [paramDict objectForKey:@"params"]);
            }
            else if ([action isEqualToString:@"onekeyShare"])
            {
                ShareSDKShowShareMenu (ctx, [paramDict objectForKey:@"params"]);
            }
            else if ([action isEqualToString:@"showShareView"])
            {
                ShareSDKShowShareView (ctx, [paramDict objectForKey:@"params"]);
            }
            else if ([action isEqualToString:@"toast"])
            {
                ShareSDKToast ([paramDict objectForKey:@"params"]);
            }
            else if ([action isEqualToString:@"handleOpenURL"])
            {
                ShareSDKHandleOpenURL ([paramDict objectForKey:@"params"]);
            }
        }
    }
    
    return NULL;
}

void ShareSDKContextInitializer (void*  extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToSet = 1;
    
    FRENamedFunction *func = (FRENamedFunction *)malloc(sizeof(FRENamedFunction) * *numFunctionsToSet);
    
    func[0].name = (const uint8_t*)"ShareSDKUtils";
	func[0].functionData = NULL;
	func[0].function = &ShareSDKCallMethod;
    
    *functionsToSet = func;
}

void ShareSDKContextFinalizer (FREContext ctx)
{
    if (_refView)
    {
        [_refView release];
        _refView = nil;
    }
}

/**
 *	@brief	初始化ShareSDK方法
 *
 *	@param 	extDataToSet 	扩展数据设置
 *	@param 	ctxInitializerToSet 	初始化函数
 *	@param 	ctxFinalizerToSet 	析构函数
 */
void ShareSDKInitializer (void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &ShareSDKContextInitializer;
    *ctxFinalizerToSet = &ShareSDKContextFinalizer;
}

/**
 *	@brief  终止化ShareSDK方法
 *
 *	@param 	extData 	扩展数据
 */
void ShareSDKFinalizer (void* extData)
{
    
}