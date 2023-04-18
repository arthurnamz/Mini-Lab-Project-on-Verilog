#!/bin/sh

TOP_LEVEL=$1

xvlog *.v
xelab $TOP_LEVEL -debug all  -timescale 1ns/1ps
xsim $TOP_LEVEL -g
