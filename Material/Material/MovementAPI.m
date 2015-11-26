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
 *  根据唯一码查询
 *
 *  @param package_id <#package_id description#>
 *  @param optView    <#optView description#>
 *  @param block      <#block description#>
 */
- (void)getPackageInfo:(NSString *)package_id
              withView:(UIView *)optView
                 block:(void (^)(NSArray *, NSError *))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];
  [manager DELETE:[self.afnet GetPackageInfo]
      parameters:@{
        @"package_id" : package_id
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.afnet.activeView stopAnimating];
        NSArray *dataArray = [[NSArray alloc] init];

        if ([responseObject[@"result"] intValue] == 1) {
          if (block) {
            dataArray = responseObject[@"content"];
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
            [NSString stringWithFormat:@"%@", responseObject[@"Content"]];
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
