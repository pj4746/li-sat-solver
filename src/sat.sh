#! /bin/bash

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

# make variables
BIN_DIR=$(cd "$SCRIPTPATH/bin"; pwd)
BIN_NAME="sat"
BIN_FILE="$BIN_DIR/$BIN_NAME"

function usage {
	echo ""
	echo "Usage: `basename $0` [compile | run PROBLEM_FILE OUT_FILE]"
	echo ""
	echo "Targets:"
	echo "  compile: compiles the SAT solver project, producing an executable file at $BIN_DIR, and exits"
	echo "      run: runs the compiled SAT solver with the given input and output files. If no executable"
	echo "           is found, the project is compiled as if the 'compile' target was called."
	echo ""
	echo "Run options:"
	echo "  PROBLEM_FILE: the file with the SAT problem to be solved"
	echo "      OUT_FILE: the file where the output solution will be printed"
	echo ""
	exit
}

function compile {
	pushd $SCRIPTPATH > /dev/null
	echo "compiling SAT..."
	make BIN_DIR=$BIN_DIR BIN_NAME=$BIN_NAME
	echo ""
	echo "Done: SAT solver executable is in $BIN_DIR"
	echo ""
	popd > /dev/null
}

function run_sat {
	# check if enough arguments are passed in
	if [ "$#" -lt 3 ]; then
		echo "ERROR: not enough parameters"
		usage
	fi

	# check if the input problem file exists
	if [ ! -f $2 ]; then
		echo "ERROR: file '$2' not found or not a regular file"
		usage
	fi

	# check if the executable file exists
	if [ ! -x $BIN_FILE ]; then
		compile
	fi

	echo "running SAT with the problem definition at '$2'..."

	$BIN_FILE < $2 > $3

	echo ""
	echo "Done: the result was written to the file '$3'"
	echo ""
}

# make sure that executables will work in the current directory, without
#  having to prepend './'
export PATH=$PATH:.


# MAIN SCRIPT PROCEDURE:
if [ "$1" = "compile" ]; then
	compile
	exit
elif [ "$1" = "run" ]; then
	run_sat $@
else
	echo "ERROR: invalid target execution"
	usage
fi
