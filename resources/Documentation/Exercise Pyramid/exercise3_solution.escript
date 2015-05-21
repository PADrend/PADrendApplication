// Solution to Exercise 3

var rectangleMesh = Rendering.MeshBuilder.createRectangle(1.0, 1.0);
var geoNode = new MinSG.GeometryNode();
geoNode.setMesh(rectangleMesh);

var sceneNode = new MinSG.ListNode();

var cube = new MinSG.ListNode();

var backSide = geoNode.clone();
backSide.moveLocal(0.0, 0.0, -0.5);
cube.addChild(backSide);

var frontSide = geoNode.clone();
frontSide.moveLocal(0.0, 0.0, 0.5);
frontSide.rotateLocal_deg(180.0, 0.0, 1.0, 0.0);
cube.addChild(frontSide);

var leftSide = geoNode.clone();
leftSide.moveLocal(-0.5, 0.0, 0.0);
leftSide.rotateLocal_deg(90.0, 0.0, 1.0, 0.0);
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

var pyramidCreator = new ExtObject();

pyramidCreator.create := fn(MinSG.GroupNode rootNode, MinSG.Node templateNode) {
	for(var level = 1; level <= this.numLevels(); ++level) {
		var levelNode = new MinSG.ListNode();
		for(var x = 0; x < level; ++x) {
			for(var z = 0; z < level; ++z) {
				var newNode = templateNode.clone();
				newNode.moveLocal(x - level / 2, -level, z - level / 2);
				levelNode.addChild(newNode);
			}
		}

		var materialState = new MinSG.MaterialState();
		var color = new Util.Color4f(this.topLevelColor(), this.bottomLevelColor(), level / this.numLevels());
		materialState.setAmbient(color);
		materialState.setDiffuse(color);
		levelNode.addState(materialState);

		rootNode.addChild(levelNode);
	}
};

pyramidCreator.numLevels := new Std.DataWrapper(10);
pyramidCreator.topLevelColor := new Std.DataWrapper(new Util.Color4f(0.0, 0.0, 1.0, 1.0));
pyramidCreator.bottomLevelColor := new Std.DataWrapper(new Util.Color4f(1.0, 0.0, 0.0, 1.0));

var dialog = gui.createPopupWindow(300, 300);
dialog.addOption({
	GUI.TYPE			:	GUI.TYPE_RANGE,
	GUI.LABEL			:	"Number of levels",
	GUI.TOOLTIP			:	"The number of levels of the pyramid.",
	GUI.RANGE			:	[1, 20],
	GUI.RANGE_STEPS		:	19,
	GUI.DATA_WRAPPER	:	pyramidCreator.numLevels
});
dialog.addOption({
	GUI.TYPE			:	GUI.TYPE_COLOR,
	GUI.LABEL			:	"Top level color",
	GUI.TOOLTIP			:	"The color for the beginning of the gradient.",
	GUI.DATA_WRAPPER	:	pyramidCreator.topLevelColor
});
dialog.addOption({
	GUI.TYPE			:	GUI.TYPE_COLOR,
	GUI.LABEL			:	"Bottom level color",
	GUI.TOOLTIP			:	"The color for the ending of the gradient.",
	GUI.DATA_WRAPPER	:	pyramidCreator.bottomLevelColor
});
dialog.addAction("Generate Pyramid", pyramidCreator -> pyramidCreator.create.bindLastParams(sceneNode, cube));
dialog.addAction("Cancel");
dialog.init();

PADrend.selectScene(sceneNode);
