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
OBJDIR := obj/

# getting header files
headers := $(notdir $(wildcard src/*.h) $(wildcard src/*/*.h) $(wildcard include/*.h) $(wildcard include/*/*.h))
# getting source files
sources := $(wildcard src/*.cpp) $(wildcard src/*/*.cpp) $(wildcard include/*.cpp) $(wildcard include/*/*.cpp)
# getting object files
object_files := $(patsubst %.cpp,$(OBJDIR)%.o,$(notdir $(sources)))

#setting vpath
VPATH := $(sort $(dir $(sources)))

print:
	@echo $(INCLUDE_PATHS)

debug: FLAGS := $(DEBUGFLAGS_O)

release: FLAGS := $(RELEASEFLAGS_O)

release: $(object_files)
	@$(CC) obj/*.o -o $(OUTPATH_RELEASE) -s -L lib/ $(LIBS)
	@xcopy graphics\\ bin\\release\\graphics\\ /s /Y

debug: $(object_files)
	@$(CC) obj/*.o -o $(OUTPATH_DEBUG) -L lib/ $(LIBS)
	@xcopy graphics\\ bin\\debug\\graphics\\ /s /Y

$(OBJDIR)%.o: %.cpp
	@echo Compiling $< to $@
	@$(CC) -c $< -o $@ $(FLAGS)

clean_all: clean clean_graphics

clean:
	@echo Cleaning Object files
	@cd obj/ && del *.o
	@echo Cleaning Binaries
	@cd bin/debug/ && del $(project_name).exe && del /q bin && del /S /Q graphics
	@cd bin/release/ && del $(project_name).exe && del /q bin && del /S /Q graphics

clean_graphics:
	@echo Cleaning Graphics
	@cd bin/debug/ && del /S /Q graphics
	@cd bin/release/ && del /S /Q graphics
