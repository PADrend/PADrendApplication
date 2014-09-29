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
/*! Modify a Code::Blocks Project file (.cbp)
	- remove deleted source files
	- add new source files

	2010-03-26 Claudius
*/

static XML_Utils = Std.require('LibUtilExt/XML_Utils');

var w = gui.createPopupWindow(300,100,"Code::Blocks project updater");
w.addOption({
		GUI.TYPE : GUI.TYPE_FILE,
		GUI.LABEL : "ProjectFile",
		GUI.DATA_PROVIDER : fn(){	
			return PADrend.configCache.getValue("CodeBlocksUpdater.projectFile","./src/SWalkthrough.cbp");	
		},
		GUI.ON_DATA_CHANGED : fn(data){	
			PADrend.configCache.setValue("CodeBlocksUpdater.projectFile",data);	
		},
		GUI.ENDINGS : [".cbp"]
});
w.addOption({
		GUI.TYPE : GUI.TYPE_BOOL,
		GUI.LABEL : "useBackslashes",
		GUI.DATA_PROVIDER : fn(){	
			return PADrend.configCache.getValue("CodeBlocksUpdater.useBackslashes",true);	
		},
		GUI.ON_DATA_CHANGED : fn(data){	
			PADrend.configCache.setValue("CodeBlocksUpdater.useBackslashes",data);	
		},
		GUI.ENDINGS : [".cbp"]
});

w.addAction("Go!",fn(){

	// parameters
	var projectFile = PADrend.configCache.getValue("CodeBlocksUpdater.projectFile");
	var useBackslashes = PADrend.configCache.getValue("CodeBlocksUpdater.useBackslashes",true);
	var doAddEndings = { ".cpp":true , ".h":true, ".escript":true , ".vs":true , ".fs":true , ".json":true };
	var doNotAddFilter = ["EScript","resources","Data","libs","tmp\\","tmp/","E_ARToolKit"]; 

	// internal data
	var data = new ExtObject({
		$files : new Map(), // file -> marker (0...file exists | 1...file exists and should be added)
		$numChanges : 0
	});

	out("\n","-"*10,"\nScanning files...\n");
	foreach(IO.dir(".",IO.DIR_FILES|IO.DIR_RECURSIVE) as var f){
		if(useBackslashes)
			f = f.replaceAll({"/":"\\"}); // windows slash to backslash
		f = f.substr(2); // remove "./"
		if(f.beginsWith("src\\"))
			f = f.substr(4); // remove "src/"
		else
			f = "..\\"+f;
		
		// check if file should be added if is not already in the project
		var addFile = true;
		var pointPos = f.rFind(".");
		var ending = pointPos ? f.substr( pointPos-f.length() ) : "";

		if(!doAddEndings[ending]){
			addFile = false;
		}else{
			foreach(doNotAddFilter as var filter){
				if(f.contains(filter)){
					addFile = false;
				}
			}
		}
		data.files[f] = addFile ? 1 : 0;
	}
	out("Scanned files: ",data.files.count(),"\n");

	out("Parsing Code::Blocks project '",projectFile,"'\n");
	var root = XML_Utils.loadXML(projectFile);

	out("Changes:\n");
	root[XML_Utils.XML_CHILDREN].filter( [data] => fn(data,tag){
		var tagName = tag[XML_Utils.XML_NAME];
		// remove 'Units' with invalid files and mark valid files as found.
		if(tagName == "Unit"){
			var filename = tag[XML_Utils.XML_ATTRIBUTES]["filename"];
			if(data.files[filename]){
				--data.files[filename]; // file already in project
			}else{
				out("- ",filename,"\n");
				++data.numChanges;
				return false;
			}
		}
		// execute recursively on children
		if(tag[XML_Utils.XML_CHILDREN])
			tag[XML_Utils.XML_CHILDREN].filter( [data]=>thisFn );
		// before leaving the 'Project' tag; add the missing files.
		if(tagName=="Project"){
			foreach(data.files as var filename,var marker){
				if(marker>0){
					out("+ ",filename,"\n");
					++data.numChanges;
					tag[XML_Utils.XML_CHILDREN]+={
						XML_Utils.XML_NAME : "Unit",
						XML_Utils.XML_ATTRIBUTES : { "filename" : filename}
					};
				}
			}
		}
		return true;	
	});

	if(data.numChanges==0){
		out("No Changes!\n");
	}else{
		out("Updating project file.\n");
		// store a backup
		Util.saveFile(projectFile+".bak",Util.loadFile(projectFile));
		XML_Utils.saveXML(projectFile,root);
	}
});

w.addAction("Cancel");

w.init();
return;
