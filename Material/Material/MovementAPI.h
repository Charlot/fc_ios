//
//  MovementAPI.h
//  Material
//
//  Created by ryan on 11/23/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movement.h"

@interface MovementAPI : NSObject

- (BOOL)localDeleteMovementListItemByID:(NSString *)movement_list_id;

/**
 *  sqlite3 存储 movenment
 *
 *  @param m <#m description#>
 */
- (void)createMovement:(Movement *)m;

/**
 *  获取移库单 子项
 *
 *  @param movement_list_id <#movement_list_id description#>
 *  @param optView          <#optView description#>
 *  @param block            <#block description#>
 */
- (void)getMovement:(NSString *)movement_list_id
           withView:(UIView *)optView
              block:
                  (void (^)(NSMutableArray *reqeustData, NSError *error))block;

- (NSMutableArray *)queryByMovementListID:(NSString *)mlid
                         ObjectDictionary:(NSInteger)type;
/**
 *  获取唯一码信息
 *
 *  @param package_id <#package_id description#>
 *  @param optView    <#optView description#>
 *  @param block      <#block description#>
 */
- (void)getPackageInfo:(NSString *)package_id
              withView:(UIView *)optView
                 block:
                     (void (^)(NSMutableArray *dataArray, NSError *error))block;
- (void)deleteAction:(NSString *)movementID;
- (void)movementAction:(NSString *)movement_list_id
              employee:(NSString *)employee_id
               optview:(UIView *)optView
                 block:(void (^)(NSString *content, NSError *error))block;
- (void)printAction:(NSString *)movement_list_id
             copies:(NSString *)copies
            optView:(UIView *)optView
              block:(void (^)(NSString *content, NSError *error))block;
- (void)deleteMovementList:(NSString *)movement_list_id
                  withView:(UIView *)optView
                     block:(void (^)(NSString *contentString,
                                     NSError *error))block;
@end
