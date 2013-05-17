#================================================================#
# Copyright (c) 2010-2011 Zipline Games, Inc.
# All Rights Reserved.
# http://getmoai.com
#================================================================#

	include $(CLEAR_VARS)

	LOCAL_MODULE 		:= moai-fmod-ex
	LOCAL_ARM_MODE 		:= $(MY_ARM_MODE)
	LOCAL_CFLAGS		:= -include $(MY_MOAI_ROOT)/src/zl-vfs/zl_replace.h

	LOCAL_C_INCLUDES 	:= $(MY_HEADER_SEARCH_PATHS)
	LOCAL_SRC_FILES 	+= $(MY_MOAI_ROOT)/src/moai-fmod-ex/host.cpp
	LOCAL_SRC_FILES 	+= $(MY_MOAI_ROOT)/src/moai-fmod-ex/MOAIFmodEx.cpp
	LOCAL_SRC_FILES 	+= $(MY_MOAI_ROOT)/src/moai-fmod-ex/MOAIFmodExChannel.cpp
	LOCAL_SRC_FILES 	+= $(MY_MOAI_ROOT)/src/moai-fmod-ex/MOAIFmodExSound.cpp

	include $(BUILD_STATIC_LIBRARY)
