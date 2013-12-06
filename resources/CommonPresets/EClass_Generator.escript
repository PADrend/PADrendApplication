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

var w = gui.createPopupWindow(500,300,"EReference Class creator v1.0");

var defaultConfig = {
		$cHeaderFile : "object.h",
		$cNamespace : "MinSG",
		$cClassName : "cClassName",

		$eNamespace : "E_[cNamespace]",
		$eClassName : "E_[cClassName]",
		$refType : "EScript::ReferenceObject<[fullClassName]>" ,
		$eBaseTypeObject : "EScript::Object::getTypeObject()",
		$outputDirectory : "src/",
		$extGuard : "",
		$addExampleFunctions : true,
		$guessMethods : false,
		$clonable : false,
		$specifyToString : false,
		$hasDefaultConstructor : true
};

var data = new ExtObject(PADrend.configCache.getValue("E_ClassGenerator",defaultConfig));
foreach(defaultConfig as var key,var value){
	if(!data.isSet(key))
		data.setAttribute(key,value);
}

w.addOption({
	GUI.TYPE : GUI.TYPE_TEXT,
	GUI.LABEL : "cClassName",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $cClassName
});
w.addOption({
	GUI.TYPE : GUI.TYPE_TEXT,
	GUI.LABEL : "cNamespace",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $cNamespace,
	GUI.OPTIONS : ["Geometry","GUI","MinSG","OpenGL","SDL","Util"],
	GUI.TOOLTIP : "Nested namspaces are possible. E.g. 'Ns1::Ns2::Ns3' "
});
w.addOption({
	GUI.TYPE : GUI.TYPE_FILE,
	GUI.ENDINGS : [ ".h" ],
	GUI.DIR : "src/",
	GUI.LABEL : "cHeaderFile",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $cHeaderFile
});
w.addOption("----");
w.addOption({
	GUI.TYPE : GUI.TYPE_TEXT,
	GUI.LABEL : "eClassName",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $eClassName,
	GUI.OPTIONS : ["E_[cClassName]"],
});

w.addOption({
	GUI.TYPE : GUI.TYPE_TEXT,
	GUI.LABEL : "eNamespace",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $eNamespace,
	GUI.OPTIONS : ["E_[cNamespace]","E_Geometry","E_GUI","E_MinSG","E_OpenGL","E_SDL","E_Util"],
	GUI.TOOLTIP : "Nested namspaces are possible. E.g. 'E_Ns1::E_Ns2::E_Ns3' "
});
w.addOption({
	GUI.TYPE : GUI.TYPE_TEXT, // \todo  change to TYPE_DIR when available
	GUI.LABEL : "outputDirectory",
	GUI.ENDINGS : [ ],
	GUI.DIR : "src/",	
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $outputDirectory
});



w.addOption({
	GUI.TYPE : GUI.TYPE_TEXT,
	GUI.LABEL : "extGuard",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $extGuard,
	GUI.OPTIONS : ["","MINSG_EXT_"]
});

w.addOption({
	GUI.TYPE : GUI.TYPE_TEXT,
	GUI.LABEL : "refType",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $refType,
	GUI.OPTIONS : ["EScript::ReferenceObject<[fullClassName]>","EScript::ReferenceObject<Util::Reference<[fullClassName]> >","E_Node","E_State"]
});
w.addOption({
	GUI.TYPE : GUI.TYPE_TEXT,
	GUI.LABEL : "eBaseTypeObject",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $eBaseTypeObject,
	GUI.OPTIONS : ["EScript::Object::getTypeObject()","E_Node::getTypeObject()","E_State::getTypeObject()"]
});


w.addOption({
	GUI.TYPE : GUI.TYPE_BOOL,
	GUI.LABEL : "hasDefaultConstructor",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $hasDefaultConstructor,
	GUI.TOOLTIP : "Set true if the class has an empty constructor."
});

w.addOption({
	GUI.TYPE : GUI.TYPE_BOOL,
	GUI.LABEL : "clonable",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $clonable,
	GUI.TOOLTIP : "Set true if the class has an copy constructor and should be clonable."
});

w.addOption({
	GUI.TYPE : GUI.TYPE_BOOL,
	GUI.LABEL : "toString",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $specifyToString
});

w.addOption({
	GUI.TYPE : GUI.TYPE_BOOL,
	GUI.LABEL : "add some template functions to init(...)",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $addExampleFunctions
});



w.addOption({
	GUI.TYPE : GUI.TYPE_BOOL,
	GUI.LABEL : "guessMethods",
	GUI.DATA_OBJECT : data,
	GUI.DATA_ATTRIBUTE : $guessMethods
});

