// ---------------------------------------------------------------------------
/*!
 *  @file GlfwHost.cpp
 *  Copyright (c) 2013 by Keith W. Thompson. All Rights Reserved.
 */
// ---------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <moai_config.h>
#include <lua-headers/moai_lua.h>
#include <string.h>

#define UNUSED(p) (( void )p)

#include <moai-http-client/host.h>
#include <moai-sim/host.h>
#include <moai-util/host.h>

#if MOAI_WITH_BOX2D
    #include <moai-box2d/host.h>
#endif

#if MOAI_WITH_CHIPMUNK
    #include <moai-chipmunk/host.h>
#endif

#if MOAI_WITH_FMOD_DESIGNER
    #include <moai-fmod-designer/host.h>
#endif

#if MOAI_WITH_FMOD_EX
    #include <moai-fmod-ex/host.h>
#endif

#if MOAI_WITH_HARNESS
    #include <moai-harness/host.h>
#endif

#if MOAI_WITH_HTTP_CLIENT
    #include <moai-http-client/host.h>
#endif

#if MOAI_WITH_LUAEXT
    #include <moai-luaext/host.h>
#endif

#if MOAI_WITH_PARTICLE_PRESETS
    #include <ParticlePresets.h>
#endif

#if MOAI_WITH_UNTZ
    #include <moai-untz/host.h>
#endif

#if _MSC_VER
    #include <Crtdbg.h>
#endif

#ifdef _WIN32
    #include <Windows.h>
#endif

//#ifdef __APPLE__
//    #include <OpenGL/OpenGL.h>
//#endif

#include <GL/glfw.h>

namespace GlfwInputDeviceID {
    enum {
        DEVICE,
        TOTAL,
    };
}

namespace GlfwInputDeviceSensorID {
    enum {
        KEYBOARD,
        POINTER,
        MOUSE_LEFT,
        MOUSE_MIDDLE,
        MOUSE_RIGHT,
        MOUSE_WHEEL,
        TOTAL,
    };
}

static bool sHasWindow = false;
static bool sFullscreen = false;
static bool sDynamicallyReevaluateLuaFiles = false;

static char sWinTitle[128] = "GLFW Host";
static int sWinX = 180;
static int sWinY = 100;
static int sWinWidth = 640;
static int sWinHeight = 480;

void _AKUEnterFullscreenModeFunc ();
void _AKUExitFullscreenModeFunc ();

static void GLFWCALL _onKey( int key, int state );
static void GLFWCALL _onMouseButton ( int button, int state );
static void GLFWCALL _onMouseMove ( int x, int y );
static void GLFWCALL _onMouseWheel ( int value );

// -----------------------------------------------------------------------------
// @section Helper Functions

// -----------------------------------------------------------------------------
// ToggleFullscreen
static void ToggleFullscreen ( )
{
    if ( sFullscreen ) {
        // Exit
        _AKUExitFullscreenModeFunc ();
    }
    else {
        // Enter
        _AKUEnterFullscreenModeFunc ();
    }
}

// -----------------------------------------------------------------------------
// OpenWindow
static bool OpenWindow ( const char * title, int width, int height, int x, int y, bool fullscreen )
{
    sWinX = x,
    sWinY = y;
    sWinWidth = width;
    sWinHeight = height;
    strncpy( sWinTitle, title, 128 );

#if MOAI_WITH_GL3
    glfwOpenWindowHint(GLFW_OPENGL_VERSION_MAJOR, 3);
    glfwOpenWindowHint(GLFW_OPENGL_VERSION_MINOR, 2);
    glfwOpenWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwOpenWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif
    glfwOpenWindowHint(GLFW_AUTO_POLL_EVENTS, GL_FALSE);
    glfwOpenWindowHint(GLFW_WINDOW_NO_RESIZE, GL_TRUE);
    if ( !glfwOpenWindow( width, height, 0, 0, 0, 0, 16, 0, fullscreen ? GLFW_FULLSCREEN : GLFW_WINDOW ) ) {
        return false;
    }

    if ( !fullscreen ) {
        glfwSetWindowTitle( title );
        glfwSetWindowPos( x, y );
    }
    glfwSwapInterval( 1 );

    glfwSetKeyCallback( _onKey );
    glfwSetMouseButtonCallback( _onMouseButton );
    glfwSetMousePosCallback( _onMouseMove );
    glfwSetMouseWheelCallback( _onMouseWheel );

    sHasWindow = true;

    return true;
}

// -----------------------------------------------------------------------------
// CloseWindow
static void CloseWindow ( )
{
    glfwCloseWindow();
    sHasWindow = false;
}

