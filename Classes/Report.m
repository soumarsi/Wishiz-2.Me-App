//
//  Report.m
//  WishizMe
//
//  Created by iProsenjit9 on 16/06/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import "Report.h"
#import "AppDelegateClass/AllConstants.h"

@implementation Report
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self=[[[NSBundle mainBundle] loadNibNamed:@"ReportView" owner:self options:nil]objectAtIndex:0];        
        
    }
    return self;
}

@end
