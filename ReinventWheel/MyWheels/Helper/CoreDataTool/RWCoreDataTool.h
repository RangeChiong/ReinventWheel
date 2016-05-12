//
//  RWCoreDataTool.h
//  Test1009
//
//  Created by CXZ on 15/10/9.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSManagedObject;

@interface RWCoreDataTool : NSObject

@property (nonatomic, copy) NSString *datastoreFileName;    //!< 数据库文件名 默认情况下是工程名
@property (nonatomic, strong) NSURL *datastoreFilePath; //!< sqlite文件的路径  默认是在Documents下
@property (nonatomic, copy) NSString *projectName; //!< 获取项目名称 默认情况下是作为coreData编辑器的名字

+ (RWCoreDataTool *)shareTool;

/*!
 *  保存对象
 */
- (BOOL)saveContext;

/*!
 *  获得实体对象 赋值 再做其他操作
 */
- (__kindof NSManagedObject *)newEntity:(Class)aClass;

//----------------------------------插入数据----------------------------------

/*!
 *  插入已经赋值好的实体对象 dataArray:存放数据model的数组
 */
- (BOOL)insertCoreData:(NSArray *)dataArray;

/*!
 *  先构造一个字典 键值对应上模型的属性和属性值 然后调用该方法
 */
- (BOOL)insertCoreData:(Class)aClass paramDict:(NSDictionary *)dict;

/*!
 *  block返回一个未赋值对象 然后用KVC在外部赋值 完成插入
 *  或者强转成自定义的实体类来属性赋值
 */
- (BOOL)insertCoreData:(Class)aClass value:(void(^)(NSManagedObject *obj))value;


//----------------------------------查询数据----------------------------------

/*!
 *  查询数据
 */
- (NSArray *)searchCoreData:(Class)aClass;

/*!
 *  通过谓词查询数据
 */
- (NSArray *)searchCoreData:(Class)aClass predicate:(NSString *)predicateString;


//----------------------------------删除数据----------------------------------

/*!
 *  通过谓词先查找数据 再删除数据
 */
- (BOOL)deleteCoreData:(Class)aClass predicate:(NSString *)predicateString;

//----------------------------------更改数据----------------------------------

/*!
 *  先查找数据 将找到的结果block返回到外面赋值 内部继续执行save操作
 */
- (BOOL)updateCoreData:(Class)aClass
             predicate:(NSString *)predicateString
                update:(void(^)(__kindof NSManagedObject *obj))update;

@end
