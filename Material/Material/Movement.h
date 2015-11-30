//
//  Movement.h
//  Material
//
//  Created by ryan on 11/21/15.
//  Copyright © 2015 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movement : NSObject
@property(nonatomic, strong) NSString *ID;
@property(nonatomic, strong) NSString *SourceID;
@property(nonatomic, strong) NSString *toWh;
@property(nonatomic, strong) NSString *toPosition;
@property(nonatomic, strong) NSString *fromWh;
@property(nonatomic, strong) NSString *fromPosition;
@property(nonatomic, strong) NSString *created_at;
@property(nonatomic, strong) NSString *packageId;
@property(nonatomic, strong) NSString *partNr;
@property(nonatomic, strong) NSString *qty;
@property(nonatomic, strong) NSString *user;
@property(nonatomic, strong) NSString *movement_list_id;
- (instancetype)initWithObject:(NSDictionary *)dictionary;
- (instancetype)initWithID:(NSString *)movementID
              withSourceID:(NSString *)sourceID
                  withToWh:(NSString *)toWh
            withToPosition:(NSString *)toPosition
                withFromWh:(NSString *)fromWh
          withFromPosition:(NSString *)fromPosition
             withCreatedAt:(NSString *)created_at
             withPackageId:(NSString *)pacaageId
                withPartNr:(NSString *)partNr
                   withQty:(NSString *)qty
                  withUser:(NSString *)user
        withMovementListID:(NSString *)movement_list_id;
//- (void)createMovement:(Movement *)m;

@end
