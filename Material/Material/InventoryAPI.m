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
#import "InventoryListItem.h"
#define kPageSzieKey @"100"
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

/**
 *  创建盘点项
 *
 *  @param inventory_list_id <#inventory_list_id description#>
 *  @param position          <#position description#>
 *  @param user_id           <#user_id description#>
 *  @param qty               <#qty description#>
 *  @param part_id           <#part_id description#>
 *  @param package_id        <#package_id description#>
 *  @param optView           <#optView description#>
 *  @param block             <#block description#>
 */
- (void)CreateInventoryListItem:(NSString *)inventory_list_id
                   withPosition:(NSString *)position
                       withUser:(NSString *)user_id
                        withQty:(NSString *)qty
                     withPartID:(NSString *)part_id
                  withPackageID:(NSString *)package_id
                       withView:(UIView *)optView
                          block:(void (^)(BOOL, NSError *))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];

  [manager POST:[self.afnet CreateInventoryListItem]
      parameters:@{
        @"inventory_list_id" : inventory_list_id,
        @"position" : position,
        @"user_id" : user_id,
        @"position" : position,
        @"qty" : qty,
        @"part_id" : part_id,
        @"package_id" : package_id

      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"the request is %@", responseObject);
        [self.afnet.activeView stopAnimating];
        BOOL state = false;
        if ([responseObject[@"result"] intValue] == 1) {
          state = true;
          [self.afnet alert:[NSString stringWithFormat:@"%@", responseObject[
                                                                  @"content"]]];
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

/**
 *  删除盘点项
 *
 *  @param inventory_list_item_id <#inventory_list_item_id description#>
 *  @param optView                <#optView description#>
 *  @param block                  <#block description#>
 */
- (void)DeleteInventoryListItem:(NSString *)inventory_list_item_id
                       withView:(UIView *)optView
                          block:(void (^)(BOOL, NSError *))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];

  [manager DELETE:[self.afnet DeleteInventoryListItems]
      parameters:@{
        @"inventory_list_item_id" : inventory_list_item_id
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.afnet.activeView stopAnimating];
        BOOL state = false;
        if ([responseObject[@"result"] intValue] == 1) {
          state = true;
          [self.afnet alert:[NSString stringWithFormat:@"%@", responseObject[
                                                                  @"content"]]];
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

/**
 *  更新盘点项
 *
 *  @param inventory_list_item_id
 *<#inventory_list_item_id description#>
 *  @param whouse_id              <#whouse_id
 *description#>
 *  @param position               <#position
 *description#>
 *  @param qty                    <#qty
 *description#>
 *  @param part_id                <#part_id
 *description#>
 *  @param package_id             <#package_id
 *description#>
 *  @param optView                <#optView
 *description#>
 *  @param block                  <#block
 *description#>
 */
- (void)UpdateInventoryListItem:(NSString *)inventory_list_item_id
                   withWhouseID:(NSString *)whouse_id
                   withPosition:(NSString *)position
                        withQty:(NSString *)qty
                     withPartID:(NSString *)part_id
                  withPackageID:(NSString *)package_id
                       withView:(UIView *)optView
                          block:(void (^)(BOOL, NSError *))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];

  [manager POST:[self.afnet UpdateInventoryListItems]
      parameters:@{
        @"inventory_list_item_id" : inventory_list_item_id,
        @"whouse_id" : whouse_id,
        @"position" : position,
        @"qty" : qty,
        @"part_id" : part_id,
        @"package_id" : package_id

      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.afnet.activeView stopAnimating];
        BOOL state = false;
        if ([responseObject[@"result"] intValue] == 1) {
          state = true;
          [self.afnet alert:[NSString stringWithFormat:@"%@", responseObject[
                                                                  @"content"]]];
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

/**
 *  根据盘点清单 获取库位
 *
 *  @param inventory_list_id <#inventory_list_id
 *description#>
 *  @param user_id           <#user_id
 *description#>
 *  @param page              <#page
 *description#>
 *  @param size              <#size
 *description#>
 *  @param optView           <#optView
 *description#>
 *  @param block             <#block
 *description#>
 */
- (void)getInventoryListPosition:(NSString *)inventory_list_id
                        withUser:(NSString *)user_id
                        withPage:(NSString *)page

                        withView:(UIView *)optView
                           block:(void (^)(NSMutableArray *, NSError *))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];

  [manager GET:[self.afnet InventoryListPosition]
      parameters:@{
        @"inventory_list_id" : inventory_list_id,
        @"user_id" : user_id,
        @"page" : page,
        @"size" : kPageSzieKey

      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.afnet.activeView stopAnimating];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];

        if ([responseObject[@"result"] intValue] == 1) {
          NSArray *requestArray = responseObject[@"content"];
          for (int i = 0; i < [requestArray count]; i++) {
            InventoryList *il =
                [[InventoryList alloc] initWithObject:requestArray[i]];
            [dataArray addObject:il];
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
 *  根据盘点清单 和库位 搜索历史纪录

 *
 *  @param inventory_list_id <#inventory_list_id description#>
 *  @param position          <#position description#>
 *  @param user_id           <#user_id description#>
 *  @param page              <#page description#>
 *  @param size              <#size description#>
 *  @param optView           <#optView description#>
 *  @param block             <#block description#>
 */
- (void)getInventoryListByPosition:(NSString *)inventory_list_id
                      withPosition:(NSString *)position
                          withUser:(NSString *)user_id
                          withView:(UIView *)optView
                             block:
                                 (void (^)(NSMutableArray *, NSError *))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];

  [manager GET:[self.afnet InventoryListPosition]
      parameters:@{
        @"inventory_list_id" : inventory_list_id,
        @"position" : position,
        @"user_id" : user_id,

      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self.afnet.activeView stopAnimating];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];

        if ([responseObject[@"result"] intValue] == 1) {
          NSArray *requestArray = responseObject[@"content"];
          for (int i = 0; i < [requestArray count]; i++) {
            InventoryList *il =
                [[InventoryList alloc] initWithObject:requestArray[i]];
            [dataArray addObject:il];
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
 *  根据库位查询 盘点项
 *
 *  @param inventory_list_id <#inventory_list_id description#>
 *  @param position          <#position description#>
 *  @param user_id           <#user_id description#>
 *  @param page              <#page description#>
 *  @param size              <#size description#>
 *  @param optView           <#optView description#>
 *  @param block             <#block description#>
 */
- (void)getInventoryListItem:(NSString *)inventory_list_id
                withPosition:(NSString *)position
                    withUser:(NSString *)user_id
                    withPage:(NSString *)page

                    withView:(UIView *)optView
                       block:(void (^)(NSMutableArray *, NSError *))block {
  AFHTTPRequestOperationManager *manager = [self.afnet generateManager:optView];

  [manager GET:[self.afnet InventoryListConditionItem]
      parameters:@{
        @"inventory_list_id" : inventory_list_id,
        @"position" : position,
        @"user_id" : user_id

      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.afnet.activeView stopAnimating];
        NSLog(@"the request INVENTORY LIST POSITION %@,%@", position,
              responseObject);
        //
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];

        if ([responseObject[@"result"] intValue] == 1) {
          NSArray *requestArray = responseObject[@"content"];
          for (int i = 0; i < [requestArray count]; i++) {
            InventoryListItem *inventory_list_item =
                [[InventoryListItem alloc] initWithObject:requestArray[i]];
            [dataArray addObject:inventory_list_item];
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
@end
