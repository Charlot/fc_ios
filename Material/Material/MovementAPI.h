//
//  MovementAPI.h
//  Material
//
//  Created by ryan on 11/23/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovementAPI : NSObject
- (NSMutableArray *)queryByMovementListID:(NSString *)mlid;
- (void)deleteAction:(NSString *)movementID;
@end
