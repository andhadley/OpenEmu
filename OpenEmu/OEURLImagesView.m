//
//  OEURLImagesView.m
//  OpenEmu
//
//  Created by Christoph Leimbrock on 14/07/14.
//
//

#import "OEURLImagesView.h"

NSString * const OEURLImagesViewImageDidLoadNotificationName = @"OEURLImagesViewImageDidLoad";

@interface OEURLImagesView ()
@property (assign) NSProgressIndicator *loadingIndicator;
@property (nonatomic) NSInteger currentImage;
@end

@implementation OEURLImagesView
static NSCache *cache;
static NSMutableDictionary *loading;

const static CGFloat itemWidth = 10.0;
const static CGFloat itemSpace =  4.0;

const static NSLock *lock;
+ (void)initialize
{
    if([self class] == [OEURLImagesView class])
    {
        lock = [[NSLock alloc] init];

        cache = [[NSCache alloc] init];
        [cache setCountLimit:50];

        loading = [NSMutableDictionary dictionary];
    }
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self OE_performSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self OE_performSetup];
    }
    return self;
}

- (void)OE_performSetup
{
    [self setURLs:nil];

    NSProgressIndicator *indicator = [[NSProgressIndicator alloc] initWithFrame:NSZeroRect];
    [indicator setIndeterminate:YES];
    [indicator setStyle:NSProgressIndicatorSpinningStyle];
    [indicator setControlSize:NSRegularControlSize];
    [indicator setHidden:YES];
    [indicator setUsesThreadedAnimation:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDidLoad:) name:OEURLImagesViewImageDidLoadNotificationName object:nil];

    _loadingIndicator = indicator;

    [self addSubview:indicator];

    [self setCurrentImage:0];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -
- (void)setURLs:(NSArray *)urls
{
    _URLs = urls;

    if(urls) [self setCurrentImage:0];
}

- (void)setCurrentImage:(NSInteger)currentImage
{
    _currentImage = currentImage;

    NSURL *url = [[self URLs] objectAtIndex:currentImage];

    [lock lock];
    NSImage *cachedImage = [cache objectForKey:url];
    [lock unlock];

    NSProgressIndicator *progress = [self loadingIndicator];
    if(cachedImage)
    {
        if(![progress isHidden])
        {
            [progress stopAnimation:nil];
            [progress setHidden:YES];
        }
    }
    else
    {
        [self OE_fetchImage:_currentImage];

        if([progress isHidden])
        {
            [progress setHidden:NO];
            [progress startAnimation:self];
        }
    }

    [self setNeedsDisplay:YES];
}

- (void)imageDidLoad:(NSNotification*)notification
{
    NSURL *loadedImage = [[notification userInfo] objectForKey:@"URL"];
    NSURL *url = [[self URLs] objectAtIndex:_currentImage];

    if([loadedImage isEqualTo:url])
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setCurrentImage:_currentImage];
        });
}

- (void)viewDidMoveToSuperview
{
    NSProgressIndicator *progress = [self loadingIndicator];
    [progress sizeToFit];

    CGFloat x = NSMidX([self bounds]) - NSWidth([progress frame])/2.0;
    CGFloat y = NSMidY([self bounds]) - NSHeight([progress frame])/2.0;
    [progress setFrameOrigin:NSMakePoint(x, y)];
}

#pragma mark - Frames
- (NSRect)pageSelectorRect
{
    const CGFloat midX = NSMidX([self bounds]);
    const NSInteger numberOfImages = [[self URLs] count];

    const CGFloat width = (numberOfImages*itemWidth + (numberOfImages-1)*itemSpace);
    const CGFloat minX = midX - width/2.0;
    return NSMakeRect(minX, 20, width, itemWidth);
}

