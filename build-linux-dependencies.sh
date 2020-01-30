#!/bin/sh -e

set -e
set -x

if test $# -eq 0; then
    echo "This script compiles dependencies of Scilab for Linux."
    echo
    echo "Syntax : $0 <dependency> with dependency equal to:"
    echo " - 'versions': display versions of dependencies,"
    echo " - 'download': download all dependencies,"
    echo " - 'all': compile all dependencies,"
    echo " - 'binary': configure dev-tools for binary version of Scilab,"
    echo " - 'jar': configure JARs for binary version of Scilab,"
    echo " - 'fromscratch': 'init' + 'download' + 'all' + 'binary',"
    echo " - 'init': copy some dev-tools from old repository."
    echo
    exit 42
fi

KERNEL=$(uname -s)
MACHINE=$(uname -m)

#########################
##### CONFIGURATION #####
#########################
if [ "$KERNEL" = "Linux" ]; then
    if [ "$MACHINE" = "i686" ]; then
        SPECIFICDIR="linux"
    elif [ "$MACHINE" = "x86_64" ]; then
        SPECIFICDIR="linux_x64"
    else
        echo "Unknown machine $MACHINE"
        exit
    fi
elif [ "$KERNEL" = "Darwin" ]; then
    SPECIFICDIR="macosx"
else
    echo "Unknown kernel $KERNEL"
    exit
fi

echo "Scilab prerequirements for $(uname -s)-$(uname -m)"

#INSTALLDIR=$(pwd)/$SPECIFICDIR/$KERNEL-$MACHINE
INSTALLDIR=$(pwd)/$SPECIFICDIR/usr
DEVTOOLSDIR=$(pwd)/../../../../../Dev-Tools

if [ "$MACHINE" = "i686" ]; then
  USRDIR="/usr/lib"
  LIBDIR="/lib"
elif [ "$MACHINE" = "x86_64" ]; then
  USRDIR="/usr/lib64"
  LIBDIR="/lib64"
fi

echo
echo "INSTALLDIR     = $INSTALLDIR"
echo "DEVTOOLSDIR    = $DEVTOOLSDIR"
echo

#[ ! -d $DEVTOOLSDIR ] && echo "Dev-tools directory not found" && exit

[ ! -d $INSTALLDIR ] && mkdir $INSTALLDIR -p

################################
##### DEPENDENCIES VERSION #####
################################
GCC_VERSION=9.2.0
OCAML_VERSION=4.01.0
LAPACK_VERSION=3.6.0
ATLAS_VERSION=3.10.2
OPENBLAS_VERSION=0.3.7
ANT_VERSION=1.9.4
ARPACK_VERSION=3.1.5
CURL_VERSION=7.64.1
EIGEN_VERSION=3.3.2
FFTW_VERSION=3.3.3
HDF5_VERSION=1.8.14
LIBXML2_VERSION=2.9.9
MATIO_VERSION=1.5.2
OPENSSL_VERSION=1.1.1c
OPENSSH_VERSION=7.5p1
PCRE_VERSION=8.38
SUITESPARSE_VERSION=4.4.5
TCL_VERSION=8.5.15
TK_VERSION=8.5.15
ZLIB_VERSION=1.2.11
PNG_VERSION=1.6.37
JOGL_VERSION=2.3.2
FOP_VERSION=2.0
OPENXLSX_VERSION=

