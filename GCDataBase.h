//
//  GCDataBase.h
//  网络数据请求and数据库的封装
//
//  Created by Ghost on 15-6-4.
//  Copyright (c) 2015年 GhostClock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"

#import "Item_Limit.h"

//枚举, 记录类型-------->
typedef enum {
    
    RecordTypeShare,
    RecordTypeFavorite,
    RecordTypeDownload
    
}RecordType;


@interface GCDataBase : NSObject

@property(retain,nonatomic)FMDatabase * dataBase;

@property(retain,nonatomic)FMDatabase * dataBaseCollect;

-(GCDataBase *)init;
//插入数据
-(BOOL)insertData:(NSArray *)dataArray;

-(BOOL)insertDataCollect:(NSArray *)dataArray;


//通过标题来删除数据
-(BOOL)deleteDataForTitle:(NSArray *)titleArray;

-(BOOL)deleteDataForTitleCollect:(NSString *)name;

//删除全部数据
-(BOOL)deleteAllData;

-(BOOL)deleteAllDataCollect;
//更改标题
//第一个参数是旧标题，用于找到需要操作的这条数据
//第二个参数是新标题，
-(BOOL)updataTitle:(NSString *)oldTitle toNewTitle:(NSString *)newtitle;

-(BOOL)updataTitleColect:(NSString *)oldTitle toNewTitle:(NSString *)newtitle;

//更改任意字段的值
//第一个参数：需要更改的字段名
//第二个参数：用于查找该条数据的一个值
//第三个参数：需要修改的字段的新的值
-(BOOL)updataColoum:(NSString *)coloum withOldTitle:(NSString *)oldTitle andNewValue:(NSString *)newValue;

-(BOOL)updataColoumCloect:(NSString *)coloum withOldTitle:(NSString *)oldTitle andNewValue:(NSString *)newValue;

//查询所有数据
-(NSArray *)selectData;

-(NSArray *)selectDataFavourite;


//根据标题查找数据
-(NSArray *)selectDataForTitle:(NSString *)title;



@end
