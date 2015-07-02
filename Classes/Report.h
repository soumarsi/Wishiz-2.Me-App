//
//  Report.h
//  WishizMe
//
//  Created by iProsenjit9 on 16/06/15.
//  Copyright (c) 2015 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Report <NSObject>

@required

-(void)submitRep:(UIButton *)sender;
@end

@interface Report : UIView<NSURLConnectionDelegate,UITextViewDelegate>{
    
     NSMutableData *_responseData;
    
}
@property (strong, nonatomic) IBOutlet UITextView *textView;
//@property (strong, nonatomic) UIAlertView *alertMe;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) id<Report> delegate;



@end
