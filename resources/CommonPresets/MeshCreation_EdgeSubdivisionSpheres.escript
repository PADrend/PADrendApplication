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
var scene = PADrend.getCurrentScene();
var position = new Geometry.Vec3(0, 0, 0);

var platonicSolids = [
	Rendering.createTetrahedron(),
	Rendering.createOctahedron(),
	Rendering.createIcosahedron()
];

foreach(platonicSolids as var solid) {
	var spheres = [
		new MinSG.GeometryNode(solid.clone()),
		new MinSG.GeometryNode(Rendering.createEdgeSubdivisionSphere(solid.clone(), 1)),
		new MinSG.GeometryNode(Rendering.createEdgeSubdivisionSphere(solid.clone(), 2)),
		new MinSG.GeometryNode(Rendering.createEdgeSubdivisionSphere(solid.clone(), 3)),
		new MinSG.GeometryNode(Rendering.createEdgeSubdivisionSphere(solid.clone(), 4))
	];

	var cullFaceState = new MinSG.CullFaceState();
	cullFaceState.setCullNone();

	var polygonModeState = new MinSG.PolygonModeState();
	polygonModeState.setMode(Rendering.PolygonModeParameters.LINES);

	foreach(spheres as var sphere) {
		var wireSphere = sphere.clone();
		wireSphere.setWorldOrigin(position + new Geometry.Vec3(0, 3, 0));
		wireSphere.addState(polygonModeState.clone());
		wireSphere.addState(cullFaceState.clone());
		scene.addChild(wireSphere);

		sphere.setWorldOrigin(position);
		scene.addChild(sphere);

		position += new Geometry.Vec3(3, 0, 0);
	}

	position += new Geometry.Vec3(0, 7, 0);
	position.setX(0);
}
