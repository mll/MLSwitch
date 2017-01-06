//
//  MLSwitch.m
//  Spinney.io
//
//  Created by Marek Lipert on 23.02.2014
//

#import "MLSwitch.h"
@interface MLSwitch()

@property(strong,nonatomic) UIImageView *bgView;
@property(strong,nonatomic) UIImageView *sliderImage;
@property(assign,nonatomic) NSInteger panState;
@property(assign,nonatomic) CGRect sliderPanFrame;

- (void) initSlider;
- (void) moveSliderAnimated: (bool)animated completion: (void (^)(BOOL success)) successBlock;

@end

@implementation MLSwitch

#pragma mark - Initialization and gesture recognizers

- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *) bgImage {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:bgImage];
        [self initSlider];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSlider];
    }
    return self;
}

- (void) initSlider {
    self.bgView = [[UIImageView alloc] init];
    self.sliderImage = [[UIImageView alloc] init];
    
    [self addSubview:self.bgView];
    [self addSubview:self.sliderImage];
    
    [self bringSubviewToFront:self.sliderImage];

    self.switchOffset = CGPointZero;
    
    /* tap gesture for toggling the switch */
    
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tappedAction:)];
    _on = NO;
	[self addGestureRecognizer:tapGestureRecognizer];
    
    /* pan gesture for moving the switch manually */
    
    self.panState = UIGestureRecognizerStatePossible;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedAction:)];
    
    panGestureRecognizer.maximumNumberOfTouches = 1;
    panGestureRecognizer.minimumNumberOfTouches = 1;
    _panGesture = panGestureRecognizer;
    
	[self addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - Actions

- (void) tappedAction: (UIGestureRecognizer *) recognizer {
    [self setOn:!self.on animated:YES];
}

- (void) pannedAction: (UIPanGestureRecognizer *) recognizer
{
    CGPoint translation;
    CGPoint xMin = CGPointMake(self.switchOffset.x, 0.0);
    CGPoint xMax = CGPointMake(self.frame.size.width - self.switchOffset.x - self.sliderImage.frame.size.width, 0.0);
    CGPoint xMiddle = CGPointMake((xMin.x + xMax.x)/2.0, 0.0);
    CGAffineTransform trafo;

    switch(recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            self.panState = UIGestureRecognizerStateBegan; /* start recognition */
            self.sliderPanFrame = self.sliderImage.frame;
            break;
            
        case UIGestureRecognizerStateEnded:
            if(self.panState==UIGestureRecognizerStateBegan) {
                self.panState = UIGestureRecognizerStatePossible;
                
                if(self.on) {
                    if(self.sliderImage.frame.origin.x < xMiddle.x) [self setOn:NO animated:YES];
                    else [UIView animateWithDuration:0.1 animations:^{ self.sliderImage.frame = self.sliderPanFrame; }];
                    return;
                }
             
                if(self.sliderImage.frame.origin.x > xMiddle.x) [self setOn:YES animated:YES];
                else [UIView animateWithDuration:0.1 animations:^{self.sliderImage.frame = self.sliderPanFrame;  }];
            }
            break;
            
        case UIGestureRecognizerStateCancelled:
            self.panState = UIGestureRecognizerStatePossible;
            break;
            
        case UIGestureRecognizerStateChanged:
            if(self.panState==UIGestureRecognizerStateBegan) {
                translation = [recognizer translationInView:self];
                if(translation.x+self.sliderPanFrame.origin.x < xMin.x) translation.x = -self.sliderPanFrame.origin.x+xMin.x;
                if(translation.x+self.sliderPanFrame.origin.x > xMax.x) translation.x = -self.sliderPanFrame.origin.x+xMax.x;
                trafo = CGAffineTransformMakeTranslation(translation.x, 0.0);
                self.sliderImage.frame = CGRectApplyAffineTransform(self.sliderPanFrame, trafo);
            }
            break;
            
        case UIGestureRecognizerStateFailed:
            self.panState = UIGestureRecognizerStatePossible;
            break;
            
        default:
            NSLog(@"Pan gesture recognizer unknown state %d",recognizer.state);
            self.panState = UIGestureRecognizerStatePossible;
    }
    
}

#pragma mark - Setters

- (void)setSwitchOffset:(CGPoint)switchOffset {
    _switchOffset = switchOffset;
    [self setNeedsLayout];
}

- (void) setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self setNeedsLayout];
}

- (void)setOffImage:(UIImage *)offImage {
    _offImage = offImage;
    [self setNeedsLayout];
}

- (void)setOnImage:(UIImage *)onImage {
    _onImage = onImage;
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    self.bgView.image = self.backgroundImage;
    [self.bgView sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bgView.frame.size.width, self.bgView.frame.size.height);

    if(!_on) {
      self.sliderImage.image = self.offImage;
      [self.sliderImage sizeToFit];
      self.sliderImage.frame = CGRectMake(self.switchOffset.x,self.switchOffset.y,self.sliderImage.frame.size.width,self.sliderImage.frame.size.height);
    } else {
        self.sliderImage.image = self.onImage;
        [self.sliderImage sizeToFit];
        CGFloat dx = self.frame.size.width-self.sliderImage.bounds.size.width-2.0*self.switchOffset.x;
        self.sliderImage.frame = CGRectMake(self.switchOffset.x+ dx,self.switchOffset.y,self.sliderImage.frame.size.width,self.sliderImage.frame.size.height);
    }
     self.sliderPanFrame = self.sliderImage.frame;
    
     [super layoutSubviews];
}

- (void) moveSliderAnimated: (bool)animated completion: (void (^)(BOOL success)) successBlock {
    CGAffineTransform trafo = CGAffineTransformMakeRotation(0.0);
    CGFloat dx;
    self.enabled = NO; /* success block has to re-enable this and set on to appropirate value + post notification */
    
    if(!self.on) {
        self.sliderImage.image = self.onImage;
        [self.sliderImage sizeToFit];
        dx = self.bounds.size.width - self.sliderImage.bounds.size.width - 2.0*self.switchOffset.x;
        dx = dx - self.sliderImage.frame.origin.x + self.switchOffset.x; /* pan adjustment */
        trafo = CGAffineTransformMakeTranslation(dx,0.0);
    } else {
        self.sliderImage.image = self.offImage;
        [self.sliderImage sizeToFit];
        dx = self.bounds.size.width - self.sliderImage.bounds.size.width - 2.0*self.switchOffset.x;
        dx = -dx - (self.sliderImage.frame.origin.x - self.switchOffset.x - dx); /* pan adjustment */
        trafo = CGAffineTransformMakeTranslation(dx, 0.0);
    }
    
    void (^change)()  = ^{
        self.sliderImage.frame = CGRectApplyAffineTransform(self.sliderImage.frame, trafo);
        self.sliderPanFrame = self.sliderImage.frame;
        self.panState = UIGestureRecognizerStatePossible;
    };
    
    if(animated) [UIView animateWithDuration:0.3 animations: change completion:successBlock];
    else {
        change();
        successBlock(YES);
    }
}

- (void)setOn:(bool)newOn {
	[self setOn:newOn animated:NO];
}

- (void)setOn:(bool)newOn animated:(bool)animated {
    if(self.on !=newOn)
        [self moveSliderAnimated:animated completion:^(BOOL success)
        {
            self.enabled = YES;
            _on = !self.on;
          [self sendActionsForControlEvents:UIControlEventValueChanged];
        }];
}

@end
