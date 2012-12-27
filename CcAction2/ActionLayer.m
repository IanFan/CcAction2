//
//  ActionLayer.m
//  BasicCocos2D
//
//  Created by Fan Tsai Ming on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionLayer.h"

@implementation ActionLayer

@synthesize preActionInterval;

+(CCScene *) scene {
	CCScene *scene = [CCScene node];	
	ActionLayer *layer = [ActionLayer node];
	[scene addChild: layer];
  
	return scene;
}

#pragma mark -
#pragma mark Update

-(void)update:(ccTime)dt {
  CGSize winsize = [CCDirector sharedDirector].winSize;
  float offset = 0.5*ballSprite.boundingBox.size.width*ballSprite.scale;
  
  //keep the ball with the proper scale and inside the screen
  if (ballSprite.position.x > winsize.width+offset || ballSprite.position.x < -offset || ballSprite.position.y > winsize.height-offset || ballSprite.position.y < -offset || ballSprite.scale > 38 || ballSprite.scale < 0.012) {
    [self CCPlace];
  }
}

#pragma mark -
#pragma mark Action

//Position:
-(void)CCPlace{
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  [ballSprite stopAllActions];
  
  id placeAction = [CCPlace actionWithPosition:ccp(winSize.width/4, winSize.height/2)];
  [ballSprite runAction:placeAction];
  
  ballSprite.scale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 1.0:0.5;
  ballSprite.rotation = 0.0;
  ballSprite.opacity = 255;
  [ballSprite runAction:[CCShow action]];
}

-(void)CCMoveBy{
  float moveDis = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 98:48;
  id moveByAction = [CCMoveBy actionWithDuration:1 position:ccp(moveDis, 0)];
  [ballSprite runAction:moveByAction];
  self.preActionInterval = moveByAction;
}

-(void)CCBezierBy{
  float moveDis = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 98:48;
  
  ccBezierConfig bezierConfig;
  bezierConfig.controlPoint_1 = ccp(0, moveDis);
  bezierConfig.controlPoint_2 = ccp(moveDis, -moveDis);
  bezierConfig.endPosition = ccp(moveDis,0.5*moveDis);
  id bezierByAction = [CCBezierBy actionWithDuration:1 bezier:bezierConfig];
  [ballSprite runAction:bezierByAction];
  self.preActionInterval = bezierByAction;
}

-(void)CCCatmullRomBy{
  float moveDis = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 200:80;
  
  CCPointArray *pointArray = [CCPointArray arrayWithCapacity:6];
  [pointArray addControlPoint:CGPointMake(0, 0)];
  [pointArray addControlPoint:CGPointMake(CCRANDOM_0_1()*moveDis, CCRANDOM_0_1()*moveDis)];
  [pointArray addControlPoint:CGPointMake(CCRANDOM_0_1()*moveDis, CCRANDOM_0_1()*moveDis)];
  [pointArray addControlPoint:CGPointMake(CCRANDOM_0_1()*moveDis, CCRANDOM_0_1()*moveDis)];
  [pointArray addControlPoint:CGPointMake(CCRANDOM_0_1()*moveDis, CCRANDOM_0_1()*moveDis)];
  [pointArray addControlPoint:CGPointMake(0, 0)];
  
  id catmullRomByAction = [CCCatmullRomBy actionWithDuration:4 points:pointArray];
  [ballSprite runAction:catmullRomByAction];
  
  self.preActionInterval = catmullRomByAction;
}

-(void)CCJumpBy{
  float jumpDis = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 300:60;
  id jumpByAction = [CCJumpBy actionWithDuration:1.5 position:ccp(0, 0) height:jumpDis jumps:1];
  [ballSprite runAction:jumpByAction];
  self.preActionInterval = jumpByAction;
}

//Rotation:
-(void)CCRotateBy{
  id rotationByAction = [CCRotateBy actionWithDuration:1 angle:360];
  [ballSprite runAction:rotationByAction];
  self.preActionInterval = rotationByAction;
}

//Scale:
-(void)CCScaleBy{
  id scaleByAction = [CCScaleBy actionWithDuration:1 scale:1.5];
  [ballSprite runAction:scaleByAction];
  self.preActionInterval = scaleByAction;
}

//ReverseAciton:
-(void)Reverse{
  id reverseAction = [preActionInterval reverse];
  [ballSprite runAction:reverseAction];
  self.preActionInterval = reverseAction;
}

