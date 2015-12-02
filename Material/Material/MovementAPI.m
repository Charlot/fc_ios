//
//  MovementAPI.m
//  Material
//
//  Created by ryan on 11/23/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "MovementAPI.h"
#import "Movement.h"
#import "DBManager.h"
#import "AFNetOperate.h"
#define kPageSzieKey 30

@interface MovementAPI ()
@property(nonatomic, strong) DBManager *db;
@property(nonatomic, strong) AFNetOperate *afnet;
@end

@implementation MovementAPI

- (instancetype)init {
  self = [super init];
  if (self) {
    _afnet = [[AFNetOperate alloc] init];
    _db = [[DBManager alloc] initWithDatabaseFilename:@"wmsdb.sql"];
  }
  return self;
}

- (void)getNStoragePackageInfo:(NSString *)package_id
                      withView:(UIView *)optView
                         block:(void (^)(NSMutableArray *, NSError *))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];
  [manager GET:[self.afnet getNStoragePackageInfo]
      parameters:@{
        @"package_id" : package_id
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.afnet.activeView stopAnimating];
        NSLog(@"the request getPackageInfo %@", responseObject);
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];

        if ([responseObject[@"result"] intValue] == 1) {
          dataArray = responseObject[@"content"];
          if (block) {
            block(dataArray, nil);
          }
        } else {

          [self.afnet alert:[NSString stringWithFormat:@"%@", responseObject[
                                                                  @"content"]]];
        }

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.afnet.activeView stopAnimating];
        [self.afnet
            alert:[NSString
                      stringWithFormat:@"%@", [error localizedDescription]]];
        if (block) {
          block(nil, error);
        }
      }];
}

- (void)webDeleteMovementSource:(NSString *)movement_source_id
                       withView:(UIView *)optView
                          block:(void (^)(BOOL state, NSError *error))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];
  [manager DELETE:[self.afnet delete_movement_source]
      parameters:@{
        @"movement_source_id" : movement_source_id
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"the request data is %@", responseObject);
        [self.afnet.activeView stopAnimating];
        BOOL state = FALSE;
        if ([responseObject[@"result"] intValue] == 1) {
          state = TRUE;
        } else {
          [self.afnet alert:[NSString stringWithFormat:@"%@", responseObject[
                                                                  @"content"]]];
        }
        if (block) {
          block(state, nil);
        }

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.afnet.activeView stopAnimating];
        [self.afnet
            alert:[NSString
                      stringWithFormat:@"%@", [error localizedDescription]]];
        if (block) {
          block(FALSE, error);
        }
      }];
}

- (void)webGetMovementResources:(NSString *)movement_list_id
                       withView:(UIView *)optView
                          block:(void (^)(NSMutableArray *, NSError *))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];
  [manager GET:[self.afnet getMovementResources]
      parameters:@{
        @"movement_list_id" : movement_list_id
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"the request data is %@", responseObject);
        [self.afnet.activeView stopAnimating];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];

        if ([responseObject[@"result"] intValue] == 1) {
          NSArray *tmpArray = responseObject[@"content"];
          for (int i = 0; i < [tmpArray count]; i++) {
            Movement *movement = [[Movement alloc] initWithObject:tmpArray[i]];

            [dataArray addObject:movement];
          }

        } else {

          [self.afnet alert:[NSString stringWithFormat:@"%@", responseObject[
                                                                  @"content"]]];
        }
        if (block) {
          block(dataArray, nil);
        }

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.afnet.activeView stopAnimating];
        [self.afnet
            alert:[NSString
                      stringWithFormat:@"%@", [error localizedDescription]]];
        if (block) {
          block(nil, error);
        }
      }];
}

/**
 *  删除本地 纪录
 *
 *  @param movement_list_id <#movement_list_id description#>
 *
 *  @return <#return value description#>
 */