##### DOWNLOAD #####
####################
download_dependencies() {
    [ ! -e gcc-$GCC_VERSION.tar.gz ] && curl -L -o gcc-$GCC_VERSION.tar.gz  ftp://ftp.lip6.fr/pub/gcc/releases/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz 
    [ ! -e apache-ant-$ANT_VERSION-bin.tar.gz ] && curl -L -o apache-ant-$ANT_VERSION-bin.tar.gz http://archive.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz
    [ ! -e OpenBLAS-$OPENBLAS_VERSION.tar.gz ] && curl -L -o OpenBLAS-$OPENBLAS_VERSION.tar.gz https://github.com/xianyi/OpenBLAS/archive/v$OPENBLAS_VERSION.tar.gz
    [ ! -e arpack-ng-$ARPACK_VERSION.tar.gz ] && curl -L -o arpack-ng-$ARPACK_VERSION.tar.gz https://github.com/opencollab/arpack-ng/archive/$ARPACK_VERSION.tar.gz
    [ ! -e curl-$CURL_VERSION.tar.gz ] && curl -L -o curl-$CURL_VERSION.tar.gz http://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz
    [ ! -e eigen-$EIGEN_VERSION.tar.gz ] && curl -L -o eigen-$EIGEN_VERSION.tar.gz http://bitbucket.org/eigen/eigen/get/$EIGEN_VERSION.tar.gz
    [ ! -e fftw-$FFTW_VERSION.tar.gz ] && curl -L -o fftw-$FFTW_VERSION.tar.gz http://www.fftw.org/fftw-$FFTW_VERSION.tar.gz
    [ ! -e hdf5-$HDF5_VERSION.tar.gz ] && curl -L -o hdf5-$HDF5_VERSION.tar.gz https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-$HDF5_VERSION/src/hdf5-$HDF5_VERSION.tar.gz
    [ ! -e libxml2-$LIBXML2_VERSION.tar.gz ] && curl -L -o libxml2-$LIBXML2_VERSION.tar.gz http://xmlsoft.org/sources/libxml2-$LIBXML2_VERSION.tar.gz
    [ ! -e matio-$MATIO_VERSION.tar.gz ] && curl -L -o matio-$MATIO_VERSION.tar.gz http://downloads.sourceforge.net/project/matio/matio/$MATIO_VERSION/matio-$MATIO_VERSION.tar.gz
    [ ! -e ocaml-$OCAML_VERSION.tar.gz ] && curl -L -o ocaml-$OCAML_VERSION.tar.gz http://caml.inria.fr/pub/distrib/ocaml-4.01/ocaml-$OCAML_VERSION.tar.gz
    [ ! -e openssl-$OPENSSL_VERSION.tar.gz ] && curl -L -o openssl-$OPENSSL_VERSION.tar.gz http://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
    [ ! -e SuiteSparse-$SUITESPARSE_VERSION.tar.gz ] && curl -L -o SuiteSparse-$SUITESPARSE_VERSION.tar.gz http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-$SUITESPARSE_VERSION.tar.gz
    [ ! -e pcre-$PCRE_VERSION.tar.gz ] && curl -L -o pcre-$PCRE_VERSION.tar.gz https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.tar.gz
    [ ! -e tcl$TCL_VERSION-src.tar.gz ] && curl -L -o tcl$TCL_VERSION-src.tar.gz http://prdownloads.sourceforge.net/tcl/tcl$TCL_VERSION-src.tar.gz
    [ ! -e tk$TK_VERSION-src.tar.gz ] && curl -L -o tk$TK_VERSION-src.tar.gz http://prdownloads.sourceforge.net/tcl/tk$TK_VERSION-src.tar.gz
    [ ! -e zlib-$ZLIB_VERSION.tar.gz ] && curl -L -o zlib-$ZLIB_VERSION.tar.gz http://downloads.sourceforge.net/project/libpng/zlib/$ZLIB_VERSION/zlib-$ZLIB_VERSION.tar.gz
    [ ! -e libpng-$PNG_VERSION.tar.gz ] && curl -L -o libpng-$PNG_VERSION.tar.gz http://prdownloads.sourceforge.net/libpng/libpng-$PNG_VERSION.tar.gz
    [ ! -e gluegen-v$JOGL_VERSION.tar.xz ] && curl -L -o gluegen-v$JOGL_VERSION.tar.xz https://jogamp.org/deployment/archive/rc/v$JOGL_VERSION/archive/Sources/gluegen-v$JOGL_VERSION.tar.xz
    [ ! -e gluegen-jcpp-v$JOGL_VERSION.zip ] && curl -L -o gluegen-jcpp-v$JOGL_VERSION.zip https://github.com/JogAmp/jcpp/archive/master.zip
    [ ! -e jogl-v$JOGL_VERSION.tar.xz ] && curl -L -o jogl-v$JOGL_VERSION.tar.xz https://jogamp.org/deployment/archive/rc/v$JOGL_VERSION/archive/Sources/jogl-v$JOGL_VERSION.tar.xz
    [ ! -d OpenXLSX ] && git clone git@github.com:troldal/OpenXLSX.git
    # xmlgraphics-commons is included within FOP
    # Batik is included within FOP
    [ ! -e fop-$FOP_VERSION-bin.zip ] && curl -L -o fop-$FOP_VERSION-bin.zip http://apache.mediamirrors.org//xmlgraphics/fop/binaries/fop-$FOP_VERSION-bin.zip
}

####################
##### BUILDERS #####
####################

build_gcc() {
	PATH=/home/$USER/bin:/usr/bin:/bin

	rm -fr gcc-$GCC_VERSION
	if [ ! -d gcc-$GCC_VERSION ]; then
		tar -xzf gcc-$GCC_VERSION.tar.gz
		mkdir gcc-$GCC_VERSION/gcc-build
	fi

	cd gcc-$GCC_VERSION
	[ -h mpfr ] || ./contrib/download_prerequisites
	
	cd gcc-build
	find -name config.cache -delete
	../configure --prefix=$INSTALLDIR --enable-language=c,c++,fortran \
                     --disable-multilib --disable-bootstrap
        make
        make install

	# cc bin is used by cmake
	cp -af  $INSTALLDIR/bin/gcc $INSTALLDIR/bin/cc

        # NEEDED FOR CLEAN DEPENDENCIES
	# rename GCC library names to SCI ones to avoid dependency on system ones
	patchelf --set-soname libsciquadmath.so.0 $INSTALLDIR$LIBDIR/libquadmath.so.0.0.0
	cp -a $INSTALLDIR$LIBDIR/libquadmath.so.0.0.0 $INSTALLDIR/lib/libsciquadmath.so.0
	patchelf --set-soname libscigfortran.so.5 $INSTALLDIR$LIBDIR/libgfortran.so.5.0.0
	cp -a $INSTALLDIR$LIBDIR/libgfortran.so.5.0.0 $INSTALLDIR/lib/libscigfortran.so.5
	patchelf --set-soname libscigcc_s.so.1 $INSTALLDIR$LIBDIR/libgcc_s.so.1
	cp -a $INSTALLDIR$LIBDIR/libgcc_s.so.1 $INSTALLDIR/lib/libscigcc_s.so.1
	patchelf --set-soname libscistdc++.so.6 $INSTALLDIR$LIBDIR/libstdc++.so.6.0.27
	cp -a $INSTALLDIR$LIBDIR/libstdc++.so.6.0.27 $INSTALLDIR/lib/libscistdc++.so.6
	
        cd ../..
}

