#!/bin/bash

rm -f build/test.data
build/a.out -test pre -init build/test.data
build/a.out -test pre -data build/test.data
build/a.out -test pre
