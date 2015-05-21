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
MinSG.InspectionState := new Type(MinSG.ScriptedState); 

var InspectionState = MinSG.InspectionState;
InspectionState._printableName @(override) ::= $InspectionState;

InspectionState.frameNumberCounter @(init) := fn() { return PADrend.frameStatistics.getCounterForDescription("frame number"); };
InspectionState.frameNumber @(init) := fn() { return new Std.DataWrapper(0); };
InspectionState.renderingChannel @(init) := fn() { return new Std.DataWrapper(""); };
InspectionState.renderingFlags @(init) := fn() { return new Std.DataWrapper(0); };
InspectionState.renderingBOUNDINGBOXES @(init) := fn() { return new Std.DataWrapper(false); };
InspectionState.renderingNOGEOMETRY @(init) := fn() { return new Std.DataWrapper(false); };
InspectionState.renderingFRUSTUMCULLING @(init) := fn() { return new Std.DataWrapper(false); };
InspectionState.renderingSHOWMETAOBJECTS @(init) := fn() { return new Std.DataWrapper(false); };
InspectionState.renderingSHOWCOORDSYSTEM @(init) := fn() { return new Std.DataWrapper(false); };
InspectionState.renderingUSEWORLDMATRIX @(init) := fn() { return new Std.DataWrapper(false); };
InspectionState.renderingNOSTATES @(init) := fn() { return new Std.DataWrapper(false); };
InspectionState.renderingSKIPRENDERER @(init) := fn() { return new Std.DataWrapper(false); };
InspectionState.renderingChannels @(init) := fn() { return new Std.DataWrapper(""); };

InspectionState.doEnableState @(override) ::= fn(node, rp) {
	frameNumber(PADrend.frameStatistics.getValue(frameNumberCounter));
	renderingChannel(rp.getChannel());
	renderingFlags(rp.getFlags());
	renderingBOUNDINGBOXES(rp.getFlag(MinSG.BOUNDING_BOXES));
	renderingNOGEOMETRY(rp.getFlag(MinSG.NO_GEOMETRY));
	renderingFRUSTUMCULLING(rp.getFlag(MinSG.FRUSTUM_CULLING));
	renderingSHOWMETAOBJECTS(rp.getFlag(MinSG.SHOW_META_OBJECTS));
	renderingSHOWCOORDSYSTEM(rp.getFlag(MinSG.SHOW_COORD_SYSTEM));
	renderingUSEWORLDMATRIX(rp.getFlag(MinSG.USE_WORLD_MATRIX));
	renderingNOSTATES(rp.getFlag(MinSG.NO_STATES));
	renderingSKIPRENDERER(rp.getFlag(MinSG.SKIP_RENDERER));
	renderingChannels(toJSON(frameContext.getRenderingChannels()));
};

NodeEditor.registerConfigPanelProvider(InspectionState, fn(state, panel) {
	panel += "*InspectionState*";
	panel++;

	panel += {
		GUI.TYPE			:	GUI.TYPE_NUMBER,
		GUI.LABEL			:	"Frame number",
		GUI.DATA_WRAPPER	:	state.frameNumber,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0],
		GUI.FLAGS			:	GUI.LOCKED
	};
	panel++;

	panel += {
		GUI.TYPE			:	GUI.TYPE_TEXT,
		GUI.LABEL			:	"Rendering channel",
		GUI.DATA_WRAPPER	:	state.renderingChannel,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0],
		GUI.FLAGS			:	GUI.LOCKED
	};
	panel++;

	panel += {
		GUI.TYPE			:	GUI.TYPE_NUMBER,
		GUI.LABEL			:	"Rendering flags",
		GUI.DATA_WRAPPER	:	state.renderingFlags,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0],
		GUI.FLAGS			:	GUI.LOCKED

	};
	panel++;

	panel += {
		GUI.TYPE			:	GUI.TYPE_BOOL,
		GUI.LABEL			:	"BOUNDING_BOXES",
		GUI.DATA_WRAPPER	:	state.renderingBOUNDINGBOXES,
		GUI.SIZE			:	[GUI.WIDTH_FILL_REL, 0.45, 0],
		GUI.FLAGS			:	GUI.LOCKED
	};
	panel += {
		GUI.TYPE			:	GUI.TYPE_BOOL,
		GUI.LABEL			:	"NO_GEOMETRY",
		GUI.DATA_WRAPPER	:	state.renderingNOGEOMETRY,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0],
		GUI.FLAGS			:	GUI.LOCKED
	};
	panel++;
	panel += {
		GUI.TYPE			:	GUI.TYPE_BOOL,
		GUI.LABEL			:	"FRUSTUM_CULLING",
		GUI.DATA_WRAPPER	:	state.renderingFRUSTUMCULLING,
		GUI.SIZE			:	[GUI.WIDTH_FILL_REL, 0.45, 0],
		GUI.FLAGS			:	GUI.LOCKED
	};
	panel += {
		GUI.TYPE			:	GUI.TYPE_BOOL,
		GUI.LABEL			:	"SHOW_META_OBJECTS",
		GUI.DATA_WRAPPER	:	state.renderingSHOWMETAOBJECTS,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0],
		GUI.FLAGS			:	GUI.LOCKED
	};
	panel++;
	panel += {
		GUI.TYPE			:	GUI.TYPE_BOOL,
		GUI.LABEL			:	"SHOW_COORD_SYSTEM",
		GUI.DATA_WRAPPER	:	state.renderingSHOWCOORDSYSTEM,
		GUI.SIZE			:	[GUI.WIDTH_FILL_REL, 0.45, 0],
		GUI.FLAGS			:	GUI.LOCKED
	};
	panel += {
		GUI.TYPE			:	GUI.TYPE_BOOL,
		GUI.LABEL			:	"USE_WORLD_MATRIX",
		GUI.DATA_WRAPPER	:	state.renderingUSEWORLDMATRIX,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0],
		GUI.FLAGS			:	GUI.LOCKED
	};
	panel++;
	panel += {
		GUI.TYPE			:	GUI.TYPE_BOOL,
		GUI.LABEL			:	"NO_STATES",
		GUI.DATA_WRAPPER	:	state.renderingNOSTATES,
		GUI.SIZE			:	[GUI.WIDTH_FILL_REL, 0.45, 0],
		GUI.FLAGS			:	GUI.LOCKED
	};
	panel += {
		GUI.TYPE			:	GUI.TYPE_BOOL,
		GUI.LABEL			:	"SKIP_RENDERER",
		GUI.DATA_WRAPPER	:	state.renderingSKIPRENDERER,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0],
		GUI.FLAGS			:	GUI.LOCKED
	};
	panel++;

	panel += "Rendering channels:";
	var renderingChannelsLabel = gui.createComponent({
		GUI.TYPE			:	GUI.TYPE_LABEL,
		GUI.LABEL			:	"",
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0]
	});
	panel += renderingChannelsLabel;
	state.renderingChannels.onDataChanged += [renderingChannelsLabel] => fn(label, data) {
		label.setText(data);
	};
	state.renderingChannels("..."); // Force refresh on next set
	panel++;
});

registerExtension('NodeEditor_QueryAvailableStates', InspectionState -> fn(states) {
	if(MinSG.InspectionState != this) {
		return Extension.REMOVE_EXTENSION;
	}
	states["[scripted] "+_printableName] = this -> fn() { return new this(); };
});
