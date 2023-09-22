#!/bin/bash
# To run this script, monkeyc must be on the $PATH, and you need to have
#   created a developer key in DER format.
monkeyc -o mowf.prg -f monkey.jungle -y developer_key.der 