// -----------------------------------------------------------------------------
// _onSpecialKey
static void _onSpecialKey ( int key )
{
    if ( key == GLFW_KEY_F1 ) {
        static bool toggle = true;

        if ( toggle ) {
            AKUReleaseGfxContext ();
        }
        else {
            AKUDetectGfxContext ();
        }
        toggle = !toggle;
    }

    if ( key == GLFW_KEY_F2 ) {
        AKUSoftReleaseGfxResources ( 0 );
    }

    if ( key == GLFW_KEY_F11 ) {
        ToggleFullscreen ();
    }
}


// -----------------------------------------------------------------------------
// @section glfw callbacks

// -----------------------------------------------------------------------------
// _onKey
static void GLFWCALL _onKey( int key, int state )
{
    bool pressed = (state == GLFW_PRESS);

    switch ( key ) {
      case GLFW_KEY_LSHIFT:
      case GLFW_KEY_RSHIFT:
        AKUEnqueueKeyboardShiftEvent( GlfwInputDeviceID::DEVICE,
                                        GlfwInputDeviceSensorID::KEYBOARD,
                                        pressed );
        break;
      case GLFW_KEY_LCTRL:
      case GLFW_KEY_RCTRL:
        AKUEnqueueKeyboardControlEvent( GlfwInputDeviceID::DEVICE,
                                        GlfwInputDeviceSensorID::KEYBOARD,
                                        pressed );
        break;
      case GLFW_KEY_LALT:
      case GLFW_KEY_RALT:
        AKUEnqueueKeyboardAltEvent( GlfwInputDeviceID::DEVICE,
                                    GlfwInputDeviceSensorID::KEYBOARD,
                                    pressed );
        break;
      default:
        AKUEnqueueKeyboardEvent( GlfwInputDeviceID::DEVICE,
                                 GlfwInputDeviceSensorID::KEYBOARD,
                                 key,
                                 pressed );
        break;
    }

    printf("key: %d (%s)\n", key, pressed ? "press" : "release");

    _onSpecialKey( key );
}

// -----------------------------------------------------------------------------
// _onMouseButton
static void GLFWCALL _onMouseButton ( int button, int state )
{
    switch ( button ) {
        case GLFW_MOUSE_BUTTON_LEFT:
            AKUEnqueueButtonEvent( GlfwInputDeviceID::DEVICE,
                                   GlfwInputDeviceSensorID::MOUSE_LEFT,
                                   ( state == GLFW_PRESS ));
            break;
        case GLFW_MOUSE_BUTTON_MIDDLE:
            AKUEnqueueButtonEvent( GlfwInputDeviceID::DEVICE,
                                   GlfwInputDeviceSensorID::MOUSE_MIDDLE,
                                   ( state == GLFW_PRESS ));
            break;
        case GLFW_MOUSE_BUTTON_RIGHT:
            AKUEnqueueButtonEvent( GlfwInputDeviceID::DEVICE,
                                   GlfwInputDeviceSensorID::MOUSE_RIGHT,
                                   ( state == GLFW_PRESS ));
            break;
    }
}

// -----------------------------------------------------------------------------
// _onMouseMove
static void GLFWCALL _onMouseMove ( int x, int y )
{
    AKUEnqueuePointerEvent( GlfwInputDeviceID::DEVICE,
                            GlfwInputDeviceSensorID::POINTER,
                            x, y );
}

// -----------------------------------------------------------------------------
// _onMouseMove
static void GLFWCALL _onMouseWheel ( int value )
{
    AKUEnqueueWheelEvent( GlfwInputDeviceID::DEVICE,
                          GlfwInputDeviceSensorID::MOUSE_WHEEL,
                          value );
}

// -----------------------------------------------------------------------------
// _onInput
static void _onInput( )
{
    glfwPollEvents();
}

// -----------------------------------------------------------------------------
// _onUpdate
static void _onUpdate( )
{
    double fSimStep = AKUGetSimStep ();
//    int timerInterval = ( int )( fSimStep * 1000.0 );

#if MOAI_WITH_DEBUGGER
    AKUDebugHarnessUpdate ();
#endif

    AKUUpdate ();

#if MOAI_WITH_FMOD
    AKUFmodUpdate ();
#endif

#if MOAI_WITH_FMOD_DESIGNER
    AKUFmodDesignerUpdate (( float )fSimStep );
#endif

#if 0 // defined( _DEBUG )
    if ( sDynamicallyReevaluateLuaFiles ) {
#ifdef _WIN32
        winhostext_Query ();
#elif __APPLE__
        FWReloadChangedLuaFiles ();
#endif
    }
#endif // _DEBUG
}

