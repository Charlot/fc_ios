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

- (void)printAction:(

    /**
     *  移库
     *
     *  @param movement_list_id <#movement_list_id description#>
     *  @param employee_id      <#employee_id description#>
     *  @param remarks          <#remarks description#>
     *  @param movements        <#movements description#>
     */
    -
    (void)movementAction:(NSString *)movement_list_id
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
