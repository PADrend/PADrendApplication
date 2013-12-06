// Solution to Exercise 1

var rectangleMesh = 
		Rendering.MeshBuilder.createRectangle(1.0, 1.0);
var geoNode = new MinSG.GeometryNode();
geoNode.setMesh(rectangleMesh);

var sceneNode = new MinSG.ListNode();

// Create a new node holding the sides of the cube
var cube = new MinSG.ListNode();

var backSide = geoNode.clone();
backSide.moveLocal(0.0, 0.0, -0.5);
cube.addChild(backSide);

var frontSide = geoNode.clone();
frontSide.moveLocal(0.0, 0.0, 0.5);
frontSide.rotateLocal_deg(180.0, 0.0, 1.0, 0.0);
cube.addChild(frontSide);

// Create a clone of the node having the rectangle
var leftSide = geoNode.clone();
// Move the node to the left
leftSide.moveLocal(-0.5, 0.0, 0.0);
// Rotate the node by 90 degrees around the y axis
leftSide.rotateLocal_deg(90.0, 0.0, 1.0, 0.0);
// Add the node to the cube node
cube.addChild(leftSide);

var rightSide = geoNode.clone();
rightSide.moveLocal(0.5, 0.0, 0.0);
rightSide.rotateLocal_deg(-90.0, 0.0, 1.0, 0.0);
cube.addChild(rightSide);

var bottomSide = geoNode.clone();
bottomSide.moveLocal(0.0, -0.5, 0.0);
bottomSide.rotateLocal_deg(-90.0, 1.0, 0.0, 0.0);
cube.addChild(bottomSide);

var topSide = geoNode.clone();
topSide.moveLocal(0.0, 0.5, 0.0);
topSide.rotateLocal_deg(90.0, 1.0, 0.0, 0.0);
cube.addChild(topSide);

// Add the cube to the scene
sceneNode.addChild(cube);

PADrend.registerScene(sceneNode);
PADrend.selectScene(sceneNode);
