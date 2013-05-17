#================================================================#
# Copyright (c) 2010-2011 Zipline Games, Inc.
# All Rights Reserved.
# http://getmoai.com
#================================================================#

	include $(CLEAR_VARS)

	LOCAL_MODULE 		:= zl-gfx
	LOCAL_ARM_MODE 		:= $(MY_ARM_MODE)
	LOCAL_CFLAGS		:= -DUSE_OPENGLES1=1 -include $(MY_MOAI_ROOT)/src/zl-vfs/zl_replace.h

	LOCAL_C_INCLUDES 	:= $(MY_HEADER_SEARCH_PATHS)
	LOCAL_SRC_FILES 	+= $(MY_MOAI_ROOT)/src/zl-gfx/pch.cpp
	LOCAL_SRC_FILES 	+= $(MY_MOAI_ROOT)/src/zl-gfx/zl_gfx_opengl.cpp

	include $(BUILD_STATIC_LIBRARY)