- (void)localDeleteMovementListItemByID:(NSString *)movement_list_id {
  NSString *query;
  query = [NSString
      stringWithFormat:@"delete from movements where movement_list_id = '%@'",
                       movement_list_id];
  NSLog(@"===== query is %@", query);
  DBManager *db = [[DBManager alloc] initWithDatabaseFilename:@"wmsdb.sql"];
  [db executeQuery:query];
  //  if (db.affectedRows != 0) {
  //    NSLog(@"操作成功");
  //    return TRUE;
  //  } else {
  //    return FALSE;
  //  }
}

/**
 *  sqlite3 存储 movenment
 *
 *  @param m <#m description#>
 */
- (void)createMovement:(Movement *)m {

  NSString *query;
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString *created_at = [NSString
      stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];

  query = [NSString
      stringWithFormat:
          @"insert into movements (source_id, toWh, "
          @"toPosition, fromWh, fromPosition, packageId, partNr, "
          @"qty, movement_list_id, user, "
          @"created_at) values('%@', '%@', '%@', '%@', '%@', '%@', "
          @"'%@', '%@', '%@', " @"'%@', '%@')",
          m.SourceID, m.toWh, m.toPosition, m.fromWh, m.fromPosition,
          m.packageId, m.partNr, m.qty, m.movement_list_id, m.user, created_at];
  NSLog(@"===== query is %@", query);
  DBManager *db = [[DBManager alloc] initWithDatabaseFilename:@"wmsdb.sql"];
  [db executeQuery:query];
  if (db.affectedRows != 0) {
    NSLog(@"操作成功");
  }
}

- (void)getMovement:(NSString *)movement_list_id
           withView:(UIView *)optView
              block:(void (^)(NSMutableArray *, NSError *))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];
  [manager GET:[self.afnet GetMovement]
      parameters:@{
        @"movement_list_id" : movement_list_id
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.afnet.activeView stopAnimating];
        NSLog(@"the request getPackageInfo %@", responseObject);
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];

        if ([responseObject[@"result"] intValue] == 1) {
          NSArray *tmpArray = responseObject[@"content"];
          for (int i = 0; i < [tmpArray count]; i++) {
            Movement *movement = [[Movement alloc] init];
            movement = tmpArray[i];
            [dataArray addObject:movement];
          }

        } else {

          [self.afnet alert:[NSString stringWithFormat:@"%@", responseObject[
                                                                  @"content"]]];
        }
        if (block) {
          block(dataArray, nil);
        }

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.afnet.activeView stopAnimating];
        [self.afnet
            alert:[NSString
                      stringWithFormat:@"%@", [error localizedDescription]]];
        if (block) {
          block(nil, error);
        }
      }];
}

/**
 *  获取唯一码信息
 *
 *  @param package_id <#package_id description#>
 *  @param optView    <#optView description#>
 *  @param block      <#block description#>
 */
- (void)getPackageInfo:(NSString *)package_id
              withView:(UIView *)optView
                 block:(void (^)(NSMutableArray *, NSError *))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];
  [manager GET:[self.afnet GetPackageInfo]
      parameters:@{
        @"package_id" : package_id
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.afnet.activeView stopAnimating];
        NSLog(@"the request getPackageInfo %@", responseObject);
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];

        if ([responseObject[@"result"] intValue] == 1) {
          dataArray = responseObject[@"content"];
          if (block) {
            block(dataArray, nil);
          }
        } else {

          [self.afnet alert:[NSString stringWithFormat:@"%@", responseObject[
                                                                  @"content"]]];
        }

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.afnet.activeView stopAnimating];
        [self.afnet
            alert:[NSString
                      stringWithFormat:@"%@", [error localizedDescription]]];
        if (block) {
          block(nil, error);
        }
      }];
}

/**
 *  获取移库
 *
 *  @param movement_list_id <#movement_list_id description#>
 *  @param optView          <#optView description#>
 *  @param block            <#block description#>
 */
