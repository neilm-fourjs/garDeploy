#!/bin/bash
unset FGLPROFILE
BASE=$(dirname $0)
cd $BASE
fglrun Deploy.42r $* 2> deploy.err
