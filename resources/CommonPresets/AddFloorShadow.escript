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
var bb = PADrend.getCurrentScene().getWorldBB();
var groundLevel = bb.getMinY();
bb.resizeRel(3);

var builder = new Rendering.MeshBuilder();
builder.normal(new Geometry.Vec3(0, 1, 0));
builder.color(new Util.Color4f(1, 1, 1, 1));

builder.texCoord0(new Geometry.Vec2(0, 0));
builder.position(new Geometry.Vec3(bb.getMinX(), 0, bb.getMinZ()));
builder.addVertex();

builder.texCoord0(new Geometry.Vec2(0, 1));
builder.position(new Geometry.Vec3(bb.getMinX(), 0, bb.getMaxZ()));
builder.addVertex();

builder.texCoord0(new Geometry.Vec2(1, 1));
builder.position(new Geometry.Vec3(bb.getMaxX(), 0, bb.getMaxZ()));
builder.addVertex();

builder.texCoord0(new Geometry.Vec2(1, 0));
builder.position(new Geometry.Vec3(bb.getMaxX(), 0, bb.getMinZ()));
builder.addVertex();

builder.addQuad(0, 1, 2, 3);

var geoNode = new MinSG.GeometryNode(builder.buildMesh());
geoNode.setWorldOrigin(new Geometry.Vec3(0, groundLevel, 0));

var blendingState = new MinSG.BlendingState();
blendingState.setBlendEquation(Rendering.BlendEquation.FUNC_ADD);
blendingState.setBlendFuncSrc(Rendering.BlendFunc.ZERO);
blendingState.setBlendFuncDst(Rendering.BlendFunc.SRC_COLOR);
geoNode.addState(blendingState);

PADrend.getCurrentScene().addChild(geoNode);
