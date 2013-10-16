About WeUniteSDK Framework:
==========================
WeUnite Framework for iOS is a way to follow and socialise around your favourite passion and boards over WeUnite social network easily. 
Check out the Help https://dev.weunite.com/how_to_guide for more detail on how to get the most from Weunite.


Goals of framework
================



Installation
=========
Getting a static framework(WeUniteSDK.framework):
       	These are the following steps:
		1. Set the current target to Build Framework 
		2. Build and Go,
	If build is succeeded then a Products directory will be created inside the WeUnite root folder(where the project is located.) 
         

Usage
========
For any given project, for which WeUniteSDK.framework needs to be added:
         These are the following steps:
		1. Locate the the WeUniteSDK.framework which you have recently builded or downloaded.
		2. Open the project in Xcode and drag and drop the WeUniteSDK.framework  in the project .
		3. A pop appears where you need to check the Copy items into destination group's folder option. Also check the respective targets under Add to targets.

3.  Using the  WeUniteSDK.framework:
		1. In any given file if you want to use the frameworks methods, add line
			#import <WeUniteSDK/WeUniteSDK.h> 	