// Copyright (c) 2010-2011 Zipline Games, Inc. All Rights Reserved.
// http://getmoai.com

#include "pch.h"
#include <stdio.h>
#include <string.h>
#include <assert.h>

#include <zl-util/ZLLog.h>

#ifdef ANDROID
	#include <android/log.h>
#endif

//================================================================//
// ZLLog
//================================================================//

ZLFILE* ZLLog::CONSOLE = (void *)0L;

//----------------------------------------------------------------//
void ZLLog::PrintFileV ( ZLFILE* file, cc8* format, va_list args ) {

	if ( file ) {
		vfprintf ( (FILE*)file, format, args );
	}
	else {
#ifdef ANDROID
		__android_log_vprint(ANDROID_LOG_INFO,"MoaiLog", format, args);
#else
		vprintf ( format, args );
#endif
	}
}

//----------------------------------------------------------------//
void ZLLog::PrintFile ( ZLFILE* file, cc8* format, ... ) {

	va_list args;
	va_start ( args, format );
	PrintFileV ( file, format, args );
	va_end ( args );
}

//----------------------------------------------------------------//
void ZLLog::Print ( cc8* format, ... ) {

	va_list args;
	va_start ( args, format );
	PrintFileV ( 0L, format, args );
	va_end ( args );
}