build_openblas() {
    [ -d OpenBLAS-$OPENBLAS_VERSION ] && rm -fr OpenBLAS-$OPENBLAS_VERSION

    tar -xzf OpenBLAS-$OPENBLAS_VERSION.tar.gz
    cd OpenBLAS-$OPENBLAS_VERSION
    make TARGET=NEHALEM

    # install openblas for runtime usage
    cp -a libopenblas_nehalemp-r$OPENBLAS_VERSION.so $INSTALLDIR/lib/libopenblas.so.$OPENBLAS_VERSION

    # BLAS and LAPACK libs
    # TODO: only export BLAS / LAPACK ABI
    cp -a $INSTALLDIR/lib/libopenblas.so.$OPENBLAS_VERSION $INSTALLDIR/lib/libblas.so.3
    patchelf --set-soname libblas.so.3 $INSTALLDIR/lib/libblas.so.3
    ln -fs libblas.so.3 $INSTALLDIR/lib/libblas.so
    cp -a $INSTALLDIR/lib/libopenblas.so.$OPENBLAS_VERSION $INSTALLDIR/lib/liblapack.so.3
    patchelf --set-soname liblapack.so.3 $INSTALLDIR/lib/liblapack.so.3
    ln -fs liblapack.so.3 $INSTALLDIR/lib/liblapack.so
    
    cd -
    clean_static
}

build_ant() {
    [ -d $INSTALLDIR/../java/ant ] && rm -fr $INSTALLDIR/../java/ant
    [ -d $INSTALLDIR/../java/apache-ant-$ANT_VERSION ] && rm -fr $INSTALLDIR/../java/apache-ant-$ANT_VERSION

    cd $INSTALLDIR/../java/
    tar -xzf ../../apache-ant-$ANT_VERSION-bin.tar.gz
    ln -s apache-ant-$ANT_VERSION ant
    cd -
}

build_arpack() {
    [ -d arpack-ng-$ARPACK_VERSION ] && rm -fr arpack-ng-$ARPACK_VERSION

    tar -xzf arpack-ng-$ARPACK_VERSION.tar.gz
    cd arpack-ng-$ARPACK_VERSION
    ./configure "$@" --prefix=  F77=gfortran \
        --with-blas="$INSTALLDIR/lib/libblas.so" \
        --with-lapack="$INSTALLDIR/lib/liblapack.so"
    make
    make install DESTDIR=$INSTALLDIR

    cd -

    # remove gfortran stdlibs as they are provided as sci prefixed
    patchelf --remove-needed libquadmath.so.0 $INSTALLDIR/lib/libarpack.so

    clean_static
}

build_eigen() {
    [ -d eigen-eigen* ] && rm -fr eigen-eigen*

    tar -zxf eigen-$EIGEN_VERSION.tar.gz
    cd eigen-eigen*
    rm -fr $INSTALLDIR/include/Eigen
    cp -a Eigen $INSTALLDIR/include/
    cd -
}

build_hdf5() {
    [ -d hdf5-$HDF5_VERSION ] && rm -fr hdf5-$HDF5_VERSION

    tar -xzf hdf5-$HDF5_VERSION.tar.gz
    cd hdf5-$HDF5_VERSION
    sed -i -e 's|//int i1, i2;|/* int i1, i2; */|' tools/lib/h5diff.c
    sed -i "/LD_LIBRARY_PATH=\"\$\$LD_LIBRARY_PATH/,+1d" src/Makefile.in
    ./configure "$@" --with-zlib=$INSTALLDIR --enable-cxx --prefix=
    make
    make install DESTDIR=$INSTALLDIR
    cd -

    clean_static
}

build_fftw() {
    [ -d fftw-$FFTW_VERSION ] && rm -fr fftw-$FFTW_VERSION

    tar -xzf fftw-$FFTW_VERSION.tar.gz
    cd fftw-$FFTW_VERSION
    ./configure "$@" --enable-shared --prefix=
    make
    make install DESTDIR=$INSTALLDIR
    cd -

    clean_static
}

build_zlib() {
    [ -d zlib-$ZLIB_VERSION ] && rm -fr zlib-$ZLIB_VERSION

    tar -xzf zlib-$ZLIB_VERSION.tar.gz
    cd zlib-$ZLIB_VERSION
    ./configure "$@" --prefix=
    make
    make install DESTDIR=$INSTALLDIR
    cd -

    # Rename libz to scilibz
    mv $INSTALLDIR/lib/libz.so.$ZLIB_VERSION $INSTALLDIR/lib/libsciz.so.$ZLIB_VERSION
    ln -sf libsciz.so.$ZLIB_VERSION $INSTALLDIR/lib/libz.so
    rm  $INSTALLDIR/lib/libz.so.*
    ln -sf libsciz.so.$ZLIB_VERSION $INSTALLDIR/lib/libsciz.so
    ln -sf libsciz.so.$ZLIB_VERSION $INSTALLDIR/lib/libsciz.so.1
    patchelf --set-soname libsciz.so.1 $INSTALLDIR/lib/libsciz.so.$ZLIB_VERSION

    clean_static
}

build_libpng() {
    [ -d libpng-$PNG_VERSION ] && rm -fr libpng-$PNG_VERSION

    tar -xzf libpng-$PNG_VERSION.tar.gz
    cd libpng-$PNG_VERSION
    ./configure "$@" --prefix= LDFLAGS="-L$INSTALLDIR/lib" CPPFLAGS="-I$INSTALLDIR/include"
    make LDFLAGS="-L$INSTALLDIR/lib -lsciz" CPPFLAGS="-I$INSTALLDIR/include"
    make install DESTDIR=$INSTALLDIR
    cd -

    clean_static
}

