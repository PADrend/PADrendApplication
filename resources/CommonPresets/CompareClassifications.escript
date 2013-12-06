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
/**
 * @file
 * Preset to load and compare two classifications.
 * Two scenes are additionally loaded for comparing visibility subdivisions.
 * The preset was originally created to compare the visibility data of two visibility subdivisions.
 *
 * @author Benjamin Eikel
 * @date 2011-09-05
 */

var sceneA = loadScene("data/scene/testA.minsg");
if(!sceneA) {
	throw("Could not load first scene!");
}
var classificationA = ClassificationManager.load("data/classification/testA.classification");
if(!classificationA) {
	throw("Could not load first classification!");
}

var sceneB = loadScene("data/scene/testB.minsg");
if(!sceneB) {
	throw("Could not load second scene!");
}
var classificationB = ClassificationManager.load("data/classification/testB.classification");
if(!classificationB) {
	throw("Could not load second classification!");
}

// Collect the regions of the first classification.
var regions = [];
var stack = [classificationA.getRootNode()];
while(!stack.empty()) {
	var node = stack.popFront();
	if(node ---|> MinSG.ValuatedRegionNode && node.countChildren() == 0) {
		regions += node;
	} else {
		stack.append(MinSG.getChildNodes(node));
	}
}

// Iterate over the collected regions and retrieve the corresponding region of the second classification.
foreach(regions as var regionA) {
	var center = regionA.getWorldBB().getCenter();
	var regionB = classificationB.getRootNode().getNodeAtPosition(center);
	
	var valueA = regionA.getValue();
	var valueB = regionB.getValue();
	
	// --- BEGIN ---
	// Code for "normal" classifications.
	if(valueA != valueB) {
	// --- END ---
	
	// --- BEGIN ---
	// Special code for visibility subdivisions that were created by merging cells only.
// 	var differenceFound = false;
// 	
// 	var nodesA = valueA[0].getNodes();
// 	var meshFilesA = [];
// 	foreach(nodesA as var geoNode) {
// 		meshFilesA += geoNode.getMesh().getFileName();
// 	}
// 	var nodesB = valueB[0].getNodes();
// 	var meshFilesB = [];
// 	foreach(nodesB as var geoNode) {
// 		meshFilesB += geoNode.getMesh().getFileName();
// 	}
// 	
// 	foreach(meshFilesA as var meshFile) {
// 		if(!meshFilesB.contains(meshFile)) {
// 			out("Mesh ", meshFile, " is missing in second classification.\n");
// 			differenceFound = true;
// 		}
// 	}
// 	
// 	if(differenceFound) {
	// --- END ---
		out("Difference in classifications:\n");
		out("Region A: ", regionA, ",\tbounding box: ", regionA.getWorldBB(), "\n");
		out("Region B: ", regionB, ",\tbounding box: ", regionB.getWorldBB(), "\n");
		out("Value A:\n");
		print_r(valueA);
		out("Value B:\n");
		print_r(valueB);
	}
}