- (void)getMovements:(NSString *)movement_list_id
            withView:(UIView *)optView
               block:(void (^)(NSMutableArray *, NSError *))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];
  [manager DELETE:[self.afnet GetMovement]
      parameters:@{
        @"movement_list_id" : movement_list_id
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.afnet.activeView stopAnimating];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];

        if ([responseObject[@"result"] intValue] == 1) {
          NSArray *requestArray = responseObject[@"content"];
          for (int i = 0; i < [requestArray count]; i++) {
            Movement *movement = (Movement *)requestArray[i];
            [dataArray addObject:movement];
          }

          if (block) {
            block(dataArray, nil);
          }
        } else {

          [self.afnet alert:[NSString stringWithFormat:@"%@", responseObject[
                                                                  @"content"]]];
        }

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.afnet.activeView stopAnimating];
        [self.afnet
            alert:[NSString
                      stringWithFormat:@"%@", [error localizedDescription]]];
        if (block) {
          block(nil, error);
        }
      }];
}

/**
 *  删除移库单
 *
 *  @param movement_list_id <#movement_list_id description#>
 *  @param optView          <#optView description#>
 *  @param block            <#block description#>
 */
- (void)deleteMovementList:(NSString *)movement_list_id
                  withView:(id)optView
                     block:(void (^)(NSString *, NSError *))block {
  NSLog(@"delete id %@", movement_list_id);
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];
  [manager DELETE:[self.afnet DeleteMovementList]
      parameters:@{
        @"movement_list_id" : movement_list_id
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.afnet.activeView stopAnimating];
        NSString *msg =
            [NSString stringWithFormat:@"%@", responseObject[@"content"]];
        [self.afnet alert:msg];
        if (block) {
          block(msg, nil);
        }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.afnet.activeView stopAnimating];
        [self.afnet
            alert:[NSString
                      stringWithFormat:@"%@", [error localizedDescription]]];
        if (block) {
          block(@"", error);
        }
      }];
}

/**
 *  打印api
 *
 *  @param copies <#copies description#>
 *  @param block  <#block description#>
 */
- (void)printAction:(NSString *)movement_list_id
             copies:(NSString *)copies
            optView:(UIView *)optView
              block:(void (^)(NSString *, NSError *))block {
  NSLog(@"the request is %@",
        [[self.afnet print_movenment_list_receive:movement_list_id
                                     printer_name:@"P009/"
                                           copies:copies]
            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];
  [manager
      GET:[[self.afnet print_movenment_list_receive:movement_list_id
                                       printer_name:@"P009/"
                                             copies:copies]
              stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
      parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.afnet.activeView stopAnimating];
        [self.afnet alert:responseObject[@"Content"]];
        if (block) {
          block([NSString stringWithFormat:@"%@", responseObject[@"Code"]],
                nil);
        }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.afnet.activeView stopAnimating];
        [self.afnet
            alert:[NSString
                      stringWithFormat:@"%@", [error localizedDescription]]];
        if (block) {
          block([NSString stringWithFormat:@"%@", error.localizedDescription],
                nil);
        }
      }];
}

/**
 *  移库
 *
 *  @param movement_list_id <#movement_list_id description#>
 *  @param employee_id      <#employee_id description#>
 *  @param remarks          <#remarks description#>
 *  @param movements        <#movements description#>
 */
- (void)movementAction:(NSString *)movement_list_id
              employee:(NSString *)employee_id
               optview:(UIView *)optView
                 block:(void (^)(NSString *, NSError *))block {
  NSMutableArray *movementArray =
      [self queryByMovementListID:movement_list_id ObjectDictionary:1];

  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];
  [manager POST:[self.afnet SaveMovement]
      parameters:@{
        @"movement_list_id" : movement_list_id,
        @"employee_id" : employee_id,
        @"remarks" : @"",
        @"movements" : movementArray
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"the request %@", responseObject);
        [self.afnet.activeView stopAnimating];
        [self.afnet alert:responseObject[@"content"]];
        if (block) {
          block([NSString stringWithFormat:@"%@", responseObject[@"result"]],
                nil);
        }

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
          block([NSString stringWithFormat:@"%@", [error localizedDescription]],
                error);
        }
        [self.afnet.activeView stopAnimating];
        NSLog(@"%@", error.description);
        [self.afnet
            alert:[NSString
                      stringWithFormat:@"%@", [error localizedDescription]]];
      }];
}

/**
 *  按照movementid 删除本地纪录
 *
 *  @param movementID <#movementID description#>
 */
