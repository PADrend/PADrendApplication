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
/* AddHeader.escript (2011-11)
	Correct line endings, use tabs instead of spaces and add a customized header
*/


var w = gui.createPopupWindow(300,300,"Add code header/correct line endings");

w.addOption("- Correct line endings" );
w.addOption("- Replace spaces by tabs" );
w.addOption("- Add or update header" );
w.addOption("----" );

var config = new ExtObject({
	$endings : PADrend.configCache.getValue("SourceHeader.endings",".h,.cpp,.escript"),
	$folder : PADrend.configCache.getValue("SourceHeader.folder","./src/Geometry"),
	$doUpdateHeader : PADrend.configCache.getValue("SourceHeader.updateHeader",false),
	$headerName : PADrend.configCache.getValue("SourceHeader.headerName","header.txt"),
});

w.addOption({
		GUI.TYPE : GUI.TYPE_TEXT, //! \todo use 
		GUI.LABEL : "root folder",
		GUI.DATA_OBJECT : config,
		GUI.DATA_ATTRIBUTE : $folder,
		GUI.ON_DATA_CHANGED : fn(data){	PADrend.configCache.setValue("SourceHeader.folder",data);	},
		GUI.OPTIONS : ["./src"],
		GUI.ENDINGS : [],
		GUI.TOOLTIP : "All files in this folder (having the proper ending) are inspected recursively."
});

w.addOption({
		GUI.TYPE : GUI.TYPE_TEXT,
		GUI.LABEL : "endings",
		GUI.DATA_OBJECT : config,
		GUI.DATA_ATTRIBUTE : $endings,
		GUI.OPTIONS : [".h,.cpp,.escript"],
		GUI.TOOLTIP : "comma separated list of inspected file endings. E.g. '.h,.cpp'"
});

w.addOption({
		GUI.TYPE : GUI.TYPE_BOOL,
		GUI.LABEL : "update/add header",
		GUI.DATA_OBJECT : config,
		GUI.DATA_ATTRIBUTE : $doUpdateHeader,
		GUI.ON_DATA_CHANGED : fn(data){	PADrend.configCache.setValue("SourceHeader.updateHeader",data);	},
		GUI.TOOLTIP : "If checked and a header file is found,\nand the file does not begin with a custom header (/* ... */),\n"+
		"then the content of the header file is added to \n the file's header or an exisiting header is updated."
});

w.addOption({
		GUI.TYPE : GUI.TYPE_TEXT,
		GUI.LABEL : "header filename",
		GUI.DATA_OBJECT : config,
		GUI.DATA_ATTRIBUTE : $headerName,
		GUI.ON_DATA_CHANGED : fn(data){	PADrend.configCache.setValue("SourceHeader.headerName",data);	},
		GUI.OPTIONS : ["header.txt"],
		GUI.TOOLTIP : "The filename of a headerfile.\n"+
		" - The file is searched recursively for each updated file.\n"+
		" - The header file's lines must all begin with '// ' \n"+
		" - If the header file contains '[file]', it is replaced by the actual filename. \n"+
		" - The header file should end with a linebreak"
});


w.addAction("Execute",
(fn(config){
	print_r(config._getAttributes());

	var rootDir=config.folder;

	if(!rootDir){
		return;
	}
	
	var stats = {
		'#InspectedFiles' : 0,
		'#CustomHeadersFound' : 0,
		'#UpdatedFiles' : 0,
		'UpdatedFiles' : [],
		'#UnchangedFiles' : 0,
		'UnchangedFiles' : []
	};

	var files=IO.dir( rootDir , IO.DIR_FILES|IO.DIR_RECURSIVE );
	var endings = config.endings.split(",");
	files.filter( [endings] => fn(endings, filename){
		foreach(endings as var e){
			if(filename.endsWith(e))
				return true;
		}
		return false; 
	} );

	var lineEnding="\n";

	foreach(files as var file){
//		out(file,"\t");
		++stats['#InspectedFiles'];

		var doUpdateHeader = config.doUpdateHeader;
		
		var header = false;
		if(doUpdateHeader){
			doUpdateHeader = false;

			var parts = file.split("/");
			parts.popBack();
			while(!parts.empty()){
				var headerFile = parts.implode("/")+"/"+config.headerName;
				if(IO.isFile(headerFile)){
					header = IO.fileGetContents(headerFile);
//					out("(Header:'",headerFile,"')");
					doUpdateHeader = true;
					break;
				}
				parts.popBack();
			}
		}

		var input=IO.fileGetContents(file); // read file

		// extract lines
		var lines=input.split("\n");
		if(lines.empty()){
//			out("empty\n");
			continue;
		}

		var output="";
		var headerRead=false;
		
		// other header given? -> skip
		if(lines[0].beginsWith("/*")){ 
			headerRead=true;
			++stats['#CustomHeadersFound'];
		}else if(doUpdateHeader){
			var replace = {
				'[file]' : file.substr(file.rFind("/")+1)
			};
			output+=header.replaceAll(replace);
		}

		// remove additional end lines
		while(lines.back().trim().empty()){
			lines.popBack();
		}
		// process lines
		foreach(lines as var line){
			// ignore old header
			if(doUpdateHeader && !headerRead && line.beginsWith("// "))
				continue;
			headerRead = true;

			// remove whitespaces at the end and replace whitespaces at the beginnen by tabs.
			line = line.rTrim();
			if(line.beginsWith(" ")||line.beginsWith("\t")){
				var spaceCount=0;
				var tabCount=0;
				for(var pos=0; true ; ++pos){
					var c=line[pos];
					if(c==" "){
						++spaceCount;
						if(spaceCount==4){
							++tabCount;
							spaceCount=0;
						}
					}else if(c=="\t"){
						++tabCount;
					}else{
						break;
					}
				}
				line = "\t"*tabCount + " " * spaceCount + line.lTrim();
			}
			output+=line+lineEnding;
		}
		if(output!=input) {
			IO.filePutContents(file, output);
			++stats['#UpdatedFiles'];
			stats['UpdatedFiles'] += file;
		} else {
			++stats['#UnchangedFiles'];
			stats['UnchangedFiles'] += file;
		}
	}
	print_r(stats);
	out("Bye!\n");
}).bindLastParams(config));

w.addAction("End");

w.init();
