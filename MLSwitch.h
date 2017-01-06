//
//  MLSwitch.h
//  Spinney.io
//
//  Created by Marek Lipert on 23.02.2014
//

#import <UIKit/UIKit.h>

/** Reimplementation of UISwitch using custom images for background and slider
    Just initialize, set background image and on/off image (can be the same).
    Switch's frame is set to background size and the movable button is set to on/off image shifted by switchOffset (shift is given with respect to off position)
 
    The only event voluntarly produced by this control is "Value Change" event */

@interface MLSwitch : UIControl

@property(strong,nonatomic) UIImage *backgroundImage;
@property(strong,nonatomic) UIImage *offImage;
@property(strong,nonatomic) UIImage *onImage;
@property(assign,nonatomic) CGPoint switchOffset;

@property(assign,nonatomic) bool on;

- (void)setOn:(bool)newOn animated:(bool)animated;

/// Returns pan recognizer to be analyzed by upper delegate for simultaneous detection
@property(strong,readonly) UIGestureRecognizer *panGesture;

@end