// -----------------------------------------------------------------------------
// _onDraw
static void _onDraw( )
{
    AKURender();
    glfwSwapBuffers();
}

// -----------------------------------------------------------------------------
// @section AKU callbacks

// -----------------------------------------------------------------------------
// _AKUEnterFullscreenModeFunc
void _AKUEnterFullscreenModeFunc ()
{
    if ( sHasWindow && !sFullscreen ) {
        CloseWindow();
        OpenWindow( sWinTitle, sWinWidth, sWinHeight, sWinX, sWinY, true );
        AKUDetectGfxContext ();
        sFullscreen = true;
    }
}

// -----------------------------------------------------------------------------
// _AKUExitFullscreenModeFunc
void _AKUExitFullscreenModeFunc ()
{
    if ( sHasWindow && sFullscreen ) {
        CloseWindow();
        OpenWindow( sWinTitle, sWinWidth, sWinHeight, sWinX, sWinY, false );
        AKUDetectGfxContext ();
        sFullscreen = false;
    }
}

// -----------------------------------------------------------------------------
// _AKUOpenWindowFunc
void _AKUOpenWindowFunc ( const char* title, int width, int height )
{
    if ( sHasWindow ) {
        sWinWidth = width;
        sWinHeight = height;
        strncpy( sWinTitle, title, 128 );
        glfwSetWindowTitle( title );
        glfwSetWindowSize( width, height );
    }
    else {
        if ( !OpenWindow( title, width, height, sWinX, sWinY, sFullscreen ) ) {
            printf("OpenWindow - Failed to open glfw window\n");
            exit(1);
        }
    }

    AKUDetectGfxContext ();
    AKUSetScreenSize ( width, height );
    AKUSetViewSize ( width, height );
}

//================================================================//
// AKU-debugger callbacks
//================================================================//

#if MOAI_WITH_HARNESS
void _debuggerTracebackFunc ( const char* message, lua_State* L, int level )
{
    AKUDebugHarnessHandleError ( message, L, level );
}
#endif

// -----------------------------------------------------------------------------
// @section GlfwHost

// -----------------------------------------------------------------------------
// _cleanup
static void _cleanup ()
{
    // TODO:
    // don't call this on windows; atexit conflict with untz
    // possible to fix?
    //AKUClearMemPool ();

#if MOAI_WITH_BOX2D
    AKUFinalizeBox2D ();
#endif

#if MOAI_WITH_CHIPMUNK
    AKUFinalizeChipmunk ();
#endif

#if MOAI_WITH_HTTP_CLIENT
    AKUFinalizeHttpClient ();
#endif

    AKUFinalizeUtil ();
    AKUFinalizeSim ();
    AKUFinalize ();

    glfwTerminate();

#if 0 //defined( _DEBUG )
    if ( sDynamicallyReevaluateLuaFiles ) {
#ifdef _WIN32
        winhostext_CleanUp ();
#elif __APPLE__
        FWStopAll ();
#endif
    }
#endif // _DEBUG
}

