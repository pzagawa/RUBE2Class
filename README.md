## RUBE2Class
RUBE Box2D Editor object to Objective-c class converter.

#### What is this?
RUBE2Class is simple Mac OS X command line utility created to convert JSON RUBE Box2D Editor object data to Objective-C class with direct Box2D object creation code.

#### How to use it?
Create object in RUBE editor. Save it to json format.

Then run in console:  
*rube2class sourceFile targetPath className*

for example:  
*rube2class ~/Documents/scene.json ~/Documents/ ScenePhysData*

This example creates ScenePhysData Objective-C class with Box2D object defined in code.

Then just run create ScenePhysData instance, set physWorld property and run [create] method to instantiate Box2D object.
