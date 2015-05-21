/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2010-2012 Benjamin Eikel <benjamin@eikel.org>
 * Copyright (C) 2010-2012 Claudius Jähn <claudius@uni-paderborn.de>
 * Copyright (C) 2010-2012 Ralf Petring <ralf@petring.net>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */
var config = new ExtObject();
var popup = gui.createPopupWindow(400,300, "Multiply Scene");
config.copiesX := Std.DataWrapper.createFromEntry(PADrend.configCache, "Preset.MultiplyScene.xCopies", 2);
popup.addOption({
	GUI.TYPE : GUI.TYPE_RANGE,
	GUI.LABEL : "Copies X",
	GUI.RANGE : [1,100],
	GUI.RANGE_STEPS : 99,
	GUI.DATA_WRAPPER : config.copiesX
});
config.copiesY := Std.DataWrapper.createFromEntry(PADrend.configCache, "Preset.MultiplyScene.yCopies", 1);
popup.addOption({
	GUI.TYPE : GUI.TYPE_RANGE,
	GUI.LABEL : "Copies Y",
	GUI.RANGE : [1,100],
	GUI.RANGE_STEPS : 99,
	GUI.DATA_WRAPPER : config.copiesY
});
config.copiesZ := Std.DataWrapper.createFromEntry(PADrend.configCache, "Preset.MultiplyScene.zCopies", 2);
popup.addOption({
	GUI.TYPE : GUI.TYPE_RANGE,
	GUI.LABEL : "Copies Z",
	GUI.RANGE : [1,100],
	GUI.RANGE_STEPS : 99,
	GUI.DATA_WRAPPER : config.copiesZ
});
config.moveStates := Std.DataWrapper.createFromEntry(PADrend.configCache, "Preset.MultiplyScene.moveStates", true);
popup.addOption({
	GUI.TYPE : GUI.TYPE_BOOL,
	GUI.LABEL : "move states",
	GUI.TOOLTIP : "move states from old scene root to new scene root",
	GUI.DATA_WRAPPER : config.moveStates
});
config.multSpacing := Std.DataWrapper.createFromEntry(PADrend.configCache, "Preset.MultiplyScene.multSpacing", 1);
popup.addOption({
	GUI.TYPE : GUI.TYPE_RANGE,
	GUI.RANGE : [0,2],
	GUI.RANGE_STEPS : 20,
	GUI.LABEL : "multiplicativ Spacing",
	GUI.TOOLTIP : "adds space of x times clonesize between clones",
	GUI.DATA_WRAPPER : config.multSpacing
});
config.addSpacing := Std.DataWrapper.createFromEntry(PADrend.configCache, "Preset.MultiplyScene.addSpacing", 0);
popup.addOption({
	GUI.TYPE : GUI.TYPE_RANGE,
	GUI.RANGE : [0,100],
	GUI.RANGE_STEPS : 100,
	GUI.LABEL : "additive Spacing",
	GUI.TOOLTIP : "adds space of x between clones",
	GUI.DATA_WRAPPER : config.addSpacing
});
config.randomRotate := Std.DataWrapper.createFromEntry(PADrend.configCache, "Preset.MultiplyScene.randomRotate", false);
popup.addOption({
	GUI.TYPE : GUI.TYPE_BOOL,
	GUI.LABEL : "rotate randomly",
	GUI.TOOLTIP : "rotates clones randomly around y-axis",
	GUI.DATA_WRAPPER : config.randomRotate
});
config.randomMoveX := Std.DataWrapper.createFromEntry(PADrend.configCache, "Preset.MultiplyScene.randomMoveX", 0);
popup.addOption({
	GUI.TYPE : GUI.TYPE_RANGE,
	GUI.RANGE : [0,100],
	GUI.RANGE_STEPS : 100,
	GUI.LABEL : "move randomly x",
	GUI.TOOLTIP : "move clones randomly along x-axis in [0,x]",
	GUI.DATA_WRAPPER : config.randomMoveX
});
config.randomMoveY := Std.DataWrapper.createFromEntry(PADrend.configCache, "Preset.MultiplyScene.randomMoveY", 0);
popup.addOption({
	GUI.TYPE : GUI.TYPE_RANGE,
	GUI.RANGE : [0,100],
	GUI.RANGE_STEPS : 100,
	GUI.LABEL : "move randomly y",
	GUI.TOOLTIP : "move clones randomly along y-axis in [0,y]",
	GUI.DATA_WRAPPER : config.randomMoveY
});
config.randomMoveZ := Std.DataWrapper.createFromEntry(PADrend.configCache, "Preset.MultiplyScene.randomMoveZ", 0);
popup.addOption({
	GUI.TYPE : GUI.TYPE_RANGE,
	GUI.RANGE : [0,100],
	GUI.RANGE_STEPS : 100,
	GUI.LABEL : "move randomly z",
	GUI.TOOLTIP : "move clones randomly along z-axis in [0,z]",
	GUI.DATA_WRAPPER : config.randomMoveZ
});

config.doIt := fn(){

	var scene = PADrend.getCurrentScene();
	
	var states = [];
	if(moveStates()){
		foreach(scene.getStates() as var s)
			states += s;
		scene.removeStates();
	}
	
	var bounds = scene.getWorldBB();
	var sizeX = bounds.getExtentX() * multSpacing() + addSpacing();
	var sizeY = bounds.getExtentY() * multSpacing() + addSpacing();
	var sizeZ = bounds.getExtentZ() * multSpacing() + addSpacing();
	var newScene = new MinSG.ListNode();
	for(var i=0; i<copiesX();i++)
		for(var j=0; j<copiesY(); j++)
			for(var k=0; k<copiesZ(); k++)
			{
				var tmp = MinSG.Node.createInstance(scene);
				tmp.moveRel(new Geometry.Vec3(i*sizeX, j*sizeY, k*sizeZ));
				if(randomRotate()){
					tmp.rotateRel_deg(Rand.uniform(0,360), 0, 1, 0);
				}
				tmp.moveRel(new Geometry.Vec3( Rand.uniform(0,randomMoveX()), Rand.uniform(0,randomMoveY()), Rand.uniform(0,randomMoveZ()) ));
				newScene.addChild(tmp);
			}
	
	if(moveStates()){
		foreach(states as var s)
			newScene.addState(s);
	}
	
	PADrend.registerScene(newScene);
	PADrend.selectScene(newScene);
};

popup.addAction("Start", config->config.doIt);
popup.addAction("Cancel");

popup.init();