build_openssl() {
    [ -d openssl-$OPENSSL_VERSION ] && rm -fr openssl-$OPENSSL_VERSION

    tar -xzf openssl-$OPENSSL_VERSION.tar.gz
    cd openssl-$OPENSSL_VERSION
    ./config shared --prefix=$INSTALLDIR --openssldir=$INSTALLDIR
    make depend all

    # install at the right location
    cp -a -t $INSTALLDIR/lib/ libssl.so* libcrypto.so*
    
    cd -

    clean_static
}


build_tcl() {
    [ -d tcl$TCL_VERSION ] && rm -fr tcl$TCL_VERSION

    tar -xzf tcl$TCL_VERSION-src.tar.gz
    cd tcl$TCL_VERSION/unix
    ./configure "$@" --prefix=
    make
    make install DESTDIR=$INSTALLDIR
    chmod 644 $INSTALLDIR/lib/libtcl*.*
    cd -

    clean_static
}

build_tk() {
    [ -d tk$TK_VERSION ] && rm -fr tk$TK_VERSION

    tar -xzf tk$TK_VERSION-src.tar.gz
    cd tk$TK_VERSION/unix
    ./configure "$@" --prefix=
    make 
    make install DESTDIR=$INSTALLDIR
    chmod 644 $INSTALLDIR/lib/libtk*.*
    cd -

    clean_static
}

build_matio() {
    [ -d matio-$MATIO_VERSION ] && rm -fr matio-$MATIO_VERSION

    tar -xzf matio-$MATIO_VERSION.tar.gz
    cd matio-$MATIO_VERSION
    ./configure "$@" --enable-shared --with-hdf5=$INSTALLDIR --with-zlib=$INSTALLDIR --prefix=
    make
    make install DESTDIR=$INSTALLDIR
    cd -

    clean_static
}

build_pcre() {
    [ -d pcre-$PCRE_VERSION ] && rm -fr pcre-$PCRE_VERSION

    tar -xzf pcre-$PCRE_VERSION.tar.gz
    cd pcre-$PCRE_VERSION
    ./configure "$@" --enable-utf8 --enable-unicode-properties --prefix=
    make
    make install DESTDIR=$INSTALLDIR
    cd -
    sed -i -e 's|^\prefix=.*|\prefix=`pwd`'"/usr|" $INSTALLDIR/bin/pcre-config

    clean_static
}

build_libxml2() {
    [ -d libxml2-$LIBXML2_VERSION ] && rm -fr libxml2-$LIBXML2_VERSION

    tar -xzf libxml2-$LIBXML2_VERSION.tar.gz
    cd libxml2-$LIBXML2_VERSION
    ./configure "$@" --without-python --with-zlib=$INSTALLDIR --prefix=
    make 
    make install DESTDIR=$INSTALLDIR
    cd -
    sed -i -e 's|^\prefix=.*|\prefix=`pwd`'"/usr|" $INSTALLDIR/bin/xml2-config

    # Rename xml2 to scixml2
    mv $INSTALLDIR/lib/libxml2.so.$LIBXML2_VERSION $INSTALLDIR/lib/libscixml2.so.$LIBXML2_VERSION
    ln -sf libscixml2.so.$LIBXML2_VERSION $INSTALLDIR/lib/libxml2.so
    rm $INSTALLDIR/lib/libxml2.so.*
    ln -sf libscixml2.so.$LIBXML2_VERSION $INSTALLDIR/lib/libscixml2.so
    ln -sf libscixml2.so.$LIBXML2_VERSION $INSTALLDIR/lib/libscixml2.so.2
    patchelf --set-soname libscixml2.so.2 $INSTALLDIR/lib/libscixml2.so.$LIBXML2_VERSION

    clean_static
}

build_curl() {
    [ -d curl-$CURL_VERSION ] && rm -fr curl-$CURL_VERSION

    tar -zxf curl-$CURL_VERSION.tar.gz
    cd curl-$CURL_VERSION
    ./configure "$@" \
	--without-ca-bundle --with-ca-fallback \
        --with-ssl=$INSTALLDIR --without-nss \
        --with-zlib=$INSTALLDIR \
        --prefix= \
        CFLAGS="-O2 -g"
    make 
    make install DESTDIR=$INSTALLDIR
    cd -
    sed -i -e 's|^\prefix=.*|\prefix=`pwd`'"/usr|" $INSTALLDIR/bin/curl-config

    clean_static
}

build_ocaml() {
    [ -d ocaml-$OCAML_VERSION ] && rm -fr ocaml-$OCAML_VERSION

    tar -zxf ocaml-$OCAML_VERSION.tar.gz
    cd ocaml-$OCAML_VERSION
    ./configure "$@" -prefix $INSTALLDIR
    make world bootstrap opt
    make install
    cd -
    echo "Do not forget to add $INSTALLDIR/bin/ to your PATH variable."
}