- (NSRect)rectForPageSelector:(NSInteger)page
{
    const CGFloat midX = NSMidX([self bounds]);
    const NSInteger numberOfImages = [[self URLs] count];

    const CGFloat minX = midX - (numberOfImages*itemWidth + (numberOfImages-1)*itemSpace)/2.0
                              + (page*itemWidth + (page-1)*itemSpace);

    return NSMakeRect(minX, 20, itemWidth, itemWidth);
}

- (NSRect)rectForImage:(NSImage*)image
{
    return NSInsetRect([self bounds], 10, 10);
}

#pragma mark - Drawing
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [[NSColor clearColor] setFill];
    NSRectFill([self bounds]);

    NSURL *url = [[self URLs] objectAtIndex:_currentImage];
    NSImage *image = [cache objectForKey:url];
    if(image)
    {
        const NSRect imageRect = [self rectForImage:image];

        [[NSGraphicsContext currentContext] saveGraphicsState];
        NSShadow *shadow = [[NSShadow alloc] init];
        [shadow setShadowBlurRadius:3.0];
        [shadow setShadowOffset:NSMakeSize(0.0, -3.0)];
        [shadow setShadowColor:[NSColor blackColor]];
        [shadow set];

        [image drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0 respectFlipped:YES hints:nil];
        [[NSGraphicsContext currentContext] restoreGraphicsState];
    }

    NSInteger numberOfImages = [[self URLs] count];
    for(NSInteger i=0; i < numberOfImages; i++)
    {
        const NSRect rect = [self rectForPageSelector:i];
        const NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:rect];
        if(i == _currentImage)
        {
            [[NSColor clearColor] setFill];
            [[NSColor colorWithRed:0 green:136.0/255.0 blue:204.0/255.0 alpha:1.0] setStroke];
        } else {
            [[NSColor grayColor] setFill];
            [[NSColor clearColor] setStroke];
        }

        [path fill];
        [path stroke];
    }
}

#pragma mark - Interaction
- (void)updateTrackingAreas
{
    [[self trackingAreas] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeTrackingArea:obj];
    }];

    const NSRect trackingRect = [self pageSelectorRect];
    NSTrackingAreaOptions options = NSTrackingActiveInKeyWindow|NSTrackingMouseMoved;
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:trackingRect options:options owner:self userInfo:nil];
    [self addTrackingArea:area];

    NSTrackingArea *viewArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:NSTrackingActiveInKeyWindow|NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    [self addTrackingArea:viewArea];

}
- (void)mouseMoved:(NSEvent *)theEvent
{
    const NSRect  trackingRect = [self pageSelectorRect];
    const NSPoint locationInWindow = [theEvent locationInWindow];
    const NSPoint location = [self convertPoint:locationInWindow fromView:nil];

    if(NSPointInRect(location, trackingRect))
    {
        const CGFloat x = location.x-NSMinX(trackingRect);
        NSInteger index = x  / (itemWidth+itemSpace);

        if(x > index * (itemWidth+itemSpace)-itemSpace + itemWidth)
            return;

        [self setCurrentImage:index];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    [self mouseMoved:theEvent];
}

- (void)mouseEntered:(NSEvent *)theEvent
{}

- (void)mouseExited:(NSEvent *)theEvent
{
    [self setCurrentImage:0];
}

#pragma mark -
- (void)OE_fetchImage:(NSInteger)index
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSURL *url = [[self URLs] objectAtIndex:index];

    if(url == nil) return;

    [lock lock];
    if([cache objectForKey:url] == nil && [loading objectForKey:url] == nil)
    {
        [loading setObject:@(YES) forKey:url];

        dispatch_async(queue, ^{
            NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
            if(image == nil)
                image = [NSImage imageNamed:@"remote_image_unavaiable"];

            [lock lock];
            [cache setObject:image forKey:url];
            [loading removeObjectForKey:url];
            [lock unlock];

            NSDictionary *userInfo = @{ @"URL": url };
            [[NSNotificationCenter defaultCenter] postNotificationName:OEURLImagesViewImageDidLoadNotificationName object:nil userInfo:userInfo];
        });
    }
    [lock unlock];
}
@end