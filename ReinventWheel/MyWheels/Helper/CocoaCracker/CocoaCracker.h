//
//  CocoaCracker.h
//  Zeughaus
//
//  Created by 常小哲 on 16/4/12.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface CocoaCracker : NSObject

/*!
 *  类方法 处理某个需要获取属性的对象
 */
+ (instancetype)handle:(Class)cls;

/*!
 *  对象方法 处理某个需要获取属性的对象
 */
- (instancetype)initWithClass:(Class)cls;

/*!
 *  获取类的属性 block返回属性名
 */
- (void)copyModelPropertyName:(void(^)(NSString *pName))block;

/*!
 *  获取类的属性 block返回简短的属性类型名
 */
- (void)copyModelPropertyType:(void(^)(NSString *pType))block;

/*!
 *  获取类的属性 block返回完整的属性类型名
 */
- (void)copyModelPropertyTypeEntirely:(void(^)(NSString *pTypeEntirely))block;

/*!
 *  获取类的属性 block返回属性对象
 */
- (void)copyModelPropertyInfo:(void(^)(NSString *pName, NSString *pType))block
            copyAttriEntirely:(BOOL)isCopy;

/*!
 *  获取类的属性 block返回属性对象
 */
- (void)copyModelPropertyList:(void(^)(objc_property_t property))propertyBlock;

/*!
 *  用一个方法替换另一个方法
 */
- (BOOL)swizzleMethod:(SEL)oldSelector withMethod:(SEL)newSelector;


@end

NS_ASSUME_NONNULL_END