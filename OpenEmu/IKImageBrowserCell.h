#import <Foundation/Foundation.h>

@interface IKImageBrowserCell ()
+ (void)temporaryPauseCurrentPlayingMovieIfAny:(id)arg1;
+ (BOOL)aCellIsPlayingInView:(id)arg1;
+ (void)stopCurrentPlayerIfAny;
+ (BOOL)shouldWrapLabelsForIconSize:(double)arg1 gridSpacing:(double)arg2 titlesOnRight:(BOOL)arg3;
+ (struct CGPoint)anchorPointForCellFrame:(struct CGRect)arg1 withView:(id)arg2;
+ (struct CGPoint)anchorPointTranslationWithView:(id)arg1;
+ (BOOL)supportsHeightOfInfoSpaceFactorization;
- (id)representedItem;
- (void)setGroup:(id)arg1;
- (void)mouseExited:(id)arg1;
- (void)mouseEntered:(id)arg1;
- (BOOL)isMouseOver;
- (BOOL)wantsRollover;
- (BOOL)_redisplayOnRollover;
- (BOOL)_isFirstPageOfBookletStyle;
- (void)installToolTips;
- (BOOL)titleIsTruncated;
- (unsigned long long)fileSize;
- (BOOL)mouseDown:(struct CGPoint)arg1 inView:(id)arg2;
- (void)setPrivateAnimationMask:(unsigned int)arg1;
- (unsigned int)privateAnimationMask;
- (void)setReordering:(BOOL)arg1;
- (BOOL)reordering;
- (void)setHidden:(BOOL)arg1;
- (BOOL)hidden;
- (void)setBrowser:(id)arg1;
- (id)browser;
- (void)setImageBrowserView:(id)arg1;
- (double)opacity;
- (void)setParent:(id)arg1;
- (void)parentWillDie:(id)arg1;
- (void)temporaryPauseMovie;
- (void)unpauseMovie;
- (BOOL)isPlaying;
- (void)startPlay;
- (void)stopPlay;
- (struct CGRect)playerFrame;
- (BOOL)contentCanBePlayed;
- (id)playerView;
- (BOOL)showPlayerControls;
- (void)draw;
- (void)drawWithComponentMask:(int)arg1;
- (int)_sizeToDraw;
- (void)drawDragHighlight;
- (void)drawSelection;
- (struct CGRect)selectionFrame;
- (void)drawSubtitle;
- (struct CGRect)subtitleFrame;
- (void)drawTitle;
- (void)drawTitleBackground;
- (void)drawSelectionOnTitle;
- (struct CGRect)titleStringFrame;
- (struct CGRect)titleFrame;
- (double)roundedWidthForCenterAlignment:(double)arg1;
- (id)currentTitleAttributes;
- (struct CGSize)_getTitleSize;
- (void)drawImage:(id)arg1;
- (void)drawPlayerControl;
- (BOOL)_playerViewHasPlayControls;
- (struct CGRect)playButtonFrame;
- (void)drawBackground;
- (void)drawOverlays;
- (void)drawPlaceHolder;
- (void)drawImageOutline;
- (void)drawShadow;
- (void)renderLayer:(id)arg1 inFrame:(struct CGRect)arg2;
- (BOOL)_transform:(struct CATransform3D *)arg1 forLayer:(id)arg2 inFrame:(struct CGRect)arg3;
- (void)didRecoverImageFromCache;
- (void)imageDidChange;
- (void)datasourceItemDidChange;
- (void)willBeRemovedFromView;
- (void)sizeDidChange;
- (void)positionDidChange;
- (void)didImport;
- (void)setBlinking:(BOOL)arg1;
- (BOOL)isBlinking;
- (void)setSelected:(BOOL)arg1;
- (BOOL)isSelectable;
- (BOOL)isSelected;
- (BOOL)canBeDoubleClicked;
- (struct CGSize)size;
- (struct CGRect)_iconFrameForCellFrameSize:(struct CGSize)arg1;
- (id)typeSelectString;
- (BOOL)hitTestWithRect:(struct CGRect)arg1;
- (BOOL)hitTestWithPoint:(struct CGPoint)arg1;
- (BOOL)acceptsDrop;
- (struct CGRect)reflectionFrame;
// - (CDStruct_02837cd9)usedRectInCellFrame:(CDStruct_02837cd9)arg1;
- (void)invalidateTitle;
- (void)invalidateLayout;
- (void)setLayoutValid:(BOOL)arg1;
- (BOOL)isLayoutValid;
- (struct CGRect)inlinePreviewFrame;
- (struct CGRect)imageBorderFrame;
- (struct CGRect)imageFrame;
- (int)_heightOfFixedSizeSpace;
- (struct CGRect)imageContainerFrame;
- (int)heightOfInfoSpace;
- (struct CGRect)frame;
- (float)rotation;
- (void)setRotation:(float)arg1;
- (void)centerToPosition:(struct CGPoint)arg1;
- (struct CGPoint)position;
- (void)setFrame:(struct CGRect)arg1;
- (void)setSize:(struct CGSize)arg1;
- (void)setPosition:(struct CGPoint)arg1;
- (void)_computeImageFrame;
- (struct CGRect)imageFrameForCellFrame:(struct CGRect)arg1;
- (struct CGRect)imageFrameForImageContainerFrame:(struct CGRect)arg1 useAspectRatio:(BOOL)arg2;
- (struct CGRect)imageFrameForImageContainerFrame:(struct CGRect)arg1;
- (struct CGSize)imageSizeForCellSize:(struct CGSize)arg1 withAspectRatio:(float)arg2;
- (struct CGRect)roundedFrame;
- (double)baseline;
- (void)setAspectRatio:(float)arg1;
- (float)aspectRatio;
- (float)_computeAspectRatio;
- (BOOL)cachedTitleSizeIsValid;
- (void)invalidateTitleSize;
- (void)invalidate;
- (void)finalize;
- (void)dealloc;
- (id)init;
- (id)forwardingTargetForSelector:(SEL)arg1;

@end
