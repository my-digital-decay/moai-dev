// Copyright (c) 2010-2011 Zipline Games, Inc. All Rights Reserved.
// http://getmoai.com

#include "pch.h"
#include <moai-sim/MOAIBoundsDeck.h>
#include <moai-sim/MOAIDeck.h>
#include <moai-sim/MOAIDeckRemapper.h>
#include <moai-sim/MOAIGfxDevice.h>
#include <moai-sim/MOAIGfxResource.h>
#include <moai-sim/MOAIGrid.h>
#include <moai-sim/MOAIMultiTexture.h>
#include <moai-sim/MOAIShader.h>
#include <moai-sim/MOAIShaderMgr.h>
#include <moai-sim/MOAISurfaceSampler2D.h>
#include <moai-sim/MOAITexture.h>
#include <moai-sim/MOAITextureBase.h>
#include <moai-sim/MOAITransform.h>

//================================================================//
// MOAIDeckGfxState
//================================================================//

//----------------------------------------------------------------//
MOAIDeckGfxState::MOAIDeckGfxState () :
	mShader ( 0 ),
	mTexture ( 0 ) {
}

//----------------------------------------------------------------//
void MOAIDeckGfxState::Reset () {
	this->mShader = 0;
	this->mTexture = 0;
}

//----------------------------------------------------------------//
void MOAIDeckGfxState::SetShader ( MOAIGfxState* shader ) {

	if ( shader ) {
		this->mShader = shader;
	}
}

//----------------------------------------------------------------//
void MOAIDeckGfxState::SetTexture ( MOAIGfxState* texture ) {

	if ( texture ) {
		this->mTexture = texture;
	}
}

//================================================================//
// local
//================================================================//

//----------------------------------------------------------------//
/**	@name	setBoundsDeck
	@text	Set or clear the bounds override deck.
	
	@in		MOAIDeck self
	@opt	MOAIBoundsDeck boundsDeck
	@out	nil
*/
int MOAIDeck::_setBoundsDeck ( lua_State* L ) {
	MOAI_LUA_SETUP ( MOAIDeck, "U" )
	
	self->mBoundsDeck.Set ( *self, state.GetLuaObject < MOAIBoundsDeck >( 2, true ));
	
	return 0;
}

//----------------------------------------------------------------//
/**	@name	setShader
	@text	Set the shader to use if neither the deck item nor the prop specifies a shader.
	
	@in		MOAIDeck self
	@in		MOAIShader shader
	@out	nil
*/
int MOAIDeck::_setShader ( lua_State* L ) {
	MOAI_LUA_SETUP ( MOAIDeck, "UU" )
	
	self->mShader.Set ( *self, state.GetLuaObject < MOAIShader >( 2, true ));
	
	return 0;
}

//----------------------------------------------------------------//
/**	@name	setTexture
	@text	Set or load a texture for this deck.
	
	@in		MOAIDeck self
	@in		variant texture		A MOAITexture, MOAIMultiTexture, MOAIDataBuffer or a path to a texture file
	@opt	number transform	Any bitwise combination of MOAITextureBase.QUANTIZE, MOAITextureBase.TRUECOLOR, MOAITextureBase.PREMULTIPLY_ALPHA
	@out	MOAIGfxState texture
*/
int MOAIDeck::_setTexture ( lua_State* L ) {
	MOAI_LUA_SETUP ( MOAIDeck, "U" )

	MOAIGfxState* texture = MOAITexture::AffirmTexture ( state, 2 );
	self->mTexture.Set ( *self, texture );

	if ( texture ) {
		self->mTexture->PushLuaUserdata ( state );
		return 1;
	}
	return 0;
}

//================================================================//
// MOAIDeck
//================================================================//

//----------------------------------------------------------------//
bool MOAIDeck::Contains ( u32 idx, MOAIDeckRemapper* remapper, const USVec2D& vec ) {
	
	ZLRect bounds = this->GetBounds ( idx, remapper ).GetRect ( ZLBox::PLANE_XY );
	return bounds.Contains ( vec );
}

//----------------------------------------------------------------//
void MOAIDeck::Draw ( u32 idx, MOAIDeckRemapper* remapper ) {

	this->Draw ( idx, remapper, 0.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f );
}

//----------------------------------------------------------------//
void MOAIDeck::Draw ( u32 idx, MOAIDeckRemapper* remapper, float xOff, float yOff, float zOff, float xScl, float yScl, float zScl ) {
	
	idx = remapper ? remapper->Remap ( idx ) : idx;
	
	if ( !idx || ( idx & MOAITileFlags::HIDDEN )) return;
	
	xScl = ( idx & MOAITileFlags::XFLIP ) ? -xScl : xScl;
	yScl = ( idx & MOAITileFlags::YFLIP ) ? -yScl : yScl;
	
	this->DrawIndex ( idx & MOAITileFlags::CODE_MASK, xOff, yOff, zOff, xScl, yScl, zScl );
}

//----------------------------------------------------------------//
void MOAIDeck::DrawIndex ( u32 idx, float xOff, float yOff, float zOff, float xScl, float yScl, float zScl ) {
	UNUSED ( idx );
	UNUSED ( xOff );
	UNUSED ( yOff );
	UNUSED ( zOff );
	UNUSED ( xScl );
	UNUSED ( yScl );
	UNUSED ( zScl );
}

