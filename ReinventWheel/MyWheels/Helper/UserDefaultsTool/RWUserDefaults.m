//
//  RWUserDefaults.m
//  Test05111544
//
//  Created by Ranger on 16/5/17.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWUserDefaults.h"
#import "CocoaCracker.h"
@import UIKit;

#define Make_Setter_Method(_paramClass_, _setStatement_)  \
method_setImplementation(setterMethod, imp_implementationWithBlock(^(id obj, _paramClass_ param) {  \
[_userDefault _setStatement_:param forKey:name];\
[_userDefault synchronize];\
}))

#define Make_Getter_Method(_returnClass_,_getStatement_)    \
method_setImplementation(getterMethod, imp_implementationWithBlock(^(id obj) {  \
_returnClass_ returnObject = [_userDefault _getStatement_:name];  \
return returnObject;    \
}))

#define OverrideSetterAndGetter(_paramClass_, _setStatement_, _getStatement_)   \
Make_Setter_Method(_paramClass_, _setStatement_);    \
Make_Getter_Method(_paramClass_, _getStatement_)

typedef NS_ENUM(NSUInteger, PropertyType) {
    PropertyType_unknow = -1,
    PropertyType_string = 0,
    PropertyType_number,
    PropertyType_date,
    PropertyType_data,
    PropertyType_array,
    PropertyType_dictionary,
    PropertyType_url,
    PropertyType_integer,
    PropertyType_bool,
    PropertyType_double,
    PropertyType_float,
    PropertyType_color
};

@interface RWUserDefaults () {
    NSUserDefaults  *_userDefault;
    NSMutableDictionary   *_propertyStore;
    Class _registeredClass;
}

@property (nonatomic, strong) NSDictionary *propertyTypeMap;

@end

@implementation RWUserDefaults

+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark-   public methods

- (void)registerClass:(Class)aClass {
    _registeredClass = aClass;
    _propertyStore = [self allProperty:aClass];
    [_propertyStore enumerateKeysAndObjectsUsingBlock:^(NSString *property,
                                                       NSString *type,
                                                       BOOL * _Nonnull stop) {
        [self checkType:type propertyName:property];
    }];
}

- (void)unregisterClass:(Class)aClass {
    [_propertyStore removeAllObjects];
    _registeredClass = nil;
}

- (void)removeObjectForKey:(NSString *)key {
    [_userDefault removeObjectForKey:key];
}

- (void)removeObjectsForKeys:(NSArray *)keys {
    for (NSString *key in keys) {
        for (NSString *property in [_propertyStore allKeys]) {
            if ([key isEqualToString:property]) {
                [self removeObjectForKey:key];
            }
        }
    }
}

- (void)cleanUserdefaults {
    [self removeObjectsForKeys:[_propertyStore allKeys]];
}

#pragma mark-   private methods
#pragma mark-   get all property of a class

- (NSMutableDictionary *)allProperty:(Class)aClass {
    NSMutableDictionary *propertiesDict = [NSMutableDictionary new];
    [[CocoaCracker handle:aClass] copyModelPropertyInfo:^(NSString *pName, NSString *pType) {
        NSString *type = [self typeName:pType];
        propertiesDict[pName] = type;
    } copyAttriEntirely:YES];
    return propertiesDict;
}

#pragma mark-  property map

- (NSString *)typeName:(NSString *)pType {
    NSString *typeName;
    NSString *propertyType = [pType substringFromIndex:1];
    
    if ([propertyType hasPrefix:@"@"]) {
        NSRange range = [propertyType rangeOfString:@","];
        if (range.length > 0)
            range = NSMakeRange(2, range.location - 3);
        
        if (range.location + range.length <= propertyType.length)
            typeName = [propertyType substringWithRange:range];
        
        if ([typeName hasSuffix:@">"])
            typeName = [typeName substringToIndex:[typeName rangeOfString:@"<"].location];
        
        typeName = self.propertyTypeMap[typeName];
    }
    else typeName = self.propertyTypeMap[[propertyType substringToIndex:1]];
    
    if (!typeName || [typeName isEqual:[NSNull null]]) typeName = @"unknow";
    return typeName;
}

- (NSDictionary *)propertyTypeMap {
    if (_propertyTypeMap) return _propertyTypeMap;
    _propertyTypeMap = @{
         @"NSString" : @"string",
         @"NSNumber" : @"number",
         @"NSDate" : @"date",
         @"NSData" : @"data",
         @"NSArray" : @"array",
         @"NSDictionary" : @"dictionary",
         @"NSURL" : @"url",
         @"q" : @"integer",
         @"Q" : @"integer",
         @"i" : @"integer",
         @"I" : @"integer",
         @"s" : @"integer",
         @"S" : @"integer",
         @"B" : @"bool",
         @"c" : @"bool",      // BOOL,char type: c
         @"d" : @"double",
         @"f" : @"float",
         @"UIColor" : @"color"
    };
    return _propertyTypeMap;
}

- (NSInteger)convertPropertyTypeMapToEnums:(NSString *)typeName {
    
    if ([typeName isEqualToString:@"string"]) return PropertyType_string;
    else if ([typeName isEqualToString:@"number"]) return PropertyType_number;
    else if ([typeName isEqualToString:@"date"]) return PropertyType_date;
    else if ([typeName isEqualToString:@"data"]) return PropertyType_data;
    else if ([typeName isEqualToString:@"array"]) return PropertyType_array;
    else if ([typeName isEqualToString:@"dictionary"]) return PropertyType_dictionary;
    else if ([typeName isEqualToString:@"url"]) return PropertyType_url;
    else if ([typeName isEqualToString:@"integer"]) return PropertyType_integer;
    else if ([typeName isEqualToString:@"bool"]) return PropertyType_bool;
    else if ([typeName isEqualToString:@"double"]) return PropertyType_double;
    else if ([typeName isEqualToString:@"float"]) return PropertyType_float;
    else if ([typeName isEqualToString:@"color"]) return PropertyType_color;
    return PropertyType_unknow;
}

#pragma mark-  core methods

- (void)checkType:(NSString *)typeName propertyName:(NSString *)name {
    
    // setter
    NSString *setter = [self handleString:name];
    SEL setterSelector = NSSelectorFromString(setter);
    Method setterMethod = class_getInstanceMethod(_registeredClass, setterSelector);
    
    // getter
    SEL getterSelector = NSSelectorFromString(name);
    Method getterMethod = class_getInstanceMethod(_registeredClass, getterSelector);
    
    PropertyType pType = [self convertPropertyTypeMapToEnums:typeName];
    switch (pType) {
        case PropertyType_unknow: {
            NSAssert(NO, @"the property [%@] can not be supported", name);
            break;
        }
            
        case PropertyType_string: {
            OverrideSetterAndGetter(NSString *, setObject, objectForKey);
            break;
        }
            
        case PropertyType_number: {
            OverrideSetterAndGetter(NSNumber *, setObject, objectForKey);
            break;
        }
            
        case PropertyType_date: {
            OverrideSetterAndGetter(NSDate *, setObject, objectForKey);
            break;
        }
            
        case PropertyType_data: {
            OverrideSetterAndGetter(NSData *, setObject, dataForKey);
            break;
        }
            
        case PropertyType_array: {
            OverrideSetterAndGetter(NSArray *, setObject, arrayForKey);
            break;
        }
            
        case PropertyType_dictionary: {
            OverrideSetterAndGetter(NSDictionary *, setObject, dictionaryForKey);
            break;
        }
            
        case PropertyType_url: {
            OverrideSetterAndGetter(NSURL *, setURL, URLForKey);
            break;
        }

        case PropertyType_integer: {
            OverrideSetterAndGetter(NSInteger, setInteger, integerForKey);
            break;
        }
            
        case PropertyType_bool: {
            OverrideSetterAndGetter(BOOL, setBool, boolForKey);
        }
            break;
            
        case PropertyType_double: {
            OverrideSetterAndGetter(double, setDouble, doubleForKey);
            break;
        }
 
        case PropertyType_float: {
            OverrideSetterAndGetter(float, setFloat, floatForKey);
            break;
        }

        // 这里的UIColor 转成string 然后存  同理的还有 CGRect Class 任何可转string的
        case PropertyType_color: {
            
            method_setImplementation(setterMethod, imp_implementationWithBlock(^(id obj, UIColor *param) {
                CGColorRef colorRef = param.CGColor;
                NSString *colorStr = [CIColor colorWithCGColor:colorRef].stringRepresentation;
                [_userDefault setObject:colorStr forKey:name];
                [_userDefault synchronize];
            }));
            
            method_setImplementation(getterMethod, imp_implementationWithBlock(^(id obj) {
                NSString *colorStr = [_userDefault objectForKey:name];
                UIColor *returnColor = [UIColor colorWithCIColor:[CIColor colorWithString:colorStr]];
                return returnColor;
            }));
            break;
        }
            
        default: break;
    }
}


#pragma mark-  utils

- (NSString *)handleString:(NSString *)propertyName {
    NSString *setter = @"set";
    NSString *tmpString = [[propertyName capitalizedString] substringToIndex:1];
    tmpString = [tmpString stringByAppendingString:[propertyName substringFromIndex:1]];
    setter = [setter stringByAppendingString:tmpString];
    return [setter stringByAppendingString:@":"];
}

@end
