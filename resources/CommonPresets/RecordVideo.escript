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

var recorder = new ExtObject({
	$prefix : PADrend.getUserPath()+"/video/"+Util.createTimeStamp()+"_",
	$running : true,
	$fps : 25,
	$time : 0,
	$step : fn(...){
		out("\n[[Video ","-"*30,"\n");
		out("Recording video into folder 'video'.\n");
		out("PADrend's internal frame time is adjusted for a video with ",fps," fps\n");
		out("Press [x] to Stop.\n\n");
		var counter = 0;
		
		this.time = PADrend.getSyncClock();
		var timerBackup =  PADrend.getSyncClock;
		
		PADrend.getSyncClock = this->fn(){return time;};
		
		while(running){
			var filename = prefix+counter.format(0,false,4,"0")+".png";
			++counter;
			var tex=Rendering.createTextureFromScreen();
			var b=Rendering.saveTexture(renderingContext,tex,filename);
			out(time,"s\t,",filename,"\t",b,"\n");

			time += 1/fps;
			yield;
		}
		out("Recording stopped.\n");
		out("\n","-"*30," Video]]\n");
		PADrend.getSyncClock = timerBackup ;
		
		return Extension.REMOVE_EXTENSION; 
	},
	$onKeyPressed : fn(evt){
		if(!running)
			return Extension.REMOVE_EXTENSION; 
		if(evt.key == Util.UI.KEY_X){
			running=false;
			return Extension.BREAK_AND_REMOVE_EXTENSION; 
		}
		return Extension.CONTINUE;
	}

});

registerExtension('PADrend_KeyPressed',recorder->recorder.onKeyPressed);

// make step after drawing the gui
registerExtension('PADrend_AfterFrame',recorder->recorder.step);

// or make step before draing the gui
//registerExtension('PADrend_AfterRendering',recorder->recorder.step);
