//
//  playListXmlParser.h
//  iplayerDumpTest
//
//  Created by Colin Bell on 02/12/2010.
//  Copyright 2010 GateWest. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface playListXmlParser : NSObject {
	//xml parser
	NSXMLParser * xmlParser;
	NSString * currentElement;
	NSMutableString * currentTitle;
}

- (NSString *) initPlayListXMLParser:(NSString *) theUrl;
- (void)parsePlayListXMLFileAtURL:(NSString *)URL;
@end
