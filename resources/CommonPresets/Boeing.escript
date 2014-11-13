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
var mainTimer = new Util.Timer();
var timer = new Util.Timer();
var importDir = "Data/Boeing/";
var exportDir = "Data/Scenes/Boeing/";

out("getting File Names (");timer.reset();
var importZips = Util.dir(importDir, Util.DIR_FILES);
var importFiles = [];
foreach(importZips as var zip){
	importFiles.append(Util.dir("zip://"+zip.substr(7)+"$./", Util.DIR_FILES));
}
out(importFiles.count()," meshes in ", timer.getSeconds(), "sec)\n");

//while(importFiles.count()>100)
//	importFiles.popBack();

out("getting Bounding Boxes (");timer.reset();
var meshInfo = []; // [bounds, triangles, file]
var bounds = new Geometry.Box();
foreach(importFiles as var file){
	var mi = MinSG.getMetaInfo(file);
	meshInfo += mi;
	bounds.include(mi[0]);	
}
out(timer.getSeconds(), "sec)\n");
out("SceneBB: ",bounds.toString(),"\n");

var c = 1000000;
var b = bounds.getExtentX();
var h = bounds.getExtentY();
var t = bounds.getExtentZ();
var sq = (c * h * h / t / b).pow(1 / 3);
var tiles = [(b/h*sq).round(), sq.round(), (t/h*sq).round()];
out("split: ", tiles[0], " ", tiles[1], " ", tiles[2], " ", tiles[0]*tiles[1]*tiles[2], "\n");

var getIndex = fn(Geometry.Box bounds, Array tiles, Geometry.Vec3 center){
	return [
		((center.getX()-bounds.getMinX())*tiles[0] / bounds.getExtentX()).ceil()-1,
		((center.getY()-bounds.getMinY())*tiles[1] / bounds.getExtentY()).ceil()-1,
		((center.getZ()-bounds.getMinZ())*tiles[2] / bounds.getExtentZ()).ceil()-1
	];
};

out("building grid (");timer.reset();
var grid = [];
for(var i=0; i<tiles[0]; i++){
	var gri = [];
	grid += gri;
	for(var j=0; j<tiles[1]; j++){
		var gr = [];
		gri += gr;
		for(var k=0; k<tiles[2]; k++)
			gr += [];
	}
}
out(timer.getSeconds(), "sec)\n");

out("sorting meshes (");timer.reset();
foreach(meshInfo as var mi){
	var tile = getIndex(bounds, tiles, mi[0].getCenter());
	grid[tile[0]][tile[1]][tile[2]] += mi;
}
meshInfo = void;
out(timer.getSeconds(), "sec)\n");

out("building cells (");timer.reset();
var cells = [];
foreach(grid as var gri){
	foreach(gri as var gr){
		foreach(gr as var g){
			if(g.count()>0){
				var tmp = [];
				var tris = 0;
				foreach(g as var mi){
					if(mi[1] < 500){
						if(tris > 1000)
						{
							cells += tmp;
							tmp = [];
							tris = 0;
						}
						tmp += mi;
						tris += mi[1];
					}
					else{
						cells += [mi];
					}
				}
				if(tmp.count() > 0)
					cells += tmp;
			}
		}
	}
}
grid = void;

var faceCounter = 0; var meshCounter = 0; var cellCounter = 0;
foreach(cells as var cell){
	cellCounter++;
	foreach(cell as var mi){
		meshCounter++;
		faceCounter += mi[1];
	}
}
out(faceCounter, " faces in ", meshCounter, " meshes in  ", cellCounter, " cells, ", timer.getSeconds(), "sec)\n");


out("combining meshes (");timer.reset();
var count = 0; faceCounter = 0; var zipIndex = 1; var zipIndexString = "001";
var finalMeshes = [];
foreach(cells as var cell){
	foreach(cell as var mi)
		faceCounter += mi[1];
	if(faceCounter > 10000000){
		zipIndex++;
		faceCounter = 0;
		zipIndexString = ""+zipIndex;
		while(zipIndexString.length() < 3)
			zipIndexString = "0" + zipIndexString;
		Util.flush();
	}
	var fileName = "zip://" + exportDir + "Boeing_" + zipIndexString + ".zip$./" + (++count) + ".mmf";
	finalMeshes += MinSG.combineMeshes(cell, fileName);
}
Util.flush();
out(timer.getSeconds(), "sec)\n");

faceCounter = 0;
foreach(finalMeshes as var mi)
	faceCounter += mi[1];
out("Final: " + finalMeshes.count() + " meshes containing " + faceCounter + "triangles\n");

out("building scene (");timer.reset();
var scene = new MinSG.ListNode();
// FIXME: Lazy nodes will be removed in the near future.
foreach(finalMeshes as var mi)
	scene.addChild(MinSG.createLazyNode(mi));
out(timer.getSeconds(), "sec)\n");

out("building kd-tree (");timer.reset();
MinSG.buildKDTree(scene, 0, 10);
out(timer.getSeconds(), "sec)\n");

out("saving scene (");timer.reset();

MinSG.SceneManagement.saveMinSGFile(PADrend.getSceneManager(),exportDir + "Boeing.minsg",[scene]);
out(timer.getSeconds(), "sec)\n");

out("duration over all: ", mainTimer.getSeconds(), "sec\n");
Util.outputProcessMemory();

GLOBALS.registerScene(scene);
GLOBALS.selectScene(scene);
