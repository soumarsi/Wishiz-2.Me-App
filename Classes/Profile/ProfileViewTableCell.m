//
//  ProfileViewTableCell.m
//  WishizMe
//
//  Created by David Krasicki on 12/5/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "ProfileViewTableCell.h"

@implementation ProfileViewTableCell
@synthesize lblNameAndAge = _lblNameAndAge;
@synthesize lblCityAndState = _lblCityAndState;
@synthesize scrImage = _scrImage;
@synthesize pcImage = _pcImage;
@synthesize txtAbout = _txtAbout;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setScroll
{
    int x=0;
    int i = 0;
    
    self.scrImage.clipsToBounds = YES;
    for (id key in arrImages)
    {        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0, self.scrImage.frame.size.width, self.scrImage.frame.size.height)];
        
        NSString *url = [arrImages objectForKey:key];
        
        [img downloadFromURL:url withPlaceholder:nil];
        img.tag=1000+i;
        
        img.clipsToBounds = YES;
        [img setContentMode:UIViewContentModeScaleAspectFill];
        [self.scrImage addSubview:img];
        x+=self.scrImage.frame.size.width;
        i++;
    }
    [self.scrImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.scrImage setContentSize:CGSizeMake(x, self.scrImage.frame.size.height)];
    self.scrImage.clipsToBounds=YES;
    self.pcImage.clipsToBounds = YES;
    [self.pcImage setNumberOfPages:[arrImages count]];
    [self.pcImage setCurrentPage:currentPage];
    [self.pcImage setContentMode:UIViewContentModeScaleAspectFill];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}

#pragma mark -
#pragma mark - UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)sender{
    CGFloat pageWidth = self.scrImage.frame.size.width;
    currentPage = floor((self.scrImage.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pcImage.currentPage = currentPage;
}


- (IBAction)changePage
{
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrImage.frame.size.width * self.pcImage.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrImage.frame.size;
    [self.scrImage scrollRectToVisible:frame animated:YES];
}

-(void)getUserProfile:(NSString *)profile_id
{
    currentPage=1;
    [self.pcImage setCurrentPage:currentPage];
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:profile_id forKey:PARAM_ENT_USER_PROFILE_ID];
    
    AFNHelper *afn=[[AFNHelper alloc]init];
    [afn getDataFromPath:METHOD_GETPROFILE withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if (response)
         {
             if ([[response objectForKey:@"errFlag"] intValue]==0)
             {
                 AFNHelper *afn=[[AFNHelper alloc]init];
                 [afn getDataFromPath:METHOD_GETPROFILE_PHOTOS withParamData:dictParam withBlock:^(id responsephoto, NSError *error)
                  {
                      if ([[responsephoto objectForKey:@"errFlag"] intValue]==0)
                      {
                          NSString *profilePhotoValue =[responsephoto objectForKey:[response objectForKey:@"photo_id"] ];
                          NSString *profilePhotoId = [response objectForKey:@"photo_id" ];

                          NSMutableDictionary *profilePhoto = [[NSMutableDictionary alloc] init];
                          [profilePhoto setValue: profilePhotoValue forKey: profilePhotoId];

                          NSMutableDictionary *newPhotoArray = [[NSMutableDictionary alloc] init];
                          
                          [newPhotoArray addEntriesFromDictionary:profilePhoto];
                          
                          for(id key in responsephoto)
                          {
                              if(![key isEqualToString:profilePhotoId])
                              {
                                  NSMutableDictionary *profilePhototemp = [[NSMutableDictionary alloc] init];
                                  [profilePhototemp setValue: [responsephoto objectForKey:key] forKey: key];
                                  
                                  [newPhotoArray addEntriesFromDictionary:profilePhototemp];
                              }
                          }

                          arrImages = newPhotoArray;

                          [self setScroll];
                      }
                      
                  }];
                 
                 
                 if ([response objectForKey:@"birthdate"]!=nil)
                 {
                     NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
                     [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                     NSDate * birthday = [dateFormatter dateFromString:[response objectForKey:@"birthdate"]];
                     
                     NSDate* now = [NSDate date];
                     NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                        components:NSCalendarUnitYear
                                                        fromDate:birthday
                                                        toDate:now
                                                        options:0];
                     NSInteger age = [ageComponents year];
                     NSString *userAge = [@(age) stringValue];
                     
                     NSArray*splitname = [[response objectForKey:@"real_name"] componentsSeparatedByString:@" "];
                     NSString *firstname = [splitname objectAtIndex:0];
                     
                     self.lblNameAndAge.text=[NSString stringWithFormat:@"%@, %@",firstname,userAge];
                     
                 }
                 else
                 {
                     NSArray*splitname = [[response objectForKey:@"real_name"] componentsSeparatedByString:@" "];
                     NSString *firstname = [splitname objectAtIndex:0];
                     
                     self.lblNameAndAge.text = firstname;
    
                     
                 }
                 
                 
                 if ([[response objectForKey:@"general_description"] isEqual:[NSNull null]] || [response objectForKey:@"general_description"]==nil || [[response objectForKey:@"general_description"]isEqualToString:@""])
                 {
                     self.txtAbout.text = [NSString stringWithFormat:@"%@%@%@",@"Help make ",[response objectForKey:@"real_name"], @"'s Wishiz come true! See what the power of giving can do for you."];
                 }
                 else{
                     self.txtAbout.text = [response objectForKey:@"general_description"];
                 }
                 
                 if ([[response objectForKey:@"city"] isEqual:[NSNull null]] || [response objectForKey:@"city"]==nil || [[response objectForKey:@"city"]isEqualToString:@""])
                 {
                 }
                 else{
                     self.lblCityAndState.text=[NSString stringWithFormat:@"%@, %@",[response objectForKey:@"city"],[response objectForKey:@"state"]];
                 }

             }
         }
     }];
}

@end
