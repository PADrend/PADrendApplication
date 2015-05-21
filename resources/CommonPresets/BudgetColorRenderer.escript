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
MinSG.BudgetColorRenderer := new Type(MinSG.ScriptedNodeRendererState); 

var BudgetColorRenderer = MinSG.BudgetColorRenderer;
BudgetColorRenderer._printableName @(override) ::= $BudgetColorRenderer;

BudgetColorRenderer.annotationAttribute @(init) := fn() { return new Std.DataWrapper("BudgetColor"); };
BudgetColorRenderer.budgetRangeR @(init) := fn() { return new Std.DataWrapper(1.0); };
BudgetColorRenderer.budgetRangeG @(init) := fn() { return new Std.DataWrapper(1.0); };
BudgetColorRenderer.budgetRangeB @(init) := fn() { return new Std.DataWrapper(1.0); };
BudgetColorRenderer.budgetRangeA @(init) := fn() { return new Std.DataWrapper(1.0); };

BudgetColorRenderer.uniformState @(init) := MinSG.ShaderUniformState;

BudgetColorRenderer.displayNode @(override) ::= fn(node, params) {
	var attribute = node.findNodeAttribute(annotationAttribute());
	if(!attribute) {
		return MinSG.STATE_SKIPPED;
	}

	var color = new Util.Color4f(	attribute * budgetRangeR(), 
									attribute * budgetRangeG(), 
									attribute * budgetRangeB(), 
									attribute * budgetRangeA());
	uniformState.setUniform(new Rendering.Uniform("color", Rendering.Uniform.VEC4F, [color]));
	uniformState.enableState(frameContext, node, 0);

	node.display(frameContext);

	uniformState.disableState(frameContext, node, 0);

	return MinSG.FrameContext.NODE_HANDLED;
};

NodeEditor.registerConfigPanelProvider(BudgetColorRenderer, fn(state, panel) {
	panel += "*BudgetColorRenderer*";
	panel++;
	panel+={
		GUI.TYPE			:	GUI.TYPE_TEXT,
		GUI.LABEL			:	"Attribute",
		GUI.TOOLTIP			:	"Name of the attribute that is read from the nodes.",
		GUI.DATA_WRAPPER	:	state.annotationAttribute,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0]
	};
	panel++;
	panel += {
		GUI.TYPE			:	GUI.TYPE_RANGE,
		GUI.LABEL			:	"Budget factor R",
		GUI.TOOLTIP			:	"Factor that is used to convert the budget to the red value of the color.",
		GUI.RANGE			:	[0.01, 1],
		GUI.RANGE_STEPS		:	1000,
		GUI.DATA_WRAPPER	:	state.budgetRangeR,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0]
	};
	panel++;
	panel += {
		GUI.TYPE			:	GUI.TYPE_RANGE,
		GUI.LABEL			:	"Budget factor G",
		GUI.TOOLTIP			:	"Factor that is used to convert the budget to the green value of the color.",
		GUI.RANGE			:	[0.01, 1],
		GUI.RANGE_STEPS		:	1000,
		GUI.DATA_WRAPPER	:	state.budgetRangeG,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0]
	};
	panel++;
	panel += {
		GUI.TYPE			:	GUI.TYPE_RANGE,
		GUI.LABEL			:	"Budget factor B",
		GUI.TOOLTIP			:	"Factor that is used to convert the budget to the red value of the color.",
		GUI.RANGE			:	[0.01, 1],
		GUI.RANGE_STEPS		:	1000,
		GUI.DATA_WRAPPER	:	state.budgetRangeB,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0]
	};
	panel++;
	panel += {
		GUI.TYPE			:	GUI.TYPE_RANGE,
		GUI.LABEL			:	"Budget factor A",
		GUI.TOOLTIP			:	"Factor that is used to convert the budget to the red value of the color.",
		GUI.RANGE			:	[0.01, 1],
		GUI.RANGE_STEPS		:	1000,
		GUI.DATA_WRAPPER	:	state.budgetRangeA,
		GUI.SIZE			:	[GUI.WIDTH_FILL_ABS, 10, 0]
	};
	panel++;
});

registerExtension('NodeEditor_QueryAvailableStates', BudgetColorRenderer -> fn(states) {
	if(MinSG.BudgetColorRenderer != this) {
		return Extension.REMOVE_EXTENSION;
	}
	states["[scripted] "+_printableName] = this -> fn() { return new this(); };
});
