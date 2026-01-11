# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -O2
LDFLAGS = -lm

# Target executable name
TARGET = main

# Automatically find all .c files in current directory
SRCS = $(wildcard *.c)

# Generate object file names from source files
OBJS = $(SRCS:.c=.o)

# Header files (for dependency tracking)
HEADERS = $(wildcard *.h)

# Detect operating system
ifeq ($(OS),Windows_NT)
    # Windows
    RM = del /Q /F
    RMDIR = rmdir /S /Q
    EXE_EXT = .exe
    MKDIR = mkdir
    PATH_SEP = \\
else
    # Linux/Unix/macOS
    RM = rm -f
    RMDIR = rm -rf
    EXE_EXT =
    MKDIR = mkdir -p
    PATH_SEP = /
endif

# Add extension to target
TARGET_EXE = $(TARGET)$(EXE_EXT)

# Default target
all: $(TARGET_EXE)

# Link object files to create executable
$(TARGET_EXE): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)
	@echo Build complete: $(TARGET_EXE)

# Compile .c files to .o files
%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

# Clean up generated files
clean:
ifeq ($(OS),Windows_NT)
	@if exist *.o $(RM) *.o
	@if exist $(TARGET_EXE) $(RM) $(TARGET_EXE)
	@echo Clean complete
else
	$(RM) $(OBJS) $(TARGET_EXE)
	@echo Clean complete
endif

# Clean and rebuild
rebuild: clean all

# Run the program
run: $(TARGET_EXE)
	.$(PATH_SEP)$(TARGET_EXE)

# Run with custom input file
run-custom: $(TARGET_EXE)
	.$(PATH_SEP)$(TARGET_EXE) $(FILE)

# Show variables (for debugging Makefile)
show:
	@echo "Operating System: $(OS)"
	@echo "Sources: $(SRCS)"
	@echo "Objects: $(OBJS)"
	@echo "Headers: $(HEADERS)"
	@echo "Target: $(TARGET_EXE)"
	@echo "Remove command: $(RM)"

# Phony targets (not actual files)
.PHONY: all clean rebuild run run-custom show help

# Help message
help:
	@echo Available targets:
	@echo   make          - Build the project
	@echo   make clean    - Remove generated files
	@echo   make rebuild  - Clean and rebuild
	@echo   make run      - Build and run with default input
	@echo   make run-custom FILE=myfile.txt - Run with custom input file
	@echo   make show     - Show Makefile variables
	@echo   make help     - Show this help message