// -----------------------------------------------------------------------------
// GlfwRefreshContext
void GlfwRefreshContext()
{
    AKUContextID context = AKUGetContext ();
    if ( context ) {
        AKUDeleteContext ( context );
    }
    AKUCreateContext ();

    AKUInitializeUtil ();
    AKUInitializeSim ();

#if MOAI_WITH_BOX2D
    AKUInitializeBox2D ();
#endif

#if MOAI_WITH_CHIPMUNK
    AKUInitializeChipmunk ();
#endif

#if MOAI_WITH_FMOD_EX
    AKUFmodLoad ();
#endif

#if MOAI_WITH_FMOD_DESIGNER
    AKUFmodDesignerInit ();
#endif

#if MOAI_WITH_LUAEXT
    AKUExtLoadLuacrypto ();
    AKUExtLoadLuacurl ();
    AKUExtLoadLuafilesystem ();
    AKUExtLoadLuasocket ();
    AKUExtLoadLuasql ();
#endif

#if MOAI_WITH_HARNESS
    AKUSetFunc_ErrorTraceback ( _debuggerTracebackFunc );
    AKUDebugHarnessInit ();
#endif

#if MOAI_WITH_HTTP_CLIENT
    AKUInitializeHttpClient ();
#endif

#if MOAI_WITH_PARTICLE_PRESETS
    ParticlePresets ();
#endif

#if MOAI_WITH_UNTZ
    AKUInitializeUntz ();
#endif

    AKUSetInputConfigurationName ( "AKUGlfw" );

    AKUReserveInputDevices       ( GlfwInputDeviceID::TOTAL );
    AKUSetInputDevice            ( GlfwInputDeviceID::DEVICE,
                                   "device" );
    AKUReserveInputDeviceSensors ( GlfwInputDeviceID::DEVICE,
                                   GlfwInputDeviceSensorID::TOTAL );
    AKUSetInputDeviceKeyboard    ( GlfwInputDeviceID::DEVICE,
                                   GlfwInputDeviceSensorID::KEYBOARD,
                                   "keyboard" );
    AKUSetInputDevicePointer     ( GlfwInputDeviceID::DEVICE,
                                   GlfwInputDeviceSensorID::POINTER,
                                   "pointer" );
    AKUSetInputDeviceButton      ( GlfwInputDeviceID::DEVICE,
                                   GlfwInputDeviceSensorID::MOUSE_LEFT,
                                   "mouseLeft" );
    AKUSetInputDeviceButton      ( GlfwInputDeviceID::DEVICE,
                                   GlfwInputDeviceSensorID::MOUSE_MIDDLE,
                                   "mouseMiddle" );
    AKUSetInputDeviceButton      ( GlfwInputDeviceID::DEVICE,
                                   GlfwInputDeviceSensorID::MOUSE_RIGHT,
                                   "mouseRight" );

    AKUSetFunc_EnterFullscreenMode ( _AKUEnterFullscreenModeFunc );
    AKUSetFunc_ExitFullscreenMode ( _AKUExitFullscreenModeFunc );
    AKUSetFunc_OpenWindow ( _AKUOpenWindowFunc );

    AKURunBytecode ( moai_lua, moai_lua_SIZE );
}

// -----------------------------------------------------------------------------
// GlfwHost
int GlfwHost ( int argc, char** argv )
{
    // TODO: integrate this nicely with host
    //AKUInitMemPool ( 100 * 1024 * 1024 );
    atexit ( _cleanup );

    // Initialise GLFW
    if ( GL_FALSE == glfwInit() ) {
        printf("glfwInit - Failed to initialize GLFW\n");
        exit(1);
    }

    GlfwRefreshContext ();

    char* lastScript = NULL;

    if ( argc < 2 ) {
        AKURunScript ( "main.lua" );
    }
    else {
        AKUSetArgv ( argv );

        for ( int i = 1; i < argc; ++i ) {
            char* arg = argv [ i ];
            if ( strcmp( arg, "-e" ) == 0 ) {
                sDynamicallyReevaluateLuaFiles = true;
            }
            else if ( strcmp( arg, "-s" ) == 0 && ++i < argc ) {
                char* script = argv [ i ];
                AKURunString ( script );
            }
            else {
                AKURunScript ( arg );
                lastScript = arg;
            }
        }
    }

#if 0 // defined( _DEBUG )
    // Assuming that the last script is the entry point we watch for that
    // directory and its subdirectories
    if ( lastScript && sDynamicallyReevaluateLuaFiles ) {
#ifdef _WIN32
        winhostext_WatchFolder ( lastScript );
#elif __APPLE__
        FWWatchFolder( lastScript );
#endif
    }
#endif // _DEBUG

    if ( sHasWindow ) {
        while ( glfwGetWindowParam(GLFW_OPENED) ) {
            _onInput();
            _onUpdate();
            _onDraw();
        }
    }
    return 0;
}

// -----------------------------------------------------------------------------
// @section Main

#ifdef _WIN32
// -----------------------------------------------------------------------------
// WinMain
int CALLBACK WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow )
{
    int argc = __argc;
    char** argv = __argv;

#if _MSC_VER
    // affects assert.h assert()
    _set_error_mode ( _OUT_TO_MSGBOX );

    // affects crtdbg.h _ASSERT, _ASSERTE, etc
    _CrtSetReportMode ( _CRT_ASSERT, _CRTDBG_MODE_DEBUG | _CRTDBG_MODE_WNDW | _CRTDBG_MODE_FILE );
    _CrtSetReportFile ( _CRT_ASSERT, _CRTDBG_FILE_STDERR );
#endif

    return GlfwHost( argc, argv );
}
#endif

// -----------------------------------------------------------------------------
// main
int main( int argc, char** argv )
{
#ifdef _DEBUG
    printf ( "MOAI-OPEN DEBUG\n" );
#endif

    return GlfwHost( argc, argv );
}

// -----------------------------------------------------------------------------

