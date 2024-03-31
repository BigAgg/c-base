#defining project settings
project_name := main
version := 0.0.1

#defining compiler settings
INCLUDE_PATHS := $(foreach wrd,$(wildcard src/*/),-I $(dir $(wrd))) \
	$(foreach wrd,$(wildcard include/*/),-I $(dir $(wrd)))
LIBS := -lraylib -lopengl32 -lgdi32 -lwinmm -llua54
CC := g++
CPP := c++20
DEBUGFLAGS_O := -std=$(CPP) -Wno-missing-braces -w -g -Wall -m64 $(INCLUDE_PATHS)
RELEASEFLAGS_O := -std=$(CPP) -Wno-missing-braces -w -O3 -Wall -m64 $(INCLUDE_PATHS)

#defining paths
OUTPATH_DEBUG := bin/debug/$(project_name)
OUTPATH_RELEASE := bin/release/$(project_name)
OBJDIR_R := obj/release/
OBJDIR_D := obj/debug/

# getting header files
headers := $(wildcard src/*.h) $(wildcard src/*/*.h) $(wildcard include/*.h) $(wildcard include/*/*.h)
# getting source files
sources := $(wildcard src/*.cpp) $(wildcard src/*/*.cpp) $(wildcard include/*.cpp) $(wildcard include/*/*.cpp)
# getting object files
objects_r := $(patsubst %.cpp,$(OBJDIR_R)%.o,$(notdir $(sources)))
objects_d := $(patsubst %.cpp,$(OBJDIR_D)%.o,$(notdir $(sources)))

#setting vpath
VPATH := $(sort $(dir $(sources)))

.PHONY: clean rundebug runrelease clean_all clean_graphics rfolder dfolder

rundebug: debug
	cd bin/debug/ && .\${project_name}.exe

runrelease: release
	cd bin/release/ && .\${project_name}.exe

release: rfolder $(objects_r) $(headers)
	@$(CC) obj/release/*.o -o $(OUTPATH_RELEASE) -s -L lib/ $(LIBS)
	-@xcopy graphics\\ bin\\release\\graphics\\ /s /YA

rfolder:
	-@mkdir "obj/release/"
	-@mkdir "bin/release/"

debug: dfolder $(objects_d) $(headers)
	@$(CC) obj/debug/*.o -o $(OUTPATH_DEBUG) -L lib/ $(LIBS)
	-@xcopy graphics\\ bin\\debug\\graphics\\ /s /Y

dfolder: 
	-@mkdir "obj/debug/"
	-@mkdir "bin/debug/"

$(OBJDIR_R)%.o: %.cpp
	@echo Compiling $< to $@
	@$(CC) -c $< -o $@ $(RELEASEFLAGS_O)

$(OBJDIR_D)%.o:%.cpp
	@echo Compiling $< to $@
	@$(CC) -c $< -o $@ $(DEBUGFLAGS_O)

clean_all: clean clean_graphics

clean:
	@echo Cleaning Object files
	@cd obj/debug/ && del *.o
	@cd obj/release/ && del *.o
	@echo Cleaning Binaries
	@cd bin/debug/ && del $(project_name).exe
	@cd bin/release/ && del $(project_name).exe

clean_graphics:
	@echo Cleaning Graphics
	@cd bin/debug/ && del /S /Q graphics
	@cd bin/release/ && del /S /Q graphics
