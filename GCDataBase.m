//
//  GCDataBase.m
//  网络数据请求and数据库的封装
//
//  Created by Ghost on 15-6-4.
//  Copyright (c) 2015年 GhostClock. All rights reserved.
//

#import "GCDataBase.h"
#import "Item_Limit.h"

@implementation GCDataBase

-(GCDataBase *)init{
    
    if (self = [super init]) {
        NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString * dataPath = [path stringByAppendingPathComponent:@"Ai_xian_mian.db"];
        
        _dataBase = [FMDatabase databaseWithPath:dataPath];
        _dataBaseCollect = [FMDatabase databaseWithPath:dataPath];
        
        NSLog(@"%@",dataPath);
        
        BOOL b = [_dataBase open];
        
        BOOL c = [_dataBaseCollect open];
        
        if (b && c) {
            NSLog(@"打开成功");
        }

            NSString * Item_Limit_sql = @"create table if not exists Aixianmian (Id integer primary key autoincrement,imageUrl text,Share_Label text,Collect_Label text,Download_Label text,Title_Label text,Price_Label text,Classify_Label text,appid text,currentPrice text)";
            
            BOOL n = [_dataBase executeUpdate:Item_Limit_sql];
            if (!n ) {
                NSLog(@"表创建失败");
            }
            

            NSString * Item_collect_sql = @"create table if not exists Collect (Id integer primary key autoincrement,name text,iconUrl text,applicationId text)";
            
            BOOL m = [_dataBaseCollect executeUpdate:Item_collect_sql];
            if (!m) {
                
                NSLog(@"Item_collect_sql --> 表创建失败");
            }
        
    }
    
    return self;
}
//
//插入数据
-(BOOL)insertData:(NSArray *)dataArray{
    
        for (int i = 0; i < dataArray.count; i ++) {
            Item_Limit * item = [dataArray objectAtIndex:i];
            
            NSString * Item_Limit_sql = @"insert into Aixianmian (imageUrl,Share_Label,Collect_Label,Download_Label,Title_Label,Price_Label,Classify_Label,appid,currentPrice) values (?,?,?,?,?,?,?,?,?)";
            BOOL b =  [_dataBase executeUpdate:Item_Limit_sql,item.imageUrl,item.Share_Label,item.Collect_Label,item.Download_Label,item.Title_Label,item.Price_Label,item.Classify_Label,item.ID,item.currentPrice];
            
            if (!b) {
                NSLog(@"插入失败");
            }
        }
    
    return YES;
}

-(BOOL)insertDataCollect:(NSArray *)dataArray{
    
        NSString * Item_Collect_sql = @"insert into Collect(name,iconUrl,applicationId) values (?,?,?)";
        
        BOOL b = [_dataBaseCollect executeUpdate:Item_Collect_sql,[dataArray objectAtIndex:0],[dataArray objectAtIndex:1],[dataArray objectAtIndex:2]];
        
        if (!b) {
            NSLog(@"Collect 插入失败");
        }
    return YES;
}

//通过标题来删除数据
-(BOOL)deleteDataForTitle:(NSArray *)titleArray{

        NSString * Item_Limit_sql = @"delete from Aixianmian where title = ?";
        [_dataBase executeUpdate:Item_Limit_sql,titleArray];

    return YES;
}
//通过标题来删除数据
-(BOOL)deleteDataForTitleCollect:(NSString *)name{
    
    NSString * Item_Collect_sql = @"delete from Collect where name = ?";
    [_dataBaseCollect executeUpdate:Item_Collect_sql,name];
  
    return YES;
}

//删除全部数据
-(BOOL)deleteAllData{

    NSString * Item_Limit_sql = @"delete from Aixianmian";
    [_dataBase executeUpdate:Item_Limit_sql];

    return YES;
}
//删除全部数据
-(BOOL)deleteAllDataCollect{
    NSString * Item_Collect_sql = @"delete from Collect";
    [_dataBaseCollect executeUpdate:Item_Collect_sql];
    
    return YES;
}

