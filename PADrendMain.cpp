/*
 * This file is part of the open source part of the
 * Platform for Algorithm Development and Rendering (PADrend).
 * Web page: http://www.padrend.de/
 * Copyright (C) 2008-2013 Benjamin Eikel <benjamin@eikel.org>
 * Copyright (C) 2007-2015 Claudius Jähn <claudius@uni-paderborn.de>
 * Copyright (C) 2009-2011 Ralf Petring <ralf@petring.net>
 * 
 * PADrend consists of an open source part and a proprietary part.
 * The open source part of PADrend is subject to the terms of the Mozilla
 * Public License, v. 2.0. You should have received a copy of the MPL along
 * with this library; see the file LICENSE. If not, you can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */
#define OBJECTDEBUG
#include <E_Geometry/ELibGeometry.h>
#include <E_MinSG/ELibMinSG.h>
#include <E_GUI/ELibGUI.h>
#include <E_Util/ELibUtil.h>
#include <E_Rendering/ELibRendering.h>
#include <EScript/EScript.h>

// [Serial Port support]
// Win32 only
#ifdef LIB_E_SERIAL_PORT
#include <E_SerialPort/E_SerialPort.h>
#endif

// [ARToolkit]
#ifdef LIB_ARTOOLKIT
#include <E_ARToolKit/ELibARToolkit.h>
#endif // LIB_ARTOOLKIT

// [Sound]
#ifdef PADREND_HAVE_LIB_E_SOUND
#include <E_Sound/ELibSound.h>
#endif /* PADREND_HAVE_LIB_E_SOUND */

// [VideoLib]
// Based on ffmpeg
#ifdef LIB_VIDEOLIB
#include <E_VideoLib/E_VideoLib.h>
#endif // LIB_ARTOOLKIT

// ---

#if defined(__APPLE__)
#include <SDL.h>
#endif

#include <Util/Util.h>
#include <Util/LibRegistry.h>
#include <Util/IO/FileLocator.h>
#include <Util/IO/FileName.h>
#include <cstdlib>
#include <iostream>
#include <string>

#if defined(__linux__)
#include <signal.h>

static void signalHandler(int signalNumber) {
	if(signalNumber == SIGUSR1) {
		std::cout << "Received signal SIGUSR1. Shutting down." << std::endl;
		exit(EXIT_SUCCESS);
	}
}
#endif

using namespace EScript;

/**
 * The main function initializes the needed libraries and starts interpreting the script
 * <tt>./plugins/main.escript</tt>.
 *
 * @return Always @c EXIT_SUCCESS.
 */
int main(int argc, char *argv[]) {

#if defined(__linux__)
	struct sigaction action;
	action.sa_flags = 0;
	sigemptyset(&action.sa_mask);
	action.sa_handler = &signalHandler;
	/*
	 * SIGINT is caught by SDL already.
	 * Use SIGUSR1 to gracefully shut down this application when the event loop
	 * is blocked by a running function and does not react to other signals.
	 */
	sigaction(SIGUSR1, &action, nullptr);
#endif

	// -----------------------------------------------------------
	// init Util
	Util::init();
	
	// -----------------------------------------------------------
	// init EScript
	Util::LibRegistry::registerLibVersionString("EScript",ES_VERSION_STRING); 
	EScript::init();
	// init Libraries
	EScript::initLibrary(E_Util::init);
	EScript::initLibrary(E_Geometry::init);
	EScript::initLibrary(E_Rendering::init);
	EScript::initLibrary(E_MinSG::init);
	EScript::initLibrary(E_GUI::init);

#ifdef LIB_E_SERIAL_PORT
	EScript::initLibrary(E_SerialPort::init);
#endif // LIB_E_SERIAL_PORT

#ifdef PADREND_HAVE_LIB_E_SOUND
	EScript::initLibrary(E_Sound::init);
#endif // /* PADREND_HAVE_LIB_E_SOUND */

#ifdef LIB_ARTOOLKIT
	EScript::initLibrary(E_ARToolKit::init);
#endif // LIB_ARTOOLKIT

#ifdef LIB_VIDEOLIB
	EScript::initLibrary(E_VideoLib::init);
#endif // LIB_VIDEOLIB
	//	Debug::clearObjects();

	// -----------------------------------------------------------

	ERef<Runtime> rt(new Runtime);

	declareConstant(rt->getGlobals(), "args", Array::create(static_cast<std::size_t>(argc), argv));

	std::string mainScript("./plugins/main.escript");
	for(int i = 0; i < argc; ++i) {
		const std::string arg(argv[i]);
		if(arg.compare(0, 9, "--script=") == 0)
			mainScript = arg.substr(9);
	}
	
	// pass some values to the script
	declareConstant(rt->getGlobals(),"SIZE_OF_PTR", Number::create(sizeof(void*)));
#ifdef NDEBUG
	declareConstant(rt->getGlobals(),"BUILD_TYPE", String::create("release"));
#else
	declareConstant(rt->getGlobals(),"BUILD_TYPE", String::create("debug"));
#endif

	Util::FileLocator locator;
	locator.addSearchPath("./");
	locator.addSearchPath("./share/PADrend/");
	#if defined(__linux__)	
		locator.addSearchPath("/usr/local/share/PADrend/");
		locator.addSearchPath("/usr/share/PADrend/");	
	#elif defined(_WIN32)	
		locator.addSearchPath("C:/Program Files/PADrendComplete/share/PADrend/");
		locator.addSearchPath("C:/Program Files (x86)/PADrendComplete/share/PADrend/");
		locator.addSearchPath("C:/Program Files/PADrend/share/PADrend/");
		locator.addSearchPath("C:/Program Files (x86)/PADrend/share/PADrend/");
	#elif defined(__APPLE__)
		// Where does apple store applications by default?
	#endif
	auto file = locator.locateFile(Util::FileName(mainScript));
	
	if(!file.first) {
		std::cout <<"ERROR: Could not locate 'main.escript'" << std::endl;
		return EXIT_FAILURE;
	}

	// --- Load and execute script
	std::pair<bool,ObjRef> result = EScript::loadAndExecute(*rt.get(), file.second.getPath());

	// --- output result
	if(result.second)
		std::cout << "\n\n --- "<<"\nResult: " << result.second.toString()<< std::endl;

	rt=nullptr;
//	Debug::showObjects();

	if(result.first){
		std::cout <<" \nBYE."<< std::endl;
		return EXIT_SUCCESS;
	}else{
		std::cout <<" \nFAILURE."<< std::endl;
		return EXIT_FAILURE;
	}

}