build_suitesparse() {
    [ -d SuiteSparse ] && rm -fr SuiteSparse

    tar -zxf SuiteSparse-$SUITESPARSE_VERSION.tar.gz
    cd SuiteSparse
    sed -i -e 's|^\INSTALL_LIB = .*|\INSTALL_LIB = '"$INSTALLDIR"'\/lib\/|' SuiteSparse_config/SuiteSparse_config.mk
    sed -i -e 's|^\INSTALL_INCLUDE = .*|\INSTALL_INCLUDE = '"$INSTALLDIR"'\/include\/|' SuiteSparse_config/SuiteSparse_config.mk
    make library
    make install

    UMFPACK_VERSION=$(grep -m1 VERSION UMFPACK/Makefile | sed -e "s|\VERSION = ||")

    # See http://slackware.org.uk/slacky/slackware-12.2/development/suitesparse/3.1.0/src/suitesparse.SlackBuild
    # libamd.so
    AMD_VERSION=$(grep -m1 VERSION AMD/Makefile | sed -e "s|\VERSION = ||")
    AMD_MAJOR_VERSION=$(echo "$AMD_VERSION" | awk -F \. {'print $1'})
    cd AMD/Lib/
    gcc -shared -Wl,-soname,libamd.so.${AMD_MAJOR_VERSION} -o libamd.so.${AMD_VERSION} `ls *.o`
    rm -f $INSTALLDIR/lib/libamd.so*
    cp libamd.so.${AMD_VERSION} $INSTALLDIR/lib/
    cd ../..

    # libcamd.so
    CAMD_VERSION=$(grep -m1 VERSION CAMD/Makefile | sed -e "s|\VERSION = ||")
    CAMD_MAJOR_VERSION=$(echo "$CAMD_VERSION" | awk -F \. {'print $1'})
    cd CAMD/Lib/
    gcc -shared -Wl,-soname,libcamd.so.${CAMD_MAJOR_VERSION} -o libcamd.so.${CAMD_VERSION} `ls *.o`
    rm -f $INSTALLDIR/lib/libcamd.so*
    cp libcamd.so.${CAMD_VERSION} $INSTALLDIR/lib/
    cd ../..

    # libcolamd.so
    COLAMD_VERSION=$(grep -m1 VERSION COLAMD/Makefile | sed -e "s|\VERSION = ||")
    COLAMD_MAJOR_VERSION=$(echo "$COLAMD_VERSION" | awk -F \. {'print $1'})
    cd COLAMD/Lib/
    gcc -shared -Wl,-soname,libcolamd.so.${COLAMD_MAJOR_VERSION} -o libcolamd.so.${COLAMD_VERSION} `ls *.o`
    rm -f $INSTALLDIR/lib/libcolamd.so*
    cp libcolamd.so.${COLAMD_VERSION} $INSTALLDIR/lib/
    cd ../..

    # libccolamd.so
    CCOLAMD_VERSION=$(grep -m1 VERSION CCOLAMD/Makefile | sed -e "s|\VERSION = ||")
    CCOLAMD_MAJOR_VERSION=$(echo "$CCOLAMD_VERSION" | awk -F \. {'print $1'})
    cd CCOLAMD/Lib/
    gcc -shared -Wl,-soname,libccolamd.so.${CCOLAMD_MAJOR_VERSION} -o libccolamd.so.${CCOLAMD_VERSION} `ls *.o`
    rm -f $INSTALLDIR/lib/libccolamd.so*
    cp libccolamd.so.${CCOLAMD_VERSION} $INSTALLDIR/lib/
    cd ../..

    # libcholmod.so
    CHOLMOD_VERSION=$(grep -m1 VERSION CHOLMOD/Makefile | sed -e "s|\VERSION = ||")
    CHOLMOD_MAJOR_VERSION=$(echo "$CHOLMOD_VERSION" | awk -F \. {'print $1'})
    cd CHOLMOD/Lib/
    gcc -shared -Wl,-soname,libcholmod.so.${CHOLMOD_MAJOR_VERSION} -o libcholmod.so.${CHOLMOD_VERSION} `ls *.o`
    rm -f $INSTALLDIR/lib/libcholmod.so*
    cp libcholmod.so.${CHOLMOD_VERSION} $INSTALLDIR/lib/
    cd ../..

    # libumfpack.so
    UMFPACK_VERSION=$(grep -m1 VERSION UMFPACK/Makefile | sed -e "s|\VERSION = ||")
    UMFPACK_MAJOR_VERSION=$(echo "$UMFPACK_VERSION" | awk -F \. {'print $1'})
    cd UMFPACK/Lib
    gcc -shared -Wl,-soname,libumfpack.so.${UMFPACK_MAJOR_VERSION} -o libumfpack.so.${UMFPACK_VERSION} `ls *.o` \
      $INSTALLDIR/lib/libsuitesparseconfig.a \
      $INSTALLDIR/lib/libscigfortran.so.5 $INSTALLDIR/lib/libsciquadmath.so.0 \
      $INSTALLDIR/lib/libblas.so.3 $INSTALLDIR/lib/liblapack.so.3 -lm -lrt \
      $INSTALLDIR/lib/libcholmod.so.${CHOLMOD_VERSION} $INSTALLDIR/lib/libcolamd.so.${COLAMD_VERSION} \
      $INSTALLDIR/lib/libccolamd.so.${CCOLAMD_VERSION} $INSTALLDIR/lib/libcamd.so.${CAMD_VERSION}
    rm -f $INSTALLDIR/lib/libumfpack.so*
    cp libumfpack.so.${UMFPACK_VERSION} $INSTALLDIR/lib/
    cd ../..

    cd $INSTALLDIR/lib/
    ln -fs libamd.so.${AMD_VERSION} libamd.so
    ln -fs libamd.so.${AMD_VERSION} libamd.so.${AMD_MAJOR_VERSION}
    ln -fs libcamd.so.${CAMD_VERSION} libcamd.so
    ln -fs libcamd.so.${CAMD_VERSION} libcamd.so.${AMD_MAJOR_VERSION}
    ln -fs libcolamd.so.${COLAMD_VERSION} libcolamd.so
    ln -fs libcolamd.so.${COLAMD_VERSION} libcolamd.so.${COLAMD_MAJOR_VERSION}
    ln -fs libccolamd.so.${CCOLAMD_VERSION} libccolamd.so
    ln -fs libccolamd.so.${CCOLAMD_VERSION} libccolamd.so.${CCOLAMD_MAJOR_VERSION}
    ln -fs libcholmod.so.${CHOLMOD_VERSION} libcholmod.so
    ln -fs libcholmod.so.${CHOLMOD_VERSION} libcholmod.so.${CHOLMOD_MAJOR_VERSION}
    ln -fs libumfpack.so.${UMFPACK_VERSION} libumfpack.so
    ln -fs libumfpack.so.${UMFPACK_VERSION} libumfpack.so.${UMFPACK_MAJOR_VERSION}
    cd -
    cd ..

    clean_static
}

