// Copyright (c) 2013 Zipline Games, Inc. All Rights Reserved.
// http://getmoai.com

#ifndef MOAITRIGGERSENSOR_H
#define MOAITRIGGERSENSOR_H

#include <moai-sim/MOAISensor.h>

//================================================================//
// MOAITriggerSensor
//================================================================//
/**	@name	MOAITriggerSensor
	@text	Hardware wheel sensor.
*/
class MOAITriggerSensor :
	public MOAISensor {
private:

	float mValue;
	float mDelta;

	MOAILuaRef mCallback;

	//----------------------------------------------------------------//
	static int	_getValue		( lua_State* L );
	static int	_getDelta		( lua_State* L );
	static int	_setCallback	( lua_State* L );

public:

	DECL_LUA_FACTORY ( MOAITriggerSensor )

	//----------------------------------------------------------------//
	void			HandleEvent				( ZLStream& eventStream );
					MOAITriggerSensor		();
					~MOAITriggerSensor		();
	void			RegisterLuaClass		( MOAILuaState& state );
	void			RegisterLuaFuncs		( MOAILuaState& state );

	void			Reset					();

	static void		WriteEvent				( ZLStream& eventStream, float heading );
};

#endif