//Spawn Actions
-(void)CCSpawn{
  CGSize screen = [CCDirector sharedDirector].winSize;
  float jumpDis = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 300:60;
  
  id moveByAction = [CCMoveBy actionWithDuration:1 position:ccp(screen.width/10, 0)];
  id jumpByAction = [CCJumpBy actionWithDuration:1 position:ccp(0, 0) height:jumpDis jumps:1];
  id scaleByAction = [CCScaleBy actionWithDuration:1 scale:1.0/1.5];
  id rotationByAction = [CCRotateBy actionWithDuration:1 angle:360];
  CCSpawn *spawn = [CCSpawn actions:moveByAction,jumpByAction,scaleByAction,rotationByAction,nil];
  [ballSprite runAction:spawn];
  
  self.preActionInterval = spawn;
}

//Sequence Actions
-(void)CCSequence{
  float moveDis = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 98:48;
  
  id moveByAction = [CCMoveBy actionWithDuration:0.5 position:ccp(moveDis, 0)];
  id scaleByAction = [CCScaleBy actionWithDuration:0.5 scale:1.5];
  id rotationByAction = [CCRotateBy actionWithDuration:0.5 angle:360];
  CCSequence *sequence = [CCSequence actions:moveByAction,scaleByAction,rotationByAction,[rotationByAction reverse],[scaleByAction reverse],[moveByAction reverse],nil];
  [ballSprite runAction:sequence];
  
  self.preActionInterval = sequence;
}

//Repeat Action:
-(void)CCRepeat{
  id repeatAction = [CCRepeat actionWithAction:preActionInterval times:3];
  [ballSprite runAction:repeatAction];
}

-(void)CCRepeatForever{
  id repeatForeverAction = [CCRepeatForever actionWithAction:preActionInterval];
  [ballSprite runAction:repeatForeverAction];
}

//Pause All Actions
-(void)PauseTarget{
//  [ballSprite pauseSchedulerAndActions];
  [[[CCDirector sharedDirector]actionManager]pauseTarget:ballSprite];
}

//Resume All Actions
-(void)ResumeTarget{
//  [ballSprite resumeSchedulerAndActions];
  [[[CCDirector sharedDirector]actionManager]resumeTarget:ballSprite];
}

//Visible:
-(void)CCShow{
  id showAction = [CCShow action];
  [ballSprite runAction:showAction];
}

-(void)CCHide{
  id hideAction = [CCHide action];
  [ballSprite runAction:hideAction];
}

-(void)CCToggleVisibility{
  id toggleVisibilityAction = [CCToggleVisibility action];
  [ballSprite runAction:toggleVisibilityAction];
}

-(void)CCFadeIn{
  id fadeInAction = [CCFadeIn actionWithDuration:1];
  [ballSprite runAction:fadeInAction];
}

-(void)CCFadeOut{
  id fadeOutAction = [CCFadeOut actionWithDuration:1];
  [ballSprite runAction:fadeOutAction];
}

-(void)CCFadeTo{
  id fadeToAction = [CCFadeTo actionWithDuration:1 opacity:255/2];
  [ballSprite runAction:fadeToAction];
}

-(void)CCBlink{
  id blinkAction = [CCBlink actionWithDuration:1 blinks:5];
  [ballSprite runAction:blinkAction];
}

//Speed:
-(void)CCSpeed{
  id speedAction = [CCSpeed actionWithAction:preActionInterval speed:4];
  [ballSprite runAction:speedAction];
}

//Ease:
-(void)CCEaseIn{
  id easeInAction = [CCEaseIn actionWithAction:preActionInterval rate:2];
  [ballSprite runAction:easeInAction];
}

-(void)CCEaseOut{
  id easeOutAction = [CCEaseOut actionWithAction:preActionInterval rate:2];
  [ballSprite runAction:easeOutAction];
}

-(void)CCEaseInOut{
  id easeInOutAction = [CCEaseInOut actionWithAction:preActionInterval rate:2];
  [ballSprite runAction:easeInOutAction];
}

//EaseSine:
-(void)CCEaseSineIn{
  id easeSineInAction = [CCEaseSineIn actionWithAction:preActionInterval];
  [ballSprite runAction:easeSineInAction];
}

-(void)CCEaseSineOut{
  id easeSineOutAction = [CCEaseSineOut actionWithAction:preActionInterval];
  [ballSprite runAction:easeSineOutAction];
}

