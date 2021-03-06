//
//  AZNotificationView.m
//  Helping
//
//  Created by Mohammad Azam on 3/27/14.
//  Copyright (c) 2014 AzamSharp Consulting LLC. All rights reserved.
//

#import "AZNotificationView.h"

NSString *const SUCCESS_COLOR = @"17BF30";
NSString *const ERROR_COLOR = @"BF1525";
NSString *const WARNING_COLOR = @"BF3E12";
NSString *const MESSAGE_COLOR = @"7F7978";

@implementation AZNotificationView

-(instancetype) initWithTitle:(NSString *)title referenceView:(UIView *)referenceView notificationType:(AZNotificationType)notificationType
{
    self = [super init];
    _title = title;
    _referenceView = referenceView;
    _notificationType = notificationType;
    
    [self setup];
    return self;
}

-(void) applyDynamics
{
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_referenceView];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[self]];
    _collision = [[UICollisionBehavior alloc] initWithItems:@[self]];
    _itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    
    _itemBehavior.elasticity = 0.5f;
    
    [_collision addBoundaryWithIdentifier:@"AZNotificationBoundary" fromPoint:CGPointMake(0, self.bounds.size.height) toPoint:CGPointMake(_referenceView.bounds.size.width, self.bounds.size.height)];
    
    [_animator addBehavior:_gravity];
    [_animator addBehavior:_collision];
    [_animator addBehavior:_itemBehavior];
    
    [self performSelector:@selector(hideNotification) withObject:nil afterDelay:2.0f];
}

-(void) hideNotification
{
    // remove the original gravity behavior
    [_animator removeBehavior:_gravity];
    
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[self]];
    [_gravity setGravityDirection:CGVectorMake(0, -1)];
    
    [_animator addBehavior:_gravity];
}

-(void) setupNotificationType
{
    if(_notificationType == AZNotificationTypeSuccess)
    {
        self.backgroundColor = [UIColor colorFromHexString:SUCCESS_COLOR];
    }
    else if(_notificationType == AZNotificationTypeError)
    {
        self.backgroundColor = [UIColor colorFromHexString:ERROR_COLOR];
    }
    else if(_notificationType == AZNotificationTypeWarning)
    {
        self.backgroundColor = [UIColor colorFromHexString:WARNING_COLOR];
    }
    else {
        self.backgroundColor = [UIColor colorFromHexString:MESSAGE_COLOR];
    }
}

-(void) setup
{
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.frame = CGRectMake(0, (-1) * NOTIFICATION_VIEW_HEIGHT, screenBounds.size.width, NOTIFICATION_VIEW_HEIGHT);
    
    [self setupNotificationType];
    
    // create the labels
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screenBounds.size.width, NOTIFICATION_VIEW_HEIGHT)];
    titleLabel.text = _title;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Ligth" size:17];
    titleLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:titleLabel];
}

@end
