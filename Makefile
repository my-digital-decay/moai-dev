# ------------------------------------------------------------------------------
# Moai Makefile

all: osx ios
.PHONY: all


#
# Mac OSX
#

premake-osx: premake4.lua
	@echo "Generating makefiles for osx ..."
	@premake4 --file=./premake4.lua --gcc=osx --platform=x32 gmake
.PHONY: premake-osx

osx-debug:
	@${MAKE} premake-osx
	@${MAKE} -C build/gmake-osx config=debug32
.PHONY: osx-debug

osx-release:
	@${MAKE} premake-osx
	@${MAKE} -C build/gmake-osx config=release32
.PHONY: osx-release

osx: osx-debug osx-release
.PHONY: osx


#
# iOS
#

premake-ios: premake4.lua
	@echo "Generating makefiles for ios ..."
	@premake4 --file=./premake4.lua --gcc=ios --platform=x32 gmake
.PHONY: premake-ios

ios-debug:
	@${MAKE} premake-ios
	@${MAKE} -C build/gmake-ios config=debug32
.PHONY: ios-debug

ios-release:
	@${MAKE} premake-ios
	@${MAKE} -C build/gmake-ios config=release32
.PHONY: ios-release

ios: ios-debug ios-release
.PHONY: ios

#
# Linux
#

premake-linux: premake4.lua
	@echo "Generating makefiles for linux ..."
	@premake4 --file=./premake4.lua --gcc=linux --platform=x32 gmake
.PHONY: premake-ios

linux-debug:
	@${MAKE} premake-linux
	@${MAKE} -C build/gmake-linux config=debug32
.PHONY: linux-debug

linux-release:
	@${MAKE} premake-linux
	@${MAKE} -C build/gmake-linux config=release32
.PHONY: linux-release

linux: linux-debug linux-release
.PHONY: linux


clean:
	@test -d build/gmake-osx && ${MAKE} -C build/gmake-osx clean; true
	@test -d build/gmake-ios && ${MAKE} -C build/gmake-ios clean; true
	@test -d build/gmake-linux && ${MAKE} -C build/gmake-linux clean; true
	@test -d out && rm -r out/; true
.PHONY: clean

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "TARGETS:"
	@echo "   all (default)"
	@echo "   osx"
	@echo "   osx-debug"
	@echo "   osx-release"
	@echo "   ios"
	@echo "   ios-debug"
	@echo "   ios-release"
	@echo "   linux"
	@echo "   linux-debug"
	@echo "   linux-release"
	@echo "   clean"
	@echo "   help"
.PHONY: help

