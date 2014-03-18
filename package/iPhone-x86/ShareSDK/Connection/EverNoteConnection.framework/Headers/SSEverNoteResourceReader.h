//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SSEverNoteResourceDataReader.h"
#import "SSEverNoteResourceAttributesReader.h"

/**
 *	@brief	资源读取器
 */
@interface SSEverNoteResourceReader : NSObject
{
@private
    NSDictionary *_sourceData;
}

/**
 *	@brief	源数据
 */
@property (nonatomic,readonly) NSDictionary *sourceData;

/**
 *	@brief	资源标识
 */
@property (nonatomic,readonly) NSString *guid;

/**
 *	@brief	笔记标识
 */
@property (nonatomic,readonly) NSString *noteGuid;

/**
 *	@brief	资源内容
 */
@property (nonatomic,readonly) SSEverNoteResourceDataReader *data;

/**
 *	@brief	MIME类型
 */
@property (nonatomic,readonly) NSString *mime;

/**
 *	@brief	宽度
 */
@property (nonatomic,readonly) int16_t width;

/**
 *	@brief	高度
 */
@property (nonatomic,readonly) int16_t height;

/**
 *	@brief	已过时：忽略
 */
@property (nonatomic,readonly) int16_t duration;

/**
 *	@brief	已过时：忽略
 */
@property (nonatomic,readonly) BOOL active;

/**
 *	@brief	提供搜索识别资源数据
 */
@property (nonatomic,readonly) SSEverNoteResourceDataReader *recognition;


/**
 *	@brief	资源属性
 */
@property (nonatomic,readonly) SSEverNoteResourceAttributesReader *attributes;

/**
 *	@brief	最后修改此对象的事务标识
 */
@property (nonatomic,readonly) NSInteger updateSequenceNum;

/**
 *	@brief	备用数据
 */
@property (nonatomic,readonly) SSEverNoteResourceDataReader *alternateData;

/**
 *	@brief	初始化读取器
 *
 *	@param 	sourceData 	原数据
 *
 *	@return	读取器实例对象
 */
- (id)initWithSourceData:(NSDictionary *)sourceData;

/**
 *	@brief	创建资源信息读取器
 *
 *	@param 	sourceData 	原数据
 *
 *	@return	读取器实例对象
 */
+ (SSEverNoteResourceReader *)readerWithSourceData:(NSDictionary *)sourceData;

@end
