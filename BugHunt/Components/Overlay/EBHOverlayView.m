//
//  EBHOverlayView.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/12/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHOverlayView.h"
#import "EBHScreenshotUtility.h"

static const CGFloat kOverlayResistanceDefault = 25.0;

@interface EBHOverlayView ()

// Animations
@property (nonatomic, strong) NSTimer *alphaAnimationTimer;

// Physics
@property (nonatomic, strong) UIDynamicItemBehavior *overlayBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *springBehavior;
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@end

@implementation EBHOverlayView

#pragma mark - Initialization 

- (id)init
{
    CGRect frame = CGRectMake(20, 0, 52, 52);
    frame.origin.y = [[UIScreen mainScreen] bounds].size.height - (frame.size.height + 20.0f);
    self = [self initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize_];
    }
    return self;
}

- (void)initialize_
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor redColor];
    self.layer.cornerRadius = self.frame.size.height / 2.0f;
    
    UIImageView *imageView = ({
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *imagePath = [bundle pathForResource:@"ebb_icon-bug" ofType:@"png"];
        UIImage *bugImage = [UIImage imageWithContentsOfFile:imagePath];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:bugImage];
        CGRect frame = self.frame;
        frame.origin.x = 0.0f;
        frame.origin.y = 0.0f;
        
        frame = CGRectInset(frame, 8.0f, 8.0f);
        imageView.frame = frame;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.layer.cornerRadius = imageView.frame.size.height / 2.0;
        imageView;
    });
    [self addSubview:imageView];
    
    [self setupGestureRecognizers];
}

- (void)setupGestureRecognizers
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(bugWasTapped:)];
    [self addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] init];
    [doubleTapGesture addTarget:self action:@selector(bugWasDoubleTapped:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTapGesture];
    
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] init];
    [panGesture addTarget:self action:@selector(panGestureWasRecognized:)];
    [self addGestureRecognizer:panGesture];
}

- (void)setupPhysics
{
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    
    // Collisions
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self]];
    [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    [self.dynamicAnimator addBehavior:collisionBehavior];

    // Make it springy!
    self.springBehavior = [[UIAttachmentBehavior alloc] initWithItem:self
                                                    attachedToAnchor:self.center];
    self.springBehavior.length = 1.0;
    self.springBehavior.damping = 1.6;
    self.springBehavior.frequency = 10.0;
    [self.dynamicAnimator addBehavior:self.springBehavior];
    
    // But not too springy...
    self.overlayBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    self.overlayBehavior.resistance = kOverlayResistanceDefault;
    self.overlayBehavior.elasticity = 0.5;
    [self.dynamicAnimator addBehavior:self.overlayBehavior];
}

#pragma mark - Lifecycle

- (void)didMoveToSuperview
{
    [self setupPhysics];
    [self scheduleAlphaAnimation];
}

#pragma mark - Animations

- (void)performScreenshotAnimation
{
    CATransition *shutterAnimation = [CATransition animation];
    [shutterAnimation setDuration:0.5];
    shutterAnimation.timingFunction = UIViewAnimationCurveEaseInOut;
    [shutterAnimation setType:@"cameraIris"];
    [shutterAnimation setValue:@"cameraIris" forKey:@"cameraIris"];
    
    CALayer *cameraShutterLayer = [[CALayer alloc]init];
    [self.layer addSublayer:cameraShutterLayer];
    [self.layer addAnimation:shutterAnimation forKey:@"cameraIris"];
}

- (void)clearAlphaAnimation
{
    [self.alphaAnimationTimer invalidate];
    self.alphaAnimationTimer = nil;
    
    // If needed, reset back...
    if (self.alpha < 1.0) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.alpha = 1.0;
                         }];
    }
}

- (void)scheduleAlphaAnimation
{
    self.alphaAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                target:self
                                                              selector:@selector(fadeOutOverlayView:)
                                                              userInfo:nil
                                                               repeats:NO];
}

- (void)fadeOutOverlayView:(id)sender
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0.2;
                     }
                     completion:nil];
}

#pragma mark - Actions

- (void)bugWasTapped:(id)sender
{
    if ([self.overlayDelegate respondsToSelector:@selector(overlayViewReceicedTap:)]) {
        [self.overlayDelegate overlayViewReceicedTap:self];
    }
}

- (void)bugWasDoubleTapped:(id)sender
{
    [self clearAlphaAnimation];
    [self scheduleAlphaAnimation];
    [self performScreenshotAnimation];
    
    if ([self.overlayDelegate respondsToSelector:@selector(overlayViewReceicedDoubleTap:)]) {
        [self.overlayDelegate overlayViewReceicedDoubleTap:self];
    }
}

- (void)panGestureWasRecognized:(UIPanGestureRecognizer *)panGesture
{
    [self updateOverlayAlphaUsingPanGesture:panGesture];
    [self updatePhysicsUsingPanGesture:panGesture];
    
    [panGesture setTranslation:CGPointZero inView:self]; // reset offset
}

- (void)updateOverlayAlphaUsingPanGesture:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [self clearAlphaAnimation];
    }
    else if ((panGesture.state == UIGestureRecognizerStateEnded) ||
             (panGesture.state == UIGestureRecognizerStateCancelled))
    {
        [self scheduleAlphaAnimation];
    }
}

- (void)updatePhysicsUsingPanGesture:(UIPanGestureRecognizer *)panGesture
{
    static CGPoint previousTranslation;
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        previousTranslation = [panGesture translationInView:self.superview];
        self.springBehavior.anchorPoint = [panGesture locationInView:self.superview];
    }
    else if ((panGesture.state == UIGestureRecognizerStateEnded) ||
             (panGesture.state == UIGestureRecognizerStateCancelled))
    {
        CGPoint newAnchor = self.springBehavior.anchorPoint;
        newAnchor.x += previousTranslation.x * 2;
        newAnchor.y += previousTranslation.y * 2;
        
        // This keeps the overlay jumping really fast...
        newAnchor.x = MAX(0, newAnchor.x);
        newAnchor.x = MIN(self.superview.bounds.size.width, newAnchor.x);
        newAnchor.y = MAX(0, newAnchor.y);
        newAnchor.y = MIN(self.superview.bounds.size.height, newAnchor.y);
        
        self.springBehavior.anchorPoint = newAnchor;
    }
}

@end
