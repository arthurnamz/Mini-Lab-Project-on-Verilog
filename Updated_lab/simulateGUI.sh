#!/bin/sh

TOP_LEVEL=$1

xvlog -sv *.sv
xvlog *.v
xelab $TOP_LEVEL -debug all  -timescale 1ns/1ps
xsim $TOP_LEVEL -g -protoinst example_stream_protoinst.proto
