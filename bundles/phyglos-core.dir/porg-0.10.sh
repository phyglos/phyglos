#!/bin/bash

build_compile()
{
    ./configure              \
        --prefix=/usr        \
        --sysconfdir=/etc    \
        --localstatedir=/var \
	--disable-grop       \
	--disable-static
    
    make

    # Remove the use of deprecated "have" funtion
    sed -e "/have porg/d" \
	-e "s/\[ \"\$have\" \] \&\& //g" \
	-i scripts/porg_bash_completion
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install 
}
 