-(void)CCEaseSineInOut{
  id easeSineInOutAction = [CCEaseSineInOut actionWithAction:preActionInterval];
  [ballSprite runAction:easeSineInOutAction];
}

//EaseBackIn:
-(void)CCEaseBackIn{
  id easeBackInAction = [CCEaseBackIn actionWithAction:preActionInterval];
  [ballSprite runAction:easeBackInAction];
}

-(void)CCEaseBackOut{
  id easeBackOutAction = [CCEaseBackOut actionWithAction:preActionInterval];
  [ballSprite runAction:easeBackOutAction];
}

-(void)CCEaseBackInOut{
  id easeBackInOutAction = [CCEaseBackInOut actionWithAction:preActionInterval];
  [ballSprite runAction:easeBackInOutAction];
}

//EaseElastic:(recommended period values: 0.3 and 0.45)
-(void)CCEaseElasticIn{
  id easeElasticInAction = [CCEaseElasticIn actionWithAction:preActionInterval period:0.45];
  [ballSprite runAction:easeElasticInAction];
}

-(void)CCEaseElasticOut{
  id easeElasticOutAction = [CCEaseElasticOut actionWithAction:preActionInterval period:0.45];
  [ballSprite runAction:easeElasticOutAction];
}

-(void)CCEaseElasticInOut{
  id easeElasticInOutAction = [CCEaseElasticInOut actionWithAction:preActionInterval period:0.45];
  [ballSprite runAction:easeElasticInOutAction];
}

//EaseBounce:
-(void)CCEaseBounceIn{
  id easeBounceInAction = [CCEaseBounceIn actionWithAction:preActionInterval];
  [ballSprite runAction:easeBounceInAction];
}

-(void)CCEaseBounceOut{
  id easeBounceOutAction = [CCEaseBounceOut actionWithAction:preActionInterval];
  [ballSprite runAction:easeBounceOutAction];
}

-(void)CCEaseBounceInOut{
  id easeBounceInOutAction = [CCEaseBounceInOut actionWithAction:preActionInterval];
  [ballSprite runAction:easeBounceInOutAction];
}

//EaseExponential:
-(void)CCEaseExponentialIn{
  id easeExponentialInAction = [CCEaseExponentialIn actionWithAction:preActionInterval];
  [ballSprite runAction:easeExponentialInAction];
}

-(void)CCEaseExponentialOut{
  id easeExponentialInOutAction = [CCEaseExponentialOut actionWithAction:preActionInterval];
  [ballSprite runAction:easeExponentialInOutAction];
}

-(void)CCEaseExponentialInOut{
  id easeExponentialInAction = [CCEaseExponentialInOut actionWithAction:preActionInterval];
  [ballSprite runAction:easeExponentialInAction];
}

#pragma mark -
#pragma mark Set Menu

-(void)setMenu {
  [self prepareMenu1];
  [self prepareMenu2];
  [self prepareMenu3];
  [self prepareMenu4];
}

