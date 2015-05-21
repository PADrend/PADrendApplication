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
MinSG.PointSizeState := new Type(MinSG.ScriptedState); 

var PointSizeState = MinSG.PointSizeState;
PointSizeState._printableName @(override) ::= $PointSizeState;

PointSizeState.pointSize @(init) := fn() { return new Std.DataWrapper(1.0); };

PointSizeState.doEnableState @(override) ::= fn(d*) {
	renderingContext.pushAndSetPointParameters(new Rendering.PointParameters(pointSize()));
};

PointSizeState.doDisableState @(override) ::= fn(d*) {
	renderingContext.popPointParameters();
};

NodeEditor.registerConfigPanelProvider(PointSizeState, fn(state, panel) {
	panel += "*PointSizeState*";
	panel++;

	panel += {
		GUI.TYPE			:	GUI.TYPE_RANGE,
		GUI.LABEL			:	"Point size",
		GUI.RANGE			:	[0.1, 128.0],
		GUI.RANGE_STEPS		:	1279,
		GUI.DATA_WRAPPER	:	state.pointSize,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0]
	};
	panel++;
});

registerExtension('NodeEditor_QueryAvailableStates', PointSizeState -> fn(states) {
	if(MinSG.PointSizeState != this) {
		return Extension.REMOVE_EXTENSION;
	}
	states["[scripted] "+_printableName] = this -> fn() { return new this(); };
});