var generate = fn(data){
	PADrend.configCache.setValue("E_ClassGenerator",data._getAttributes());
//	print_r(data._getAttributes());
	
	data.extGuardBegin := data.extGuard.empty() ? "" : "#ifdef "+data.extGuard+"\n" ;
	data.extGuardEnd := data.extGuard.empty() ? "" : "#endif // "+data.extGuard+"\n" ;
	data.includeString := data.specifyToString ? "#include <string>\n" : "";
//	data.eClassName := "E_"+data.cClassName;
	
	data.fullClassName := data.cNamespace.empty() ? data.cClassName : (data.cNamespace + "::"+data.cClassName) ;
	
	data.superConstructorName := data.refType.contains("ReferenceObject") ? "ReferenceObject_t" : refType;
	
	data.headerGuard := "[eClassName]_H_";
	
	
	var searchReplace = new Map();
	foreach(data._getAttributes() as var key,var value)
		searchReplace[ '['+key+']' ] = value;
	
	
	// replace inside replace map; make some iterations to trivially and inefficiently handle replacements over several hops.
	for(var i=0;i<10;++i){
		var m2=new Map();
		foreach(searchReplace as var key,var value)
			m2[key]= (""+value).replaceAll(searchReplace);
		searchReplace.swap(m2);
	}
	
	// build header guard and namespace expression
	{	
		searchReplace['[eNamespaceBegin]'] = "";
		searchReplace['[eNamespaceEnd]'] = "";
		
		var headerPrefix="";
		foreach(searchReplace['[eNamespace]'].split("::") as var part){
			searchReplace['[eNamespaceBegin]'] += "namespace "+part+"{\n";
			headerPrefix += part+"_";
			searchReplace['[eNamespaceEnd]'] += "}\n";
		}
		searchReplace['[headerGuard]'] = (headerPrefix+searchReplace['[headerGuard]']).toUpper();;
	}
	
	// strip leading "src/" from include.
	if(searchReplace['[cHeaderFile]'].beginsWith("src/"))
		searchReplace['[cHeaderFile]'] = searchReplace['[cHeaderFile]'].substr(4);
	
	
//	print_r(searchReplace);
	var guessedMethods = "";
	if(data.guessMethods){
			
		var methodCollection = new Map();
			
		var cHeaderContent = IO.fileGetContents(data.cHeaderFile);
		var lines = cHeaderContent.split("\n");
		foreach(lines as var line){
			line = line.trim();
			if(!line.contains("(") || line.contains("~") )
				continue;
			
			if(line.endsWith(";")){
				line = line.substr(0,-1).trim();
			}
			if(line.endsWith("}")){
				line = line.substr(0,line.find("{")).trim();
			}
//			out("> ", line,"\n");
			
			var isConst = line.endsWith("const");
			var returnsVoid = line.substr(0,line.find("(")+1).contains("void");
			var funName = line.substr(0,line.find("("));
			funName = funName.substr(funName.rFind(" ")).trim();
			var isStatic = line.beginsWith("static");
			var isConstructor = funName==data.cClassName;

			var p = line.substr(line.find("(")+1).trim();
			p=p.substr(0,p.find(")")).trim();
			var maxParamCount = p.split(",").count();
			var minParamCount = maxParamCount - [p.split("=").count()-1,0].max();

			var s = "	// "+line+"\n";
			if(isConstructor){
				s+="	//! [ESF] new ";
			}else {
				if(isStatic){
					s+="	//! [ESF] ";
					if(returnsVoid){
						s+="Void ";
					}else{
						s+="RESULT ";
					}
				}
				else{
					s+="	//! [ESMF] ";
					if(returnsVoid){
						s+="self ";
					}else{
						s+="RESULT ";
					}
				}
				s+=data.cClassName+".";
			}
			s+=funName+"(";
			for(var i=0;i<maxParamCount;++i){
				if(i>=minParamCount)
					s+="[";
				if(i>0)
					s+=",";
				s+="p"+i;
			}
			s+="]"*(maxParamCount-minParamCount);
			s+=")\n";
			s+="	";
			var end="";
			if(isConstructor){
				s+="ES_CTOR(typeObject,"+minParamCount+","+maxParamCount+",\n";
				s+="				new "+data.eClassName+"(";
				end="))";
				funName = "_constructor"; // for sorting!
			}else if(isStatic){
				s+="ES_FUN(typeObject,\""+funName+"\","+minParamCount+","+maxParamCount+",\n";
				s+="				EScript::create("+data.cNamespace+"::"+data.cClassName+"::"+funName+"(";
				end=")))";
			}else{
				s+="ES_MFUN(typeObject,";
				if(isConst)
					s+="const ";
				s+=data.eClassName+",\""+funName+"\","+minParamCount+","+maxParamCount+",\n";
				s+="				";
				if(returnsVoid){
					s+="(";
					end="),thisEObj))";
				}else{
					s+="EScript::create(";
					end=")))";
				}
					
				s+="thisObj->"+funName+"(";
				for(var i=0;i<maxParamCount;++i){
					if(i>0)
						s+=",";
					s+="parameter["+i+"].to<XXX>(rt)";
				}
			}
			s+=end;
			s+="\n\n";
//			out(s);
			methodCollection[funName]=s;

//			out("# ",numParam,"\n");
		}
		// add sorted methods 
		foreach(methodCollection as var s)
			guessedMethods+=s;
	}
	
	var header = 
R""([extGuardBegin]
#ifndef [headerGuard]
#define [headerGuard]

#include <EScript/Objects/ReferenceObject.h>
#include <[cHeaderFile]>
[includeString]

namespace EScript {
class Namespace;
class Type;
}
[eNamespaceBegin]

/*!	EScript wrapper class for [fullClassName]

		[eClassName] ---|> [refType]
			|
			--------------> [fullClassName]		*/
class [eClassName] : public [refType] {
		ES_PROVIDES_TYPE_NAME([cClassName])
	public:
		static EScript::Type * getTypeObject();
		static void init(EScript::Namespace & lib);

)"" +
	(data.hasDefaultConstructor ? 
	"		[eClassName](EScript::Type * type=nullptr) : \n"
	"				[superConstructorName]([fullClassName](), type ? type : [eClassName]::getTypeObject()) {}\n" :"") +
	
	"		[eClassName](const [fullClassName] & _obj,EScript::Type * type=nullptr) : \n"
	"				[superConstructorName](_obj, type ? type : [eClassName]::getTypeObject()) {}\n"
	"		virtual ~[eClassName]() {}\n"
	"\n"+
	(data.clonable ? 
	"		/// ---|> [Object]\n"
	"		virtual [eClassName] * clone()const		{	return new [eClassName](ref());	}\n" : "")+
	(data.specifyToString ? 
	"		/// ---|> [Object]\n"
	"		virtual std::string toString()const		{	return ref().toString();	}\n" : "")+
	
R""(};
[eNamespaceEnd]

ES_CONV_EOBJ_TO_OBJ([eNamespace]::[eClassName],	[fullClassName]*, 			(**eObj).get())
ES_CONV_OBJ_TO_EOBJ([fullClassName] *,			[eNamespace]::[eClassName],	obj?new [eNamespace]::[eClassName](obj) : nullptr)

#endif // [headerGuard]
[extGuardEnd]
)"";
		
	var body =
R""([extGuardBegin]
#include "[eClassName].h"
#include <EScript/Basics.h>
#include <EScript/StdObjects.h>

[eNamespaceBegin]

//! (static)
EScript::Type * [eClassName]::getTypeObject() {
	// [eClassName] ---|> Object
	static EScript::ERef<EScript::Type> typeObject = new EScript::Type([eBaseTypeObject]);
	return typeObject.get();
}

//! (static) init members 
void [eClassName]::init(EScript::Namespace & lib) {
	EScript::Type * typeObject = [eClassName]::getTypeObject();
	declareConstant(&lib,getClassName(),typeObject);

	using namespace [cNamespace];
	
	//!	[ESMF] [cClassName] new [cClassName]()
	ES_CTOR(typeObject,0,0,new [eClassName](thisType))
)"" +

	(data.addExampleFunctions ? 
	"\n"+
	"	//!	[ESMF] Number [cClassName].getFoo()\n"
	"	ES_MFUN(typeObject,const [cClassName],\"getFoo\",0,0,\n"
	"			EScript::create(thisObj->getFoo()))\n"
	"\n"
	"	//!	[ESMF] self [cClassName].setFoo(Number foo)\n"
	"	ES_MFUN(typeObject,[cClassName],\"setFoo\",1,1,(\n"
	"			EScript::create(thisObj->setFoo(parameter[0].to<float>(rt),thisEObj))))\n" : "")+
	guessedMethods+
	
R""(	// \todo Insert into ELibXXX.cpp:
	//		[extGuardBegin]
	//		#include "[eClassName].h"
	//		[extGuardEnd]
	//		...
	//		[eClassName]::init(*lib);
[eNamespaceEnd]
}
[extGuardEnd]
)"";

	header = header.replaceAll(searchReplace);
	body = body.replaceAll(searchReplace);
	
	var filename = (data.outputDirectory+"/"+data.eClassName).replaceAll(searchReplace);
	
//	out("\n","-"*10,filename+".h");
//	out(header);
//	out("\n","-"*10,filename+".cpp");
//	out(body);
	out("\nGenerating files...\n");
	out(filename+".h\t"+IO.filePutContents(filename+".h",header),"\n");
	out(filename+".cpp\t"+IO.filePutContents(filename+".cpp",body),"\n");
	
//	out("\n"*5,header);
	out("\n");

};

w.addAction("Generate",generate.bindLastParams(data));
w.addAction("End",data->fn(){PADrend.configCache.setValue("E_ClassGenerator",this._getAttributes()); },"Store settings and close window"  );
w.addAction("Reset",data->fn(){PADrend.configCache.unsetValue("E_ClassGenerator"); },"Reset settings to default values."  );
w.addAction("Cancel",void,"Discard changes and close window");

w.init();
