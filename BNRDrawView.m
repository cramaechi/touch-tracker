//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by Chibuikem Amaechi on 7/30/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView () <UIGestureRecognizerDelegate>

@property (nonatomic) UIPanGestureRecognizer *moveRecognizer;
@property (nonatomic) UISwipeGestureRecognizer *twoFingerSwipeUpRecognizer;
@property (nonatomic) UISwipeGestureRecognizer *twoFingerSwipeDownRecognizer;
@property (nonatomic) NSMutableDictionary *linesInProgress;
@property (nonatomic) NSMutableArray *finishedLines;

@property (nonatomic, weak) BNRLine *selectedLine;

@end

@implementation BNRDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.currentLineColor = [UIColor redColor];
        self.multipleTouchEnabled = YES;
        
        // Intercepts touch events bound for the view and determines
        // whether the touche(s) constitute its gesture.
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        //doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(tap:)];
        //tapRecognizer.delaysTouchesBegan = YES;
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
        [self addGestureRecognizer:pressRecognizer];
        
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
        
        self.twoFingerSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(showColorPanel:)];
        self.twoFingerSwipeUpRecognizer.delaysTouchesBegan = YES;
        self.twoFingerSwipeUpRecognizer.numberOfTouchesRequired = 2;
        self.twoFingerSwipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:self.twoFingerSwipeUpRecognizer];
        
        self.twoFingerSwipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(hideColorPanel:)];
        self.twoFingerSwipeDownRecognizer.delaysTouchesBegan = YES;
        self.twoFingerSwipeDownRecognizer.numberOfTouchesRequired = 2;
        self.twoFingerSwipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:self.twoFingerSwipeDownRecognizer];

    }
    
    return self;
}

- (void)strokeLine:(BNRLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    
    CGPoint v = [self.moveRecognizer velocityInView:self];
    
    bp.lineWidth = (![self.finishedLines containsObject:line]) ? sqrtf((v.x * v.x) + (v.y * v.y)) : 10.0;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect
{
    //CGPoint v = [self.moveRecognizer velocityInView:self];
    //NSLog(@"Panning at %@ pps", NSStringFromCGPoint(v));
    
    // Draw finished lines in black
    for (BNRLine *line in self.finishedLines)
    {
        [line.color set];
        [self strokeLine:line];
    }
    
    // Make the color of the line currently being drawn red
    [self.currentLineColor set];
    for (NSValue *key in self.linesInProgress)
        [self strokeLine:self.linesInProgress[key]];
    
    if (self.selectedLine)
    {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
    }
}

// A finger or fingers touches the screen
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    NSLog(@"Panning at %@ pps", NSStringFromCGPoint([self.moveRecognizer velocityInView:self]));
    
    for (UITouch *t in touches)
    {
        CGPoint location = [t locationInView:self];
        
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        self.linesInProgress[key] = line;
    }
    // Mark this view as needing to be redrawn on the next run-loop cycle
    [self setNeedsDisplay];
}

// A finger or fingers moves across the screen
// (This message is sent repeatedly as finger moves)
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    NSLog(@"Panning at %@ pps", NSStringFromCGPoint([self.moveRecognizer velocityInView:self]));
    
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        
        line.end = [t locationInView:self];
    }
    [self setNeedsDisplay];
}

// A finger or fingers is removed from the screen
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    NSLog(@"Panning at %@ pps", NSStringFromCGPoint([self.moveRecognizer velocityInView:self]));
    
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        
        line.color = self.currentLineColor;
        [self.finishedLines  addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

- (void)doubleTap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognized \"Double Tap\"");
    
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)tap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognized tap");
    
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    if (self.selectedLine)
    {
        // Make ourselves the target of menu item action messages
        [self becomeFirstResponder];
        
        // Grab the menu controller
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        // Create a new "Delete" UIMenuItem
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        
        menu.menuItems = @[deleteItem];
        
        // Tell the menu where it should come from and show it
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
    else
    {
        // Hide the menu if no line is selected
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

- (void)longPress:(UIGestureRecognizer*)gr
{
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        
        if (self.selectedLine)
            [self.linesInProgress removeAllObjects];
    }
    else if (gr.state == UIGestureRecognizerStateEnded)
        self.selectedLine = nil;
    
    [self setNeedsDisplay];
}

- (BNRLine *)lineAtPoint:(CGPoint)p
{
    // Find a line close to p
    for (BNRLine *l in self.finishedLines)
    {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        // Check a few points on the line
        for (float t = 0.0; t <= 1.0; t += 0.05)
        {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            // If the tapped point is within 20 points, let's return this line
            if (hypot(x - p.x, y - p.y) < 20.0)
                return l;
        }
    }
    
    // If nothing is close enough to the tapped point, then we did not select a line
    return nil;
}

- (void)deleteLine:(id)sender
{
    // Remove the selected line from the list of _finishedLines
    [self.finishedLines removeObject:self.selectedLine];
    
    // Redraw everything!
    [self setNeedsDisplay];
}

-  (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.moveRecognizer)
        return YES;
    
    return NO;
}

- (void)moveLine:(UIPanGestureRecognizer *)gr
{
    // If a menu controller is visible and a line has been selected,
    // turn off the menu controller and deselect the line
    if (self.selectedLine != nil && [UIMenuController sharedMenuController].menuVisible == YES)
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
        
        self.selectedLine = nil;
        return;
    }
    else if (!self.selectedLine) // If there is no line selected, then exit this method
        return;
    
    // When the pan recognizer changes its position...
    if (gr.state == UIGestureRecognizerStateChanged)
    {
        // How far has the pan moved?
        CGPoint translation = [gr translationInView:self];
        
        // Add the translation to the current beginning and end points of the line
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        // Set the new beginning and end points of the line
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        // Redraw the screen
        [self setNeedsDisplay];
        
        // Resets your panning distance to zero
        [gr setTranslation:CGPointZero inView:self];
    }
}

- (void)showColorPanel:(UIGestureRecognizer *)gr
{
    NSLog(@"Two swipe gesture recognized");
    
    [UIView animateWithDuration:0.2
                          delay:0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                                    self.subviews[0].frame = CGRectMake(0, self.bounds.size.height / 2.0, self.bounds.size.width, self.bounds.size.height / 2.0);}
                     completion:^(BOOL finished) {
        NSLog(@"Done");
    }];
}

- (void) hideColorPanel:(UIGestureRecognizer *)gr
{
    NSLog(@"Two swipe gesture recognized");
    
    [UIView animateWithDuration:0.2
                          delay:0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                                    self.subviews[0].frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);}
                     completion:^(BOOL finished) {
                         NSLog(@"Done");
    }];
}

@end
