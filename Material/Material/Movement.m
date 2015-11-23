//
//  Movement.m
//  Material
//
//  Created by ryan on 11/21/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "Movement.h"
#import "DBManager.h"

@interface Movement ()

@property(nonatomic, retain) DBManager *db;
@property(nonatomic) int recordIDToEdit;

@end

@implementation Movement
- (instancetype)init {
  self = [super init];

  return self;
}

- (instancetype)initWithObject:(NSDictionary *)dictionary {
  self = [super init];
  if (self) {
    self.ID = dictionary[@"id"] ? dictionary[@"id"] : @"";
    self.toWh = dictionary[@"toWh"] ? dictionary[@"toWh"] : @"";
    self.toPosition =
        dictionary[@"toPosition"] ? dictionary[@"toPosition"] : @"";
    self.fromWh = dictionary[@"fromWh"] ? dictionary[@"fromWh"] : @"";
    self.fromPosition =
        dictionary[@"fromPosition"] ? dictionary[@"fromPosition"] : @"";
    self.packageId = dictionary[@"packageId"] ? dictionary[@"packageId"] : @"";
    self.partNr = dictionary[@"partNr"] ? dictionary[@"partNr"] : @"";
    self.qty = dictionary[@"qty"] ? dictionary[@"qty"] : @"";
    self.user = dictionary[@"user"] ? dictionary[@"user"] : @"";
    self.movement_list_id = dictionary[@"movement_list_id"]
                                ? dictionary[@"movement_list_id"]
                                : @"";
    self.created_at =
        dictionary[@"created_at"] ? dictionary[@"created_at"] : @"";
  }
  return self;
}

- (instancetype)initWithID:(NSString *)movementID
                  withToWh:(NSString *)toWh
            withToPosition:(NSString *)toPosition
                withFromWh:(NSString *)fromWh
          withFromPosition:(NSString *)fromPosition
             withCreatedAt:(NSString *)created_at
             withPackageId:(NSString *)pacaageId
                withPartNr:(NSString *)partNr
                   withQty:(NSString *)qty
                  withUser:(NSString *)user
        withMovementListID:(NSString *)movement_list_id {
  self = [super init];
  if (self) {
    self.ID = movementID;
    self.toWh = toWh;
    self.toPosition = toPosition;
    self.fromWh = fromWh;
    self.fromPosition = fromPosition;
    self.created_at = created_at;
    self.packageId = pacaageId;
    self.partNr = partNr;
    self.qty = qty;
    self.user = user;
    self.movement_list_id = movement_list_id;
  }
  return self;
}

/**
 *  sqlite3 存储 movenment
 *
 *  @param m <#m description#>
 */
//- (void)createMovement:(Movement *)m {
//
//  NSString *query;
//  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//  NSString *created_at = [NSString
//      stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
//
//  query = [NSString
//      stringWithFormat:
//          @"insert into movenments (toWh, "
//          @"toPosition, fromWh, fromPosition, packageId, partNr, "
//          @"qty, movement_list_id, user, "
//          @"created_at) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@',
//          "
//          @"'%@', '%@')",
//          m.toWh, m.toPosition, m.fromWh, m.fromPosition, m.packageId,
//          m.partNr,
//          m.qty, m.movement_list_id, m.user, created_at];
//  NSLog(@"===== query is %@", query);
//  [self.db executeQuery:query];
//  if (self.db.affectedRows != 0) {
//    //            NSLog(@"======== success =========");
//    NSString *msgString = @"操作成功";
//  }
//}

@end
