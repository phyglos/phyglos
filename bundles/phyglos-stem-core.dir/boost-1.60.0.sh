#/bin/bash 

build_compile()
{
    ./bootstrap.sh --prefix=/usr
    
    ./b2 stage threading=multi link=shared            
}

build_test_level=0
build_test()
{
    pushd tools/build/test
      python test_all.py
    popd

    # Full regression tests
#    pushd status
#      ../b2 
#    popd     
}

build_pack()
{
    cp -vR stage/* $BUILD_PACK
}
