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
var platonicSolids = [
	new MinSG.GeometryNode(Rendering.createTetrahedron()),
	new MinSG.GeometryNode(Rendering.createCube()),
	new MinSG.GeometryNode(Rendering.createOctahedron()),
	new MinSG.GeometryNode(Rendering.createDodecahedron()),
	new MinSG.GeometryNode(Rendering.createIcosahedron())
];

var scene = PADrend.getCurrentScene();
var position = new Geometry.Vec3(0, 0, 0);

var cullFaceState = new MinSG.CullFaceState();
cullFaceState.setCullingEnabled(false);

var polygonModeState = new MinSG.PolygonModeState();
polygonModeState.setMode(Rendering.PolygonModeParameters.LINE);

foreach(platonicSolids as var solid) {
	var wireSolid = solid.clone();
	wireSolid.setWorldOrigin(position + new Geometry.Vec3(0, 3, 0));
	wireSolid.addState(polygonModeState.clone());
	wireSolid.addState(cullFaceState.clone());
	scene.addChild(wireSolid);

	solid.setWorldOrigin(position);
	scene.addChild(solid);

	position += new Geometry.Vec3(3, 0, 0);
}