-(void)prepareMenu1 {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  int fontSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 20:12;
  
  CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"Place&Defaut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(CCPlace)];
  
  CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"MoveBy" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(CCMoveBy)];
  
  CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"BezierBy" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel3 = [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(CCBezierBy)];
  
  CCLabelTTF *label4 = [CCLabelTTF labelWithString:@"CatmullRomBy" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel4 = [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(CCCatmullRomBy)];
  
  CCLabelTTF *label5 = [CCLabelTTF labelWithString:@"JumpBy" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel5 = [CCMenuItemLabel itemWithLabel:label5 target:self selector:@selector(CCJumpBy)];
  
  CCLabelTTF *label6 = [CCLabelTTF labelWithString:@"RotateBy" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel6 = [CCMenuItemLabel itemWithLabel:label6 target:self selector:@selector(CCRotateBy)];
  
  CCLabelTTF *label7 = [CCLabelTTF labelWithString:@"ScaleBy" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel7 = [CCMenuItemLabel itemWithLabel:label7 target:self selector:@selector(CCScaleBy)];
  
  CCLabelTTF *label8 = [CCLabelTTF labelWithString:@"Reverse" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel8 = [CCMenuItemLabel itemWithLabel:label8 target:self selector:@selector(Reverse)];
  
  CCMenu *menu = [CCMenu menuWithItems:menuItemLabel1,menuItemLabel2,menuItemLabel3,menuItemLabel4,menuItemLabel5,menuItemLabel6,menuItemLabel7,menuItemLabel8, nil];
  [menu alignItemsVertically];
  [menu setPosition:CGPointMake(winSize.width/5, winSize.height/4)];
  [self addChild:menu];
}

-(void)prepareMenu2 {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  int fontSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 20:12;
  
  CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"Spawn" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(CCSpawn)];
  
  CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Sequence" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(CCSequence)];
  
  CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"Repeat" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel3 = [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(CCRepeat)];
  
  CCLabelTTF *label4 = [CCLabelTTF labelWithString:@"RepeatForever" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel4 = [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(CCRepeatForever)];
  
  CCLabelTTF *label5 = [CCLabelTTF labelWithString:@" " fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel5 = [CCMenuItemLabel itemWithLabel:label5];
  
  CCLabelTTF *label6 = [CCLabelTTF labelWithString:@"PauseTarget" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel6 = [CCMenuItemLabel itemWithLabel:label6 target:self selector:@selector(PauseTarget)];
  
  CCLabelTTF *label7 = [CCLabelTTF labelWithString:@"ResumeTarget" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel7 = [CCMenuItemLabel itemWithLabel:label7 target:self selector:@selector(ResumeTarget)];
  
  CCMenu *menu = [CCMenu menuWithItems:menuItemLabel1,menuItemLabel2,menuItemLabel3,menuItemLabel4,menuItemLabel5,menuItemLabel6,menuItemLabel7, nil];
  [menu alignItemsVertically];
  [menu setPosition:CGPointMake(winSize.width*2/5, winSize.height/4)];
  [self addChild:menu];
}

-(void)prepareMenu3 {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  int fontSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 20:12;
  
  CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"Show" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(CCShow)];
  
  CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Hide" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(CCHide)];
  
  CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"ToggleVisibility" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel3 = [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(CCToggleVisibility)];
  
  CCLabelTTF *label4 = [CCLabelTTF labelWithString:@"FadeIn" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel4 = [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(CCFadeIn)];
  
  CCLabelTTF *label5 = [CCLabelTTF labelWithString:@"FadeOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel5 = [CCMenuItemLabel itemWithLabel:label5 target:self selector:@selector(CCFadeOut)];
  
  CCLabelTTF *label6 = [CCLabelTTF labelWithString:@"FadeTo" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel6 = [CCMenuItemLabel itemWithLabel:label6 target:self selector:@selector(CCFadeTo)];
  
  CCLabelTTF *label7 = [CCLabelTTF labelWithString:@"CCBlink" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel7 = [CCMenuItemLabel itemWithLabel:label7 target:self selector:@selector(CCBlink)];
  
  CCMenu *menu = [CCMenu menuWithItems:menuItemLabel1,menuItemLabel2,menuItemLabel3,menuItemLabel4,menuItemLabel5,menuItemLabel6,menuItemLabel7, nil];
  [menu alignItemsVertically];
  [menu setPosition:CGPointMake(winSize.width*3/5, winSize.height/4)];
  [self addChild:menu];
}

-(void)prepareMenu4 {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  int fontSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 20:10;
  
  CCLabelTTF *label0 = [CCLabelTTF labelWithString:@"Speed" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel0 = [CCMenuItemLabel itemWithLabel:label0 target:self selector:@selector(CCSpeed)];
  
  CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"EaseIn" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(CCEaseIn)];
  
  CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"EaseOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel2 = [CCMenuItemLabel itemWithLabel:label2 target:self selector:@selector(CCEaseOut)];
  
  CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"EaseInOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel3 = [CCMenuItemLabel itemWithLabel:label3 target:self selector:@selector(CCEaseInOut)];
  
  CCLabelTTF *label4 = [CCLabelTTF labelWithString:@"EaseSineIn" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel4 = [CCMenuItemLabel itemWithLabel:label4 target:self selector:@selector(CCEaseSineIn)];
  
  CCLabelTTF *label5 = [CCLabelTTF labelWithString:@"EaseSineOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel5 = [CCMenuItemLabel itemWithLabel:label5 target:self selector:@selector(CCEaseSineOut)];
  
  CCLabelTTF *label6 = [CCLabelTTF labelWithString:@"EaseSineInOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel6 = [CCMenuItemLabel itemWithLabel:label6 target:self selector:@selector(CCEaseSineInOut)];
  
  CCLabelTTF *label7 = [CCLabelTTF labelWithString:@"EaseBackIn" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel7 = [CCMenuItemLabel itemWithLabel:label7 target:self selector:@selector(CCEaseBackIn)];
  
  CCLabelTTF *label8 = [CCLabelTTF labelWithString:@"EaseBackOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel8 = [CCMenuItemLabel itemWithLabel:label8 target:self selector:@selector(CCEaseBackOut)];
  
  CCLabelTTF *label9 = [CCLabelTTF labelWithString:@"EaseBackInOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel9 = [CCMenuItemLabel itemWithLabel:label9 target:self selector:@selector(CCEaseBackInOut)];
  
  CCLabelTTF *label10 = [CCLabelTTF labelWithString:@"EaseElasticIn" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel10 = [CCMenuItemLabel itemWithLabel:label10 target:self selector:@selector(CCEaseElasticIn)];
  
  CCLabelTTF *label11 = [CCLabelTTF labelWithString:@"EaseElasticOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel11 = [CCMenuItemLabel itemWithLabel:label11 target:self selector:@selector(CCEaseElasticOut)];
  
  CCLabelTTF *label12 = [CCLabelTTF labelWithString:@"EaseElasticInOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel12 = [CCMenuItemLabel itemWithLabel:label12 target:self selector:@selector(CCEaseElasticInOut)];
  
  CCLabelTTF *label13 = [CCLabelTTF labelWithString:@"EaseBounceIn" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel13 = [CCMenuItemLabel itemWithLabel:label13 target:self selector:@selector(CCEaseBounceIn)];
  
  CCLabelTTF *label14 = [CCLabelTTF labelWithString:@"EaseBounceOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel14 = [CCMenuItemLabel itemWithLabel:label14 target:self selector:@selector(CCEaseBounceOut)];
  
  CCLabelTTF *label15 = [CCLabelTTF labelWithString:@"EaseBounceInOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel15 = [CCMenuItemLabel itemWithLabel:label15 target:self selector:@selector(CCEaseBounceInOut)];
  
  CCLabelTTF *label16 = [CCLabelTTF labelWithString:@"EaseExponentialIn" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel16 = [CCMenuItemLabel itemWithLabel:label16 target:self selector:@selector(CCEaseExponentialIn)];
  
  CCLabelTTF *label17 = [CCLabelTTF labelWithString:@"EaseExponentialOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel17 = [CCMenuItemLabel itemWithLabel:label17 target:self selector:@selector(CCEaseExponentialOut)];
  
  CCLabelTTF *label18 = [CCLabelTTF labelWithString:@"EaseExponentialInOut" fontName:@"Helvetica" fontSize:fontSize];
  CCMenuItemLabel *menuItemLabel18 = [CCMenuItemLabel itemWithLabel:label18 target:self selector:@selector(CCEaseExponentialInOut)];
  
  CCMenu *menu = [CCMenu menuWithItems:menuItemLabel0,menuItemLabel1,menuItemLabel2,menuItemLabel3,menuItemLabel4,menuItemLabel5,menuItemLabel6,menuItemLabel7,menuItemLabel8,menuItemLabel9,menuItemLabel10,menuItemLabel11,menuItemLabel12,menuItemLabel13,menuItemLabel14,menuItemLabel15,menuItemLabel16,menuItemLabel17,menuItemLabel18, nil];
//  [menu alignItemsVertically];
  [menu alignItemsVerticallyWithPadding:5];
  [menu setPosition:CGPointMake(winSize.width*4/5, winSize.height/2)];
  
  [self addChild:menu];
}

#pragma mark -
#pragma mark Set DefaultAction

-(void)setDefaultAction {
  self.preActionInterval = [CCMoveBy actionWithDuration:1 position:ccp(98, 0)];
}

#pragma mark -
#pragma mark Set Ball

-(void)setBall {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  ballSprite = [CCSprite spriteWithFile:@"ball.png"];
  ballSprite.scale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad? 1.0:0.5;
  ballSprite.position = ccp(winSize.width/4, winSize.height/2);
  [self addChild:ballSprite];
}

/*
 Target:
 Play many kind of Actions, including movement, visibility, and speed.
 1. Set a ball to be the main character for actions.
 2. Set menu for playing the specific action.
 3. Set action functions for using the specific action properly.
 */

#pragma mark -
#pragma mark Init

-(id) init {
	if( (self=[super init])) {
    [self setBall];
    
    [self setDefaultAction];
    
    [self setMenu];
    
    [self schedule:@selector(update:) interval:1.0f/60.0f];
	}
  
	return self;
}

- (void) dealloc {
  self.preActionInterval = nil;
	[super dealloc];
}

@end
