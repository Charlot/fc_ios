//
//  XiangDetailTableViewCell.m
//  Material
//
//  Created by wayne on 16/4/20.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "XiangDetailTableViewCell.h"

@implementation XiangDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.key.adjustsFontSizeToFitWidth=YES;
    self.partNr.adjustsFontSizeToFitWidth=YES;
    self.quantity.adjustsFontSizeToFitWidth=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