//更改标题
//第一个参数是旧标题，用于找到需要操作的这条数据
//第二个参数是新标题，
-(BOOL)updataTitle:(NSString *)oldTitle toNewTitle:(NSString *)newtitle{

    NSString * Item_Limit_sql = @"update Aixianmian set title = ? where title = ?";
    [_dataBase executeUpdate:Item_Limit_sql,newtitle,oldTitle];

    return YES;
}

-(BOOL)updataTitleColect:(NSString *)oldTitle toNewTitle:(NSString *)newtitle{
    NSString * Item_Collect_sql = @"update Collect set title = ? where title = ?";
    [_dataBase executeUpdate: Item_Collect_sql,newtitle,oldTitle];
    return YES;
}

//更改任意字段的值
//第一个参数：需要更改的字段名
//第二个参数：用于查找该条数据的一个值
//第三个参数：需要修改的字段的新的值
-(BOOL)updataColoum:(NSString *)coloum withOldTitle:(NSString *)oldTitle andNewValue:(NSString *)newValue{

    NSString * Item_Limit_sql = [NSString stringWithFormat:@"update Aixianmian set %@ = ? where title = ?",coloum];
    [_dataBase executeUpdate:Item_Limit_sql,newValue,oldTitle];

    return YES;
    
}

-(BOOL)updataColoumCloect:(NSString *)coloum withOldTitle:(NSString *)oldTitle andNewValue:(NSString *)newValue{
    NSString * Item_Collect_sql = [NSString stringWithFormat:@"updata Collect set %@ = ? where title = ?",coloum];
    [_dataBase executeUpdate:Item_Collect_sql,newValue,oldTitle];
    return YES;
    
}

//查询所有数据
-(NSArray *)selectData{
        NSString * Item_Limit_sql = @"select * from Aixianmian";
        FMResultSet * set = [_dataBase executeQuery:Item_Limit_sql];
        NSMutableArray * array = [[NSMutableArray alloc]init];
        while (set.next) {
            
            Item_Limit * item = [[Item_Limit alloc]init];
            item.imageUrl = [set stringForColumn:@"imageUrl"];
            item.Share_Label = [set stringForColumn:@"Share_Label"];
            item.Collect_Label = [set stringForColumn:@"Collect_Label"];
            item.Download_Label = [set stringForColumn:@"Download_Label"];
            item.Title_Label = [set stringForColumn:@"Title_Label"];
            item.Price_Label = [set stringForColumn:@"Price_Label"];
            item.Classify_Label = [set stringForColumn:@"Classify_Label"];
            item.currentPrice = [set stringForColumn:@"currentPrice"];
            item.ID = [set stringForColumn:@"appid"];
            
            item.currentPrice = [set stringForColumn:@"currentPrice"];
            
            [array addObject:item];
        }
        return array;
}
-(NSArray *)selectDataFavourite{
    
        NSString * Item_Collect_sql = @"select * from Collect";
        FMResultSet * setCollect = [_dataBaseCollect executeQuery:Item_Collect_sql];
        NSMutableArray * arrayCollect = [[NSMutableArray alloc]init];
        while (setCollect.next) {
            Item_Limit * item = [[Item_Limit alloc]init];
            item.iconUrl_Collect = [setCollect stringForColumn:@"iconUrl"];
            item.name_Collect = [setCollect stringForColumn:@"name"];
            item.applicationId_Collect = [setCollect stringForColumn:@"applicationId"];
            
            [arrayCollect addObject:item.applicationId_Collect];
            
        }
        return arrayCollect;
}


//根据标题查找数据
-(NSArray *)selectDataForTitle:(NSString *)name{

    NSLog(@"name = %@",name);
    
    NSMutableArray * arrayCollect = [[NSMutableArray alloc]init];
    
    NSString * Item_Collect_sql = @"select * from Collect where name = ?";
    
    FMResultSet * setCollect = [_dataBaseCollect executeQuery:Item_Collect_sql,name];

    while (setCollect.next) {
        
        Item_Limit * item = [[Item_Limit alloc]init];
        item.name_Collect = [setCollect stringForColumn:name];
        
        [arrayCollect addObject:item];
    }
    
    
    return arrayCollect;
    
}



//================================
@end