- (void)deleteAction:(NSString *)movementID {
  NSString *query;
  query =
      [NSString stringWithFormat:@"delete from movements where " @"id = '%@'",
                                 movementID];
  [self.db executeQuery:query];
}

/**
 *  根据 movement_list_id 查询 movement
 *
 *  @param mlid <#mlid description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)queryByMovementListID:(NSString *)mlid
                         ObjectDictionary:(NSInteger)type {
  NSString *query;
  query = [NSString stringWithFormat:@"select * from movements where "
                                     @"movement_list_id = '%@' order by "
                                     @"created_at desc",
                                     mlid];
  NSLog(@"query is %@", query);
  return [self getListByQuery:query ObjectDictionary:type];
}

// query base
- (NSMutableArray *)getListByQuery:(NSString *)queryString
                  ObjectDictionary:(NSInteger)type {
  NSArray *arrayData =
      [[NSArray alloc] initWithArray:[self.db loadDataFromDB:queryString]];
  NSMutableArray *dataArray = [[NSMutableArray alloc] init];
  for (int i = 0; i < [arrayData count]; i++) {

    NSString *moveMentId = [[arrayData objectAtIndex:i]
        objectAtIndex:[self.db.arrColumnNames indexOfObject:@"id"]];
    NSString *movementSourceID = [[arrayData objectAtIndex:i]
        objectAtIndex:[self.db.arrColumnNames indexOfObject:@"source_id"]];
    NSString *toWh = [[arrayData objectAtIndex:i]
        objectAtIndex:[self.db.arrColumnNames indexOfObject:@"toWh"]];

    NSString *toPosition = [[arrayData objectAtIndex:i]
        objectAtIndex:[self.db.arrColumnNames indexOfObject:@"toPosition"]];

    NSString *fromWh = [[arrayData objectAtIndex:i]
        objectAtIndex:[self.db.arrColumnNames indexOfObject:@"fromWh"]];

    NSString *fromPosition = [[arrayData objectAtIndex:i]
        objectAtIndex:[self.db.arrColumnNames indexOfObject:@"fromPosition"]];

    NSString *packageId = [[arrayData objectAtIndex:i]
        objectAtIndex:[self.db.arrColumnNames indexOfObject:@"packageId"]];

    NSString *partNr = [[arrayData objectAtIndex:i]
        objectAtIndex:[self.db.arrColumnNames indexOfObject:@"partNr"]];
    NSString *qty = [[arrayData objectAtIndex:i]
        objectAtIndex:[self.db.arrColumnNames indexOfObject:@"qty"]];

    NSString *movement_list_id = [[arrayData objectAtIndex:i]
        objectAtIndex:[self.db.arrColumnNames
                          indexOfObject:@"movement_list_id"]];

    NSString *user = [[arrayData objectAtIndex:i]
        objectAtIndex:[self.db.arrColumnNames indexOfObject:@"user"]];

    NSString *created_at = [[arrayData objectAtIndex:i]
        objectAtIndex:[self.db.arrColumnNames indexOfObject:@"created_at"]];
    if (type == 0) {
      Movement *movement = [[Movement alloc] initWithID:moveMentId
                                           withSourceID:movementSourceID
                                               withToWh:toWh
                                         withToPosition:toPosition
                                             withFromWh:fromWh
                                       withFromPosition:fromPosition
                                          withCreatedAt:created_at
                                          withPackageId:packageId
                                             withPartNr:partNr
                                                withQty:qty
                                               withUser:user
                                     withMovementListID:movement_list_id];
      NSLog(@"local movement id %@", movement.ID);
      [dataArray addObject:movement];

    } else {
      NSDictionary *dict = [[NSDictionary alloc] init];
      dict = @{
        @"toWh" : toWh,
        @"toPosition" : toPosition,
        @"fromWh" : fromWh,
        @"fromPosition" : fromPosition,
        @"packageId" : packageId,
        @"partNr" : partNr,
        @"qty" : qty
      };
      [dataArray addObject:dict];
    }
  }

  return dataArray;
}

@end
