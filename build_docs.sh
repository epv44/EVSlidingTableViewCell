#!/bin/sh

PATH=$(bash -l -c 'echo $PATH')

jazzy -x -workspace,Example/EVSlidingTableViewCell.xcworkspace,-scheme,EVSlidingTableViewCell-Example
