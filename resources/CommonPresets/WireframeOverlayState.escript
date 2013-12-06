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
var WireframeOverlayState = new Type(MinSG.ScriptedState);

WireframeOverlayState.polygonModeState := void;
WireframeOverlayState.shaderState := void;

WireframeOverlayState._constructor ::= fn() {
	this.polygonModeState = new MinSG.PolygonModeState();
	this.polygonModeState.setMode(Rendering.PolygonModeParameters.LINE);
	this.shaderState = new MinSG.ShaderState(Rendering.Shader.createShader(
		"#version 110\nvoid main() { gl_Position = ftransform(); }",
		"#version 110\nvoid main() { if(gl_FragCoord.z > 0.99) { discard; } gl_FragColor = vec4(0.0, 0.0 ,0.0, 1.0); }",
		Rendering.Shader.USE_GL
	));
};

WireframeOverlayState.doEnableState ::= fn(node, params) {
	return MinSG.STATE_OK;
};

WireframeOverlayState.doDisableState ::= fn(node, params) {
	this.polygonModeState.enableState(frameContext);
	this.shaderState.enableState(frameContext);
	renderingContext.pushAndSetPolygonOffset(0.0, -1.0);
	frameContext.displayNode(node, MinSG.FRUSTUM_CULLING | MinSG.USE_WORLD_MATRIX | MinSG.NO_STATES);
	renderingContext.popPolygonOffset();
	this.shaderState.disableState(frameContext);
	this.polygonModeState.disableState(frameContext);
};

NodeEditor.getSelectedNode().addState(new WireframeOverlayState());