build_gluegen() {
    [ -d gluegen-v$JOGL_VERSION ] && rm -fr gluegen-v$JOGL_VERSION
    
    tar -xJf gluegen-v$JOGL_VERSION.tar.xz
    cd gluegen-v$JOGL_VERSION
    unzip ../gluegen-jcpp-v$JOGL_VERSION.zip
    rm -fr jcpp && mv jcpp-master jcpp
    cd ..

    export ANT_HOME=$(pwd)/$SPECIFICDIR/java/ant
    export JAVA_HOME=/home/$USER/jdk
    cd gluegen-v$JOGL_VERSION/make
    ../../$SPECIFICDIR/java/ant/bin/ant
    cd -

    cp -a gluegen-v$JOGL_VERSION/build/obj/libgluegen-rt.so $INSTALLDIR/lib
    cp -a gluegen-v$JOGL_VERSION/build/gluegen-rt.jar $INSTALLDIR/share/java
 
    clean_static
}

build_jogl() {
    [ -d jogl-v$JOGL_VERSION ] && rm -fr jogl-v$JOGL_VERSION

    tar -xJf jogl-v$JOGL_VERSION.tar.xz

    ln -fs gluegen-v$JOGL_VERSION gluegen
    export ANT_HOME=$(pwd)/$SPECIFICDIR/java/ant
    export JAVA_HOME=/home/$USER/jdk
    cd jogl-v$JOGL_VERSION/make
    ../../$SPECIFICDIR/java/ant/bin/ant
    cd -

    cp -a jogl-v$JOGL_VERSION/build/obj/libjogl.so $INSTALLDIR/lib
    cp -a jogl-v$JOGL_VERSION/build/jogl.jar $INSTALLDIR/share/java
}

build_openxlsx() {
    cd OpenXLSX
    git clean -fXd OpenXLSX

    rm -fr build    
    mkdir build && cd build
    cmake ..
    make

    cp -a install/include/OpenXLSX $INSTALLDIR/include/
    cp -a install/lib/libOpenXLSX.so $INSTALLDIR/lib/
}

