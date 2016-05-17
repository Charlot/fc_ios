//
//  RuKuDetailTableViewCell.m
//  Material
//
//  Created by wayne on 16/5/17.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import "RuKuDetailTableViewCell.h"

@implementation RuKuDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.packageID.adjustsFontSizeToFitWidth=YES;
    self.partNr.adjustsFontSizeToFitWidth=YES;
    self.qty.adjustsFontSizeToFitWidth=YES;
    self.fifo.adjustsFontSizeToFitWidth=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
