//
//  InventoryAPI.h
//  Material
//
//  Created by ryan on 11/25/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InventoryAPI : NSObject

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
                          block:(void (^)(BOOL state, NSError *error))block;

/**
 *  删除盘点项
 *
 *  @param inventory_list_item_id
 *<#inventory_list_item_id description#>
 *  @param optView                <#optView
 *description#>
 *  @param block                  <#block
 *description#>
 */
- (void)DeleteInventoryListItem:(NSString *)inventory_list_item_id
                       withView:(UIView *)optView
                          block:(void (^)(BOOL state, NSError *error))block;

/**
 *  更新盘点项
 *
 *  @param inventory_list_item_id <#inventory_list_item_id description#>
 *  @param whouse_id              <#whouse_id description#>
 *  @param position               <#position description#>
 *  @param qty                    <#qty description#>
 *  @param part_id                <#part_id description#>
 *  @param package_id             <#package_id description#>
 *  @param optView                <#optView description#>
 *  @param block                  <#block description#>
 */
- (void)UpdateInventoryListItem:(NSString *)inventory_list_item_id
                   withWhouseID:(NSString *)whouse_id
                   withPosition:(NSString *)position
                        withQty:(NSString *)qty
                     withPartID:(NSString *)part_id
                  withPackageID:(NSString *)package_id
                       withView:(UIView *)optView
                          block:(void (^)(BOOL state, NSError *error))block;

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
                    withSize:(NSString *)size
                    withView:(UIView *)optView
                       block:(void (^)(NSMutableArray *dataArray,
                                       NSError *error))block;

- (void)getInventoryListPosition:(NSString *)inventory_list_id
                        withUser:(NSString *)user_id
                        withPage:(NSString *)page
                        withSize:(NSString *)size
                        withView:(UIView *)optView
                           block:(void (^)(NSMutableArray *dataArray,
                                           NSError *error))block;

@end
