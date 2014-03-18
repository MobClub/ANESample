//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
	表格项接口，所有在ZGGridView中显示的项目都需要实现此接口.
 */
@protocol ICMGridItemView <NSObject>

@required

/**
 *	@brief	获取数据.
 *
 *	@return	数据对象.
 */
- (id)data;


/**
 *	@brief	设置数据.
 *
 *	@param 	data 	数据对象.
 */
- (void)setData:(id)data;


/**
 *	@brief	获取索引
 *
 *	@return	索引值
 */
- (NSInteger)index;

/**
 *	@brief	设置索引
 *
 *	@param 	index 	索引值
 */
- (void)setIndex:(NSInteger)index;

@end
