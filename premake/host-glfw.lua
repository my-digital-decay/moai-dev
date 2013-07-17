--------------------------------------------------------------------------------
--- file:host-glfw.lua
--- host-glfw project build file
---

project "host-glfw"
  kind "ConsoleApp"
  language "C++"
  defines {
    "GLFW_INCLUDE_NONE",
  }
  files {
    ROOT_PATH .. "/src/host-glfw/GlfwHost.cpp",
    ROOT_PATH .. "/src/host-glfw/ParticlePresets.cpp",
  }
  includedirs {
    ROOT_PATH .. "/src",
    ROOT_PATH .. "/src/config",
    ROOT_PATH .. "/src/host-glfw",
    ROOT_PATH .. "/3rdparty/glfw-2.7.8/include",
  }
  links {
    "libmoai-core",
    "libmoai-util",
    "libmoai-3rdparty",
    "libmoai-box2d",
    "libmoai-untz",
    "libmoai-sim",
    "libzl-gfx",
    "libzl-util",
    "libzl-vfs",
  }

  --- cross-platform configuration specific settings
  debug_cfg = configuration "debug"
    targetdir (OUT_PATH .. "/debug")

  release_cfg = configuration "release"
    targetdir (OUT_PATH .. "/release")

  --- platform specific settings
  configuration "osx"
    targetname "moai-osx"
--      files {
--        "src/hosts/FolderWatcher-mac.mm",
--      }
    linkoptions {
      "-framework AudioToolbox", -- Untz
      "-framework AudioUnit", -- Untz
      "-framework CoreFoundation",
      "-framework Cocoa",
      "-framework IOKit",
      "-framework OpenGL",
      "../../3rdparty/glfw-2.7.8/lib/cocoa/libglfw.a",
      "-lstdc++",
      "-lc",
    }
    prebuildcommands {
      "@cd ../../3rdparty/glfw-2.7.8/lib/cocoa && $(MAKE) -f Makefile.cocoa libglfw.a"
    }

  configuration { "osx", "debug" }
    postbuildcommands {
      "@mkdir ../../bin 2>/dev/null; true",
      "@cp " .. debug_cfg.targetdir .. "/moai-osx ../../bin/moai-osx-debug"
    }

  configuration { "osx", "release" }
    postbuildcommands {
      "@mkdir ../../bin 2>/dev/null; true",
      "@cp " .. release_cfg.targetdir .. "/moai-osx ../../bin/"
    }

  configuration "linux"
    targetname "moai-linux"
    linkoptions {
      "-L/usr/lib/i386-linux-gnu",
      "-lSDL",
      "-lSDL_sound",
      "../../3rdparty/glfw-2.7.8/lib/cocoa/libglfw.a",
      "-lstdc++",
      "-lc",
    }

  configuration { "linux", "release" }
    postbuildcommands {
      "@mkdir ../../bin 2>/dev/null; true",
      "@cp " .. release_cfg.targetdir .. "/moai-linux ../../bin/"
    }

