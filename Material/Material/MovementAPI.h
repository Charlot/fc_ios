//
//  MovementAPI.h
//  Material
//
//  Created by ryan on 11/23/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovementAPI : NSObject
- (NSMutableArray *)queryByMovementListID:(NSString *)mlid
                         ObjectDictionary:(NSInteger)type;
- (void)deleteAction:(NSString *)movementID;
- (void)movementAction:(NSString *)movement_list_id
              employee:(NSString *)employee_id
               optview:(UIView *)optView
                 block:(void (^)(NSString *content, NSError *error))block;
@end
