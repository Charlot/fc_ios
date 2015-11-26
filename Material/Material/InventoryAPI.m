//
//  InventoryAPI.m
//  Material
//
//  Created by ryan on 11/25/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import "InventoryAPI.h"
#import "DBManager.h"
#import "AFNetOperate.h"
#import "InventoryList.h"

@interface InventoryAPI ()

@property(nonatomic, strong) DBManager *db;
@property(nonatomic, strong) AFNetOperate *afnet;

@end

@implementation InventoryAPI

- (instancetype)init {
  self = [super init];
  if (self) {
    _afnet = [[AFNetOperate alloc] init];
    _db = [[DBManager alloc] initWithDatabaseFilename:@"wmsdb.sql"];
  }
  return self;
}

//- (void)getInventoryListItem:(NSString *)inventory_list_id
//                withPosition:(NSString *)postion
//                  withUserID:(NSString *)user_id
//                       block:(void(^)(Inve))
@end
