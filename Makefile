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
DIRS := ./obj ./obj/release ./obj/debug ./bin ./bin/release ./bin/debug
OUTPATH_DEBUG := bin/debug/$(project_name)
OUTPATH_RELEASE := bin/release/$(project_name)
OBJDIR_R := obj/release/
OBJDIR_D := obj/debug/

# getting source files
sources := $(wildcard src/*.cpp) $(wildcard src/*/*.cpp) $(wildcard include/*.cpp) $(wildcard include/*/*.cpp)
# getting object files
objects_r := $(patsubst %.cpp,$(OBJDIR_R)%.o,$(notdir $(sources)))
objects_d := $(patsubst %.cpp,$(OBJDIR_D)%.o,$(notdir $(sources)))

#setting vpath
VPATH := $(sort $(dir $(sources)))

-include $(wildcard $(OBJDIR_D)*.d) $(wildcard $(OBJDIR_R)*.d)

.PHONY: clean rundebug runrelease clean_all clean_graphics rfolder dfolder

rundebug: debug
	cd bin/debug/ && .\${project_name}.exe

runrelease: release
	cd bin/release/ && .\${project_name}.exe

release: | $(DIRS) $(objects_r) $(headers)
	@$(CC) -MMD -MP obj/release/*.o -o $(OUTPATH_RELEASE) -s -L lib/ $(LIBS)

debug: | $(DIRS) $(objects_d) $(headers)
	@$(CC) -MMD -MP obj/debug/*.o -o $(OUTPATH_DEBUG) -L lib/ $(LIBS)

$(DIRS):
	@echo "Folder $@ does not exist"
	@mkdir "$@"

$(OBJDIR_R)%.o: %.cpp
	@echo Compiling $< to $@
	@$(CC) $(RELEASEFLAGS_O) -c $< -o $@

$(OBJDIR_D)%.o: %.cpp
	@echo Compiling $< to $@
	@$(CC) $(DEBUGFLAGS_O) -c $< -o $@

clean:
	@echo Cleaning Object files
	-@rmdir /s /q obj
	@echo Cleaning Binaries
	-@rmdir /s /q bin

