#!/bin/bash

./configure --prefix=/usr --sysconfdir=/etc &&
make

sudo make install

