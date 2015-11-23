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

@interface MovementAPI ()
@property(nonatomic, strong) DBManager *db;

@end

@implementation MovementAPI

- (instancetype)init {
  self = [super init];
  if (self) {
    //        _afnet = [[AFNetHelper alloc] init];
    _db = [[DBManager alloc] initWithDatabaseFilename:@"wmsdb.sql"];
  }
  return self;
}

- (NSMutableArray *)queryByMovementListID:(NSString *)mlid {
  NSString *query;
  query = [NSString stringWithFormat:@"select * from movements where "
                                     @"movement_list_id = '%@' order by "
                                     @"created_at desc",
                                     mlid];
  NSLog(@"query is %@", query);
  return [self getListByQuery:query];
}

// query base
- (NSMutableArray *)getListByQuery:(NSString *)queryString {
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

    [dataArray addObject:movement];
  }

  return dataArray;
}

@end
