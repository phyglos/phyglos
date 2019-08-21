    README - General description of the phyglos catalog

    Copyright (C) 2015-2019 Angel Linares Zapater

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License, version 2, as
    published by the Free Software Foundation. See the COPYING file.

    This program is distributed WITHOUT ANY WARRANTY; without even the
    implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  

    
The phyglos Catalog
===================

The phyglos Catalog is a BANDIT catalog that contains the necessary "bundles of
functionality" to create and raise a new phySystem.

t also contains other bundles to add more functionality to the system in order
to raise the X Window System and the Xfce Destop Environment as well as other
common applications like Emacs, Git, Atom, Firefox, etc. 

How to use
==========

This catalog is used with the help of the BANDIT toolkit. The BANDIT can use the
**phyglos-builder** bundle and the **phyglos-core** bundle to raise a new TARGET
*phy system* from a HOST system running phyglos or a supported Linux
distribution.

The BANDIT can then use the rest of the bundles in the catalog to add and manage
software funcionality in the new system. See the BANDIT documentation
(https://docs.phyglos.org/bandit) to learn how to use the BANDIT toolkit with
the phyglos Catalog to install and remove bundles and packages in a phySystem. 


Status
======

The phyglos Catalog is in STABLE status. With this catalog the BANDIT can create
a new TARGET system and install phyglos in a free disk partition on the HOST system
or in a directory ready to create de container image.

In version 1.x, some of the packages are not always kept up to their latest upstream
versions. Therefore the phySystem raised vith version 1.x should only be used in
development, testing and learning environments.

Version 2.x is updated to latest packages and introduces new changes requiring also
version 2.x of the BANDIT to properly raise a new phySystem. This version is in
DEVELOPMENT status.

More information
================

See the documentation at https://docs.phyglos.org/phyglos for more information about the status, roadmap, handbook, etc.

The RELEASE file describes the main changes in this release.

The COPYING file contains the GNU License for this software.
