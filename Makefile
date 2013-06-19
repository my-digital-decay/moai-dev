# ------------------------------------------------------------------------------
# Moai Makefile

default: osx
.PHONY: all


#
# Mac OSX
#

premake-osx: premake/premake4.lua
	@echo "Generating makefiles for osx ..."
	@premake4 --file=premake/premake4.lua --gcc=osx --platform=x32 gmake
.PHONY: premake-osx

osx-debug:
	@${MAKE} premake-osx
	@${MAKE} -C build/gmake-osx host-glfw config=debug32
.PHONY: osx-debug

osx-release:
	@${MAKE} premake-osx
	@${MAKE} -C build/gmake-osx host-glfw config=release32
.PHONY: osx-release

osx: osx-debug osx-release
.PHONY: osx

clean-osx:
	@test -d build/gmake-osx && ${MAKE} -C build/gmake-osx clean; true
	@test -d out/osx && rm -r out/osx; true
.PHONY: clean-osx


#
# Ouya
#

make-ouya-host:
	@cd ant && bash make-host.sh -p com.mydigitaldecay.orange.moai-host -a armeabi-v7a  -l android-16
.PHONY: make-ouya-host

ouya-debug: make-ouya-host
#	@bash make-host.sh 
.PHONY: ouya-debug

ouya-release: make-ouya-host
.PHONY: ouya-release

ouya: ouya-debug ouya-release
.PHONY: ouya

clean-ouya:
	@cd ant/libmoai && bash clean.sh
.PHONY: clean-ouya


#
# Linux
#

premake-linux: premake/premake4.lua
	@echo "Generating makefiles for linux ..."
	@premake4 --file=premake/premake4.lua --gcc=linux --platform=x32 gmake
.PHONY: premake-linux

linux-debug:
	@${MAKE} premake-linux
	@${MAKE} -C build/gmake-linux host-glfw config=debug32
.PHONY: linux-debug

linux-release:
	@${MAKE} premake-linux
	@${MAKE} -C build/gmake-linux host-glfw config=release32
.PHONY: linux-release

linux: linux-debug linux-release
.PHONY: linux

clean-linux:
	@test -d build/gmake-linux && ${MAKE} -C build/gmake-linux clean; true
	@test -d out/linux && rm -r out/linux; true
.PHONY: clean-linux


#
# iOS (untested)
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

clean-ios:
	@test -d build/gmake-ios && ${MAKE} -C build/gmake-ios clean; true
	@test -d out/ios && rm -r out/ios; true
.PHONY: clean-ios


#
# Common targets
#

clean: clean-osx clean-ouya clean-linux clean-ios
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
	@echo "   ouya"
	@echo "   ouya-debug"
	@echo "   ouya-release"
	@echo "   linux"
	@echo "   linux-debug"
	@echo "   linux-release"
	@echo "   ios"
	@echo "   ios-debug"
	@echo "   ios-release"
	@echo "   clean"
	@echo "   help"
.PHONY: help

