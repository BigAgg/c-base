import os

dir_path = os.path.dirname(os.path.realpath(__file__))

include_paths = []

for path, subdirs, files in os.walk(f"{dir_path}\\include"):
	if path not in include_paths:
		include_paths.append(path)
for path, subdirs, files in os.walk(f"{dir_path}\\src"):
	if path not in include_paths:
		include_paths.append(path)

with open("compile_flags.txt", mode="w", encoding="utf-8") as file:
	file.write("g++\n")
	file.write("-std=c++20\n")
	for path in include_paths:
		file.write(f'-I{path}\n')

#with open(".clangd", mode="w", encoding="utf-8") as file:
	#file.write("CompileFlags:\n")
	#file.write("\tAdd: -I\n")
	#for path in include_paths:
		#file.write(f"\t\t- {path}\n")

#with open(".clangd", mode="w", encoding="utf-8") as file:
	#file.write("CompileFlags:\n")
	#file.write("\tAdd: [")
	#for path in include_paths:
		#file.write(f"-I{path},")
	#file.write("]")
