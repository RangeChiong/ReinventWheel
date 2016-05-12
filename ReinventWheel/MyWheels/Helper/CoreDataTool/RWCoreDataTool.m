//
//  RWCoreDataTool.m
//  Test1009
//
//  Created by CXZ on 15/10/9.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import "RWCoreDataTool.h"
#import "CocoaCracker.h"
#import <CoreData/CoreData.h>

@interface RWCoreDataTool ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end

@implementation RWCoreDataTool

+ (RWCoreDataTool *)shareTool {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

#pragma mark - Core Data Saving support

- (BOOL)saveContext {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
            return NO;
        }
    }
    return YES;
}

// 获取实体对象
- (__kindof NSManagedObject *)newEntity:(Class)aClass {
    return [[NSManagedObject alloc] initWithEntity:[self entityForName:aClass]
                    insertIntoManagedObjectContext:nil];
}

#pragma mark-   插入数据

- (BOOL)insertCoreData:(NSArray *)dataArray
{
    BOOL isSave = NO;
    for (NSManagedObject *entity in dataArray) {
        Class entityClass = [entity class];
        NSManagedObject *obj = [self insertNewObject:entityClass];
        [[CocoaCracker handle:entityClass] copyModelPropertyName:^(NSString *pName) {
            // 获取new的实体对象在外面的属性赋值 然后通过KVC赋值给create的对象
            [obj setValue:[entity valueForKey:pName] forKey:pName];
        }];

        isSave = [self saveContext];
        if (!isSave) {
            NSLog(@"fail to insert data");
            break;
        }
    }
    return isSave;
}

- (BOOL)insertCoreData:(Class)aClass paramDict:(NSDictionary *)dict {
    
    // 插入实体描述对象
    NSManagedObject * obj = [self insertNewObject:aClass];
    if (obj) {
        // 赋值
        [obj setValuesForKeysWithDictionary:dict];
        // 保存数据
        return [self saveContext];
    }
    return NO;
}

- (BOOL)insertCoreData:(Class)aClass value:(void(^)(NSManagedObject *obj))value {
    BOOL isSave = NO;
    // 插入实体描述对象
    NSManagedObject * obj = [self insertNewObject:aClass];
    // 赋值
    if (obj) {
        if (value) {
            value(obj);
            // 保存数据
            isSave = [self saveContext];
        }
    }
    return isSave;
}

#pragma mark-   查询数据

- (NSArray *)searchCoreData:(Class)aClass {
    return [self searchCoreData:aClass predicate:nil];
}

- (NSArray *)searchCoreData:(Class)aClass predicate:(NSString *)predicateString
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [self createFetchRequest:aClass predicate:predicateString];
    
    NSError *error;
    return [managedObjectContext executeFetchRequest:fetchRequest error:&error];
}


#pragma mark-   删除数据
- (BOOL)deleteCoreData:(Class)aClass predicate:(NSString *)predicateString
{
    NSArray *entityArr = [self searchCoreData:aClass predicate:predicateString];
    if (!entityArr.count) {
        NSLog(@"未找到数据");
        return NO;
    }
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    BOOL hasDeleted = NO;
    for (NSManagedObject *obj in entityArr) {
        [managedObjectContext deleteObject:obj];
        
        if ([obj isDeleted]) {
            hasDeleted = [self saveContext];
            if (!hasDeleted) {
                NSLog(@"failed to delete the core data");
                break;
            }
        }else {
            NSLog(@"failed to delete the core data");
            hasDeleted = NO;
            break;
        }
    }
    return hasDeleted;
}

#pragma mark-   更改数据
- (BOOL)updateCoreData:(Class)aClass
             predicate:(NSString *)predicateString
                update:(void(^)(__kindof NSManagedObject *obj))update {
    
    NSArray *entityArr = [self searchCoreData:aClass predicate:predicateString];
    if (!entityArr.count) {
        NSLog(@"未找到数据");
        return NO;
    }
    if (update) {
        for (NSManagedObject *entity in entityArr) {
            update(entity);
        }
    }else return NO;

    return [self saveContext];
}

#pragma mark-   Setter & Getter

// 数据库文件名 默认情况下是工程名
- (NSString *)datastoreFileName {
    if (!_datastoreFileName) {
        _datastoreFileName = [NSString stringWithFormat:@"%@.sqlite",[self projectName]];
    }
    return _datastoreFileName;
}

/*
 *  sqlite文件的路径  默认是在Documents下
 */
- (NSURL *)datastoreFilePath {
    if (!_datastoreFilePath) {
        _datastoreFilePath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    }
    return _datastoreFilePath;
}

/*
 *  获取项目名称 默认情况下是作为coreData编辑器的名字
 */
- (NSString *)projectName {
    if (!_projectName) {
        _projectName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
    }
    return _projectName;
}

#pragma mark - Core Data stack

// 数据模型管理器的懒加载  要根据sqlite文件来创建  文件名很重要
- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel) return _managedObjectModel;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:[self projectName]
                                              withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// 根据翻译 这是持久性数据协调器  的加载   要根据数据模型管理器来创建
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator)  return _persistentStoreCoordinator;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self datastoreFilePath] URLByAppendingPathComponent:[self datastoreFileName]];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

// 数据模型内容管理器的加载 要根据持久性数据协调器来
- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext) return _managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) return nil;
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}


#pragma mark-  private methods

// 创建拉取请求
- (NSFetchRequest *)createFetchRequest:(Class)aClass predicate:(NSString *)predicateString {
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [self entityForName:aClass];
    [fetchRequest setEntity:entity];
    
    if (predicateString != nil) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:predicateString];
        [fetchRequest setPredicate:predicate];
    }
    
    return fetchRequest;
}

// 获取即将做插入操作的实体对象
- (__kindof NSManagedObject *)insertNewObject:(Class)aClass {
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(aClass)
                                         inManagedObjectContext:[self managedObjectContext]];
}

// 创建NSEntityDescription实例对象
- (NSEntityDescription *)entityForName:(Class)aClass {
    return [NSEntityDescription entityForName:NSStringFromClass(aClass)
                       inManagedObjectContext:self.managedObjectContext];
}

@end
