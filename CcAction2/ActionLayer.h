//
//  ActionLayer.h
//  BasicCocos2D
//
//  Created by Fan Tsai Ming on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface ActionLayer : CCLayer
{
  CCSprite *ballSprite;
}

@property (nonatomic,retain) CCActionInterval *preActionInterval;

+(CCScene *) scene;

-(void)prepareMenu1;
-(void)prepareMenu2;
-(void)prepareMenu3;
-(void)prepareMenu4;
-(void)CCPlace;

@end
