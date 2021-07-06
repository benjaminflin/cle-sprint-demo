#!/bin/bash

export PATH=~/gaps/minizinc/bin:$PATH
export LD_LIBRARY_PATH=~/gaps/minizinc/lib:$LD_LIBRARY_PATH
export QT_PLUGIN_PATH=~/gaps/minizinc/plugins:$QT_PLUGIN_PATH
export DIR=~/gaps/sprint-demo/conflict-analyzer

count=0
for var in "$@"
do
count=$((count+1))
python3 $DIR/cle2zinc.py  -L -f $var
python3 $DIR/qd_cle_preprocessor.py -L -f $var
clang -c -emit-llvm -g ${var%%.c}.mod.c -o "./temp_"$count".bc"
done

llvm-link temp_*.bc -o temp.bc

opt -load ~/program-dependence-graph/build/libpdg.so -minizinc -zinc-debug < temp.bc 

minizinc $DIR/conflict_analyzer.mzn init_cle.mzn pdg_data.dzn $DIR/conflict_analyzer_decs.mzn cle-data.dzn

rm *.bc