//----------------------------------------------------------------//
ZLBox MOAIDeck::GetBounds () {

	if ( this->mBoundsDirty ) {
		this->mMaxBounds = this->ComputeMaxBounds ();
		
		// flip and expand to account for flip flags
		ZLBox bounds = this->mMaxBounds;
		bounds.Scale ( -1.0f );
		bounds.Bless ();
		
		this->mMaxBounds.Grow ( bounds );
		this->mBoundsDirty = false;
	}
	return this->mMaxBounds;
}

//----------------------------------------------------------------//
ZLBox MOAIDeck::GetBounds ( u32 idx, MOAIDeckRemapper* remapper ) {

	idx = remapper ? remapper->Remap ( idx ) : idx;
	
	ZLBox bounds;
	
	if ( this->mBoundsDeck ) {
		bounds = this->mBoundsDeck->GetItemBounds ( idx & MOAITileFlags::CODE_MASK );
	}
	else {
		bounds = this->GetItemBounds ( idx & MOAITileFlags::CODE_MASK );
	}

	if ( idx & MOAITileFlags::FLIP_MASK ) {

		ZLVec3D scale;
		scale.mX = ( idx & MOAITileFlags::XFLIP ) ? -1.0f : 1.0f;
		scale.mY = ( idx & MOAITileFlags::YFLIP ) ? -1.0f : 1.0f;
		scale.mZ = 1.0f;

		bounds.Scale ( scale );
		bounds.Bless ();
	}
	return bounds;
}

//----------------------------------------------------------------//
void MOAIDeck::GetGfxState ( MOAIDeckGfxState& gfxState ) {

	if ( this->mShader ) {
		gfxState.SetShader ( this->mShader );
	}
	else {
		gfxState.SetShader ( &MOAIShaderMgr::Get ().GetShader ( this->mDefaultShaderID ));
	}
	gfxState.SetTexture ( this->mTexture );
}

//----------------------------------------------------------------//
MOAIDeck::MOAIDeck () :
	mContentMask ( 0xffffffff ),
	mDefaultShaderID ( MOAIShaderMgr::DECK2D_SHADER ),
	mBoundsDirty ( true ) {
	
	RTTI_SINGLE ( MOAILuaObject )
	
	this->mMaxBounds.Init ( 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f );
}

//----------------------------------------------------------------//
MOAIDeck::~MOAIDeck () {

	this->mShader.Set ( *this, 0 );
	this->mTexture.Set ( *this, 0 );
	this->mBoundsDeck.Set ( *this, 0 );
}

//----------------------------------------------------------------//
void MOAIDeck::RegisterLuaClass ( MOAILuaState& state ) {
	UNUSED ( state );
}

//----------------------------------------------------------------//
void MOAIDeck::RegisterLuaFuncs ( MOAILuaState& state ) {

	luaL_Reg regTable [] = {
		{ "setBoundsDeck",			_setBoundsDeck },
		{ "setShader",				_setShader },
		{ "setTexture",				_setTexture },
		{ NULL, NULL }
	};

	luaL_register ( state, 0, regTable );
}

//----------------------------------------------------------------//
void MOAIDeck::SetBoundsDirty () {

	this->mBoundsDirty = true;
}

//----------------------------------------------------------------//
void MOAIDeck::SerializeIn ( MOAILuaState& state, MOAIDeserializer& serializer ) {
	
	UNUSED ( serializer );
    if ( state.GetFieldWithType ( -1, "MOAIDeck", LUA_TTABLE )) {
        mContentMask = state.GetField( -1, "mContentMask", 0xffffffff );
        mDefaultShaderID = state.GetField( -1, "mDefaultShaderID", (u32)MOAIShaderMgr::DECK2D_SHADER );
        if ( state.GetFieldWithType ( -1, "mMaxBounds", LUA_TTABLE )) {
            mMaxBounds.mMin.mX = state.GetField( -1, "mMin.mX", 0 );
            mMaxBounds.mMin.mY = state.GetField( -1, "mMin.mY", 0 );
            mMaxBounds.mMin.mZ = state.GetField( -1, "mMin.mZ", 0 );
            mMaxBounds.mMax.mX = state.GetField( -1, "mMax.mX", 0 );
            mMaxBounds.mMax.mY = state.GetField( -1, "mMax.mY", 0 );
            mMaxBounds.mMax.mZ = state.GetField( -1, "mMax.mZ", 0 );
		    state.Pop ( 1 );
        }
		state.Pop ( 1 );
    }
}

//----------------------------------------------------------------//
void MOAIDeck::SerializeOut ( MOAILuaState& state, MOAISerializer& serializer ) {
	
	UNUSED ( serializer );
    lua_newtable ( state );
        state.SetField ( -1, "mContentMask", mContentMask );
        state.SetField ( -1, "mDefaultShaderID", mDefaultShaderID );
        lua_newtable ( state );
            state.SetField ( -1, "mMin.mX", mMaxBounds.mMin.mX );
            state.SetField ( -1, "mMin.mY", mMaxBounds.mMin.mY );
            state.SetField ( -1, "mMin.mZ", mMaxBounds.mMin.mZ );
            state.SetField ( -1, "mMax.mX", mMaxBounds.mMax.mX );
            state.SetField ( -1, "mMax.mY", mMaxBounds.mMax.mY );
            state.SetField ( -1, "mMax.mZ", mMaxBounds.mMax.mZ );
	    lua_setfield ( state, -2, "mMaxBounds" );
	lua_setfield ( state, -2, "MOAIDeck" );
}
