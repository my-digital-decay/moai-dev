// Copyright (c) 2010-2011 Zipline Games, Inc. All Rights Reserved.
// http://getmoai.com

#ifndef ZLLOG_H
#define ZLLOG_H

#include <zl-vfs/headers.h>

//================================================================//
// ZLLog
//================================================================//
class ZLLog {

public:
	static ZLFILE* CONSOLE;

	//----------------------------------------------------------------//
	static void	PrintFileV	( ZLFILE* file, cc8* format, va_list args );
	static void	PrintFile	( ZLFILE* file, cc8* format, ... );
	static void	Print		( cc8* format, ... );
};

#endif