clean_static() {
        rm -f $INSTALLDIR/lib/*.la # Avoid message about moved library while compiling
        find $INSTALLDIR/lib \( -name '*.a' -or -name '*.a.*' \) -a -not -name 'libgcc.a' -exec rm {} +
}

#########################
##### DEFAULT FLAGS #####
#########################
export CFLAGS="-O2 -g"
export CXXFLAGS="-O2 -g"
export FFLAGS="-O2 -g"
export LDFLAGS="-O2 -g"

###################################
##### GIT CLONE CONFIGURATION #####
###################################
#ln -s ../../linux-prerequisites-sources/linux/Linux-i686/ .
#ln -s ../../linux-prerequisites-sources/linux/lib/ .
#ln -s ../../linux-prerequisites-sources/linux/java/ .
#ln -s ../../linux-prerequisites-sources/linux/thirdparty/ .


###############################
##### ARGUMENT MANAGEMENT #####
###############################
while [ $# -gt 0 ]
do
  case "$1" in

    "versions")
      echo "GCC_VERSION         = $GCC_VERSION"
      echo "BLAS_VERSION        = $BLAS_VERSION"
      echo "LAPACK_VERSION      = $LAPACK_VERSION"
      echo "OPENBLAS_VERSION    = $OPENBLAS_VERSION"
      echo "ATLAS_VERSION       = $ATLAS_VERSION"
      echo "ANT_VERSION         = $ANT_VERSION"
      echo "ARPACK_VERSION      = $ARPACK_VERSION"
      echo "CURL_VERSION        = $CURL_VERSION"
      echo "EIGEN_VERSION       = $EIGEN_VERSION"
      echo "FFTW_VERSION        = $FFTW_VERSION"
      echo "HDF5_VERSION        = $HDF5_VERSION"
      echo "LIBXML2_VERSION     = $LIBXML2_VERSION"
      echo "MATIO_VERSION       = $MATIO_VERSION"
      echo "OCAML_VERSION       = $OCAML_VERSION"
      echo "OPENSSL_VERSION     = $OPENSSL_VERSION"
      echo "PCRE_VERSION        = $PCRE_VERSION"
      echo "SUITESPARSE_VERSION = $SUITESPARSE_VERSION"
      echo "TCL_VERSION         = $TCL_VERSION"
      echo "TK_VERSION          = $TK_VERSION"
      echo "ZLIB_VERSION        = $ZLIB_VERSION"
      echo "PNG_VERSION         = $PNG_VERSION"
      exit 0;
      ;;

    "fromscratch")
      sh $0 init
      sh $0 download
      sh $0 all
      sh $0 binary
      exit 0;
      ;;

    "init")
      rsync -rl --exclude=.svn $DEVTOOLSDIR/java $INSTALLDIR/..
      if [ "$MACHINE" = "x86_64" ]; then
        rm -rf $INSTALLDIR/../java/apache-ant $INSTALLDIR/../java/apache-ant-1.7.1
      fi
      rsync -rl --exclude=.svn $DEVTOOLSDIR/thirdparty $INSTALLDIR/..
      rsync -rl --exclude=.svn $DEVTOOLSDIR/modules $INSTALLDIR/..
      mkdir $INSTALLDIR/../lib/
      rsync -rl --exclude=.svn $DEVTOOLSDIR/lib/thirdparty $INSTALLDIR/../lib
      exit 0;
      ;;

    "download")
      download_dependencies
      shift
      ;;

    "binary")
      ########################
      ##### TCL/TK stuff #####
      ########################
      rsync -rl --exclude=.svn $INSTALLDIR/lib/tcl* $INSTALLDIR/../modules/tclsci/tcl
      rsync -rl --exclude=.svn $INSTALLDIR/lib/tk* $INSTALLDIR/../modules/tclsci/tcl
      rm $INSTALLDIR/../modules/tclsci/tcl/tclConfig.sh
      rm $INSTALLDIR/../modules/tclsci/tcl/tkConfig.sh
      rm -rf $INSTALLDIR/../modules/tclsci/tk8.5/demos/ # See bug #3869

      #################
      ##### EIGEN #####
      #################
      mkdir -p $INSTALLDIR/../lib/Eigen/include/
      cp -R $INSTALLDIR/include/Eigen/ $INSTALLDIR/../lib/Eigen/include/

      #####################################
      ##### lib/thirdparty/ directory #####
      #####################################

      LIBTHIRDPARTYDIR=$INSTALLDIR/../lib/thirdparty

      # Provide OpenBLAS blas and lapack
      # ensure that ld.so always load the same "real" file to reduce overhead
      rm -f $LIBTHIRDPARTYDIR/libatlas.*
      rm -f $LIBTHIRDPARTYDIR/lib*blas.*
      rm -f $LIBTHIRDPARTYDIR/liblapack.*
      cp -d $INSTALLDIR/lib/libopenblas.so* $LIBTHIRDPARTYDIR/
      ln -fs libopenblas.so.$OPENBLAS_VERSION $LIBTHIRDPARTYDIR/libblas.so.3
      ln -fs libopenblas.so.$OPENBLAS_VERSION $LIBTHIRDPARTYDIR/liblapack.so.3

      rm -f $LIBTHIRDPARTYDIR/libarpack.*
      cp -d $INSTALLDIR/lib/libarpack.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libcrypto.*
      cp -d $INSTALLDIR/lib/libcrypto.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libcurl.*
      cp -d $INSTALLDIR/lib/libcurl.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libfftw3.*
      cp -d $INSTALLDIR/lib/libfftw3.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libhdf5_hl.*
      cp -d $INSTALLDIR/lib/libhdf5_hl.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libhdf5.*
      cp -d $INSTALLDIR/lib/libhdf5.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libmatio.*
      cp -d $INSTALLDIR/lib/libmatio.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libpcreposix.*
      cp -d $INSTALLDIR/lib/libpcreposix.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libpcre.*
      cp -d $INSTALLDIR/lib/libpcre.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libssl.*
      cp -d $INSTALLDIR/lib/libssl.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libtcl*.*
      cp -d $INSTALLDIR/lib/libtcl*.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libtk*.*
      cp -d $INSTALLDIR/lib/libtk*.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libumfpack.*
      cp -d $INSTALLDIR/lib/libumfpack.* $LIBTHIRDPARTYDIR/
      rm -f $LIBTHIRDPARTYDIR/libamd.*
      cp -d $INSTALLDIR/lib/libamd.* $LIBTHIRDPARTYDIR/
      rm -f $LIBTHIRDPARTYDIR/libcholmod.*
      cp -d $INSTALLDIR/lib/libcholmod.* $LIBTHIRDPARTYDIR/
      rm -f $LIBTHIRDPARTYDIR/libcolamd.*
      cp -d $INSTALLDIR/lib/libcolamd.* $LIBTHIRDPARTYDIR/
      rm -f $LIBTHIRDPARTYDIR/libccolamd.*
      cp -d $INSTALLDIR/lib/libccolamd.* $LIBTHIRDPARTYDIR/
      rm -f $LIBTHIRDPARTYDIR/libcamd.*
      cp -d $INSTALLDIR/lib/libcamd.* $LIBTHIRDPARTYDIR/

      rm -f $LIBTHIRDPARTYDIR/libOpenXLSX.*
      cp -d $INSTALLDIR/lib/libOpenXLSX.* $LIBTHIRDPARTYDIR/

      # Scilab dependencies where the system ones are not recent enough to be used.
      #
      # The system dependencies are supposed to be conformant to the latest 
      # Linux Standard Base 5.0.0 ; Scilab requires more recent versions.

      rm -fr $LIBTHIRDPARTYDIR/redist && mkdir $LIBTHIRDPARTYDIR/redist/

      rm -f $LIBTHIRDPARTYDIR/libz.* $LIBTHIRDPARTYDIR/libsciz.*
      rm -f $LIBTHIRDPARTYDIR/redist/libz.* $LIBTHIRDPARTYDIR/redist/libsciz.*
      cp -d $INSTALLDIR/lib/libsciz.* $LIBTHIRDPARTYDIR/redist/

      rm -f $LIBTHIRDPARTYDIR/libpng*
      rm -f $LIBTHIRDPARTYDIR/redist/libpng*
      # do not re-ship libpng16 it is now present on most machines
      # cp -d $INSTALLDIR/lib/libpng* $LIBTHIRDPARTYDIR/redist/

      rm -f $LIBTHIRDPARTYDIR/libxml2.* $LIBTHIRDPARTYDIR/libscixml2.*
      rm -f $LIBTHIRDPARTYDIR/redist/libxml2.* $LIBTHIRDPARTYDIR/redist/libscixml2.*
      cp -d $INSTALLDIR/lib/libscixml2.* $LIBTHIRDPARTYDIR/redist/

      # GCC libs could be there but are prefixed with "sci" to avoid clashing
      # system libraries static linked into scilab libraries instead.  This
      # avoid compilers (and support libraries) version mismatch between gcc
      # used here and user's gcc (probably more recent)
      cp -d $INSTALLDIR/lib/libsciquadmath.so* $LIBTHIRDPARTYDIR/redist/
      cp -d $INSTALLDIR/lib/libscigfortran.so* $LIBTHIRDPARTYDIR/redist/
      cp -d $INSTALLDIR/lib/libscigcc_s.so* $LIBTHIRDPARTYDIR/redist/
      cp -d $INSTALLDIR/lib/libscistdc++.so* $LIBTHIRDPARTYDIR/redist/

      # In case these libraries are not found on the system.
      #
      # The ".so" is not shipped on purpose for compilers support libraries,
      # the user should build on the reference system.
      # The mandatory libraries are the ones documented in the Linux Standard
      # Base 5.0 .

      # libncurses.so.5
      rm -f $LIBTHIRDPARTYDIR/libncurses.*
      rm -f $LIBTHIRDPARTYDIR/redist/libncurses.*
      cp -d $LIBDIR/libncurses.so.5.7 $LIBTHIRDPARTYDIR/redist/
      ln -fs libncurses.so.5.7 $LIBTHIRDPARTYDIR/redist/libncurses.so.5
      ln -fs libncurses.so.5.7 $LIBTHIRDPARTYDIR/redist/libncurses.so


      # Strip libraries (exporting the debuginfo to another file) to
      # reduce file size and thus startup time
      find $LIBTHIRDPARTYDIR -name '*.so*' -type f | while read file ;
      do
        [[ $file == *.debug ]] && continue
        objcopy --only-keep-debug $file $file.debug
        objcopy --strip-debug $file
        objcopy --add-gnu-debuglink=$file.debug $file || true
      done

      shift
      ;;

  "jar")
    # JAR management
    # we usually do not need to recompile JARs and we also re-use major jar 
    # dependencies (shipped into the binary zip)

    JAVATHIRDPARTYDIR=$INSTALLDIR/../thirdparty

    # XMLGraphics (included in FOP)
    # Batik (included in FOP)
    # FOP
    rm -f $JAVATHIRDPARTYDIR/fop-*
    rm -fr fop-$FOP_VERSION
    unzip fop-$FOP_VERSION-bin.zip fop-$FOP_VERSION/build/*.jar fop-$FOP_VERSION/lib/*.jar
    rm -f $JAVATHIRDPARTYDIR/fop*
    cp -a fop-$FOP_VERSION/build/fop.jar $JAVATHIRDPARTYDIR/
    rm -f $JAVATHIRDPARTYDIR/avalon-framework*
    cp -a fop-$FOP_VERSION/lib/avalon-framework-*.jar $JAVATHIRDPARTYDIR/avalon-framework.jar
    rm -f $JAVATHIRDPARTYDIR/batik-*
    cp -a fop-$FOP_VERSION/lib/batik-all-*.jar $JAVATHIRDPARTYDIR/batik-all.jar
    rm -f $JAVATHIRDPARTYDIR/commons-io-*
    cp -a fop-$FOP_VERSION/lib/commons-io-*.jar $JAVATHIRDPARTYDIR/commons-io.jar
    rm -f $JAVATHIRDPARTYDIR/commons-logging-*
    cp -a fop-$FOP_VERSION/lib/commons-logging-*.jar $JAVATHIRDPARTYDIR/commons-logging.jar
    rm -f $JAVATHIRDPARTYDIR/fontbox-*
    cp -a fop-$FOP_VERSION/lib/fontbox-*.jar $JAVATHIRDPARTYDIR/fontbox.jar
    rm -f $JAVATHIRDPARTYDIR/xml-apis-ext-*
    cp -a fop-$FOP_VERSION/lib/xml-apis-ext*.jar $JAVATHIRDPARTYDIR/xml-apis-ext.jar
    rm -f $JAVATHIRDPARTYDIR/xml-apis-1*
    cp -a fop-$FOP_VERSION/lib/xml-apis-1*.jar $JAVATHIRDPARTYDIR/xml-apis.jar
    rm -f $JAVATHIRDPARTYDIR/xmlgraphics-commons*
    cp -a fop-$FOP_VERSION/lib/xmlgraphics-commons-*.jar $JAVATHIRDPARTYDIR/xmlgraphics-commons.jar

    exit 0;
    ;;

  "all")
    build_openblas
    build_ant
    build_eigen
    build_zlib
    build_hdf5
    build_pcre
    build_fftw
    build_libxml2
    build_arpack
    build_suitesparse
    build_tcl
    build_tk
    build_matio
    build_openssl
    build_curl
    build_openxlsx

    exit 0;
    ;;

  *)
    # Call the build_$1 function if there is one
    declare -f -F build_$1 >/dev/null
    if [ $? -eq 1 ]; then
        echo "Unknown dependency name $DEPENDENCY"
        exit 42
    fi
    build_$1
    shift;
    ;;
esac
done

