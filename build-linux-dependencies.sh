#!/bin/sh -e

set -e
set -x

if test $# -ne 1; then
    echo "This script compiles dependencies of Scilab for Linux."
    echo
    echo "Syntax : $0 <dependency> with dependency equal to:"
    echo " - 'versions': display versions of dependencies,"
    echo " - 'download': download all dependencies,"
    echo " - 'all': compile all dependencies,"
    echo " - 'ocaml': compile Ocaml compiler and install it in $HOME/ocaml/,"
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
else
    echo "Unknown kernel $KERNEL"
    exit
fi

echo "Scilab prerequirements for $(uname -s)-$(uname -m)"

#INSTALLDIR=$(pwd)/$SPECIFICDIR/$KERNEL-$MACHINE
INSTALLDIR=$(pwd)/$SPECIFICDIR/usr
DEVTOOLSDIR=$(pwd)/../../../../../Dev-Tools

echo
echo "INSTALLDIR     = $INSTALLDIR"
echo "DEVTOOLSDIR    = $DEVTOOLSDIR"
echo

#[ ! -d $DEVTOOLSDIR ] && echo "Dev-tools directory not found" && exit

[ ! -d $INSTALLDIR ] && mkdir $INSTALLDIR -p

################################
##### DEPENDENCIES VERSION #####
################################
LAPACK_VERSION=3.6.0
ATLAS_VERSION=3.10.2
OPENBLAS_VERSION=0.2.20
ANT_VERSION=1.9.4
ARPACK_VERSION=3.1.5
CURL_VERSION=7.43.0
EIGEN_VERSION=3.2.1
FFTW_VERSION=3.3.3
HDF5_VERSION=1.8.8
LIBXML2_VERSION=2.9.1
MATIO_VERSION=1.5.2
OCAML_VERSION=4.01.0
OPENSSL_VERSION=0.9.8za
OPENSSH_VERSION=7.5p1
PCRE_VERSION=8.38
SUITESPARSE_VERSION=4.4.5
TCL_VERSION=8.5.15
TK_VERSION=8.5.15
ZLIB_VERSION=1.2.8
PNG_VERSION=1.6.34
JOGL_VERSION=2.2.4

FOP_VERSION=2.0

##### DOWNLOAD #####
####################
function download_dependencies() {
    [ ! -e lapack-$LAPACK_VERSION.tgz ] && wget http://www.netlib.org/lapack/lapack-$LAPACK_VERSION.tgz
    [ ! -e atlas$ATLAS_VERSION.tar.bz2 ] && wget http://downloads.sourceforge.net/project/math-atlas/Stable/$ATLAS_VERSION/atlas$ATLAS_VERSION.tar.bz2
    [ ! -e apache-ant-$ANT_VERSION-bin.tar.gz ] && wget http://archive.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz
    [ ! -e OpenBLAS-$OPENBLAS_VERSION.tar.gz ] && wget https://github.com/xianyi/OpenBLAS/archive/v$OPENBLAS_VERSION.tar.gz && mv v$OPENBLAS_VERSION.tar.gz OpenBLAS-$OPENBLAS_VERSION.tar.gz 
    [ ! -e arpack-ng-$ARPACK_VERSION.tar.gz ] && wget https://github.com/opencollab/arpack-ng/archive/$ARPACK_VERSION.tar.gz && mv $ARPACK_VERSION.tar.gz arpack-ng-$ARPACK_VERSION.tar.gz 
    [ ! -e curl-$CURL_VERSION.tar.gz ] && wget http://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz
    [ ! -e eigen-$EIGEN_VERSION.tar.gz ] && wget http://bitbucket.org/eigen/eigen/get/$EIGEN_VERSION.tar.gz && mv $EIGEN_VERSION.tar.gz eigen-$EIGEN_VERSION.tar.gz
    [ ! -e fftw-$FFTW_VERSION.tar.gz ] && wget http://www.fftw.org/fftw-$FFTW_VERSION.tar.gz
    [ ! -e hdf5-$HDF5_VERSION.tar.gz ] && wget http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-$HDF5_VERSION/src/hdf5-$HDF5_VERSION.tar.gz
    [ ! -e libxml2-$LIBXML2_VERSION.tar.gz ] && wget http://xmlsoft.org/sources/libxml2-$LIBXML2_VERSION.tar.gz
    [ ! -e matio-$MATIO_VERSION.tar.gz ] && wget http://downloads.sourceforge.net/project/matio/matio/$MATIO_VERSION/matio-$MATIO_VERSION.tar.gz
    [ ! -e ocaml-$OCAML_VERSION.tar.gz ] && wget http://caml.inria.fr/pub/distrib/ocaml-4.01/ocaml-$OCAML_VERSION.tar.gz
    [ ! -e openssl-$OPENSSL_VERSION.tar.gz ] && wget http://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
    [ ! -e openssh-$OPENSSH_VERSION.tar.gz ] && wget https://mirrors.ircam.fr/pub/OpenBSD/OpenSSH/portable/openssh-$OPENSSH_VERSION.tar.gz
    [ ! -e SuiteSparse-$SUITESPARSE_VERSION.tar.gz ] && wget http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-$SUITESPARSE_VERSION.tar.gz
    [ ! -e pcre-$PCRE_VERSION.tar.gz ] && wget https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.tar.gz
    [ ! -e tcl$TCL_VERSION-src.tar.gz ] && wget http://prdownloads.sourceforge.net/tcl/tcl$TCL_VERSION-src.tar.gz
    [ ! -e tk$TK_VERSION-src.tar.gz ] && wget http://prdownloads.sourceforge.net/tcl/tk$TK_VERSION-src.tar.gz
    [ ! -e zlib-$ZLIB_VERSION.tar.gz ] && wget http://downloads.sourceforge.net/project/libpng/zlib/$ZLIB_VERSION/zlib-$ZLIB_VERSION.tar.gz
    [ ! -e libpng-$PNG_VERSION.tar.gz ] && wget http://prdownloads.sourceforge.net/libpng/libpng-$PNG_VERSION.tar.gz
    [ ! -e gluegen-v$JOGL_VERSION.tar.7z ] && wget https://jogamp.org/deployment/archive/rc/v$JOGL_VERSION/archive/Sources/gluegen-v$JOGL_VERSION.tar.7z
    [ ! -e jogl-v$JOGL_VERSION.tar.7z ] && wget https://jogamp.org/deployment/archive/rc/v$JOGL_VERSION/archive/Sources/jogl-v$JOGL_VERSION.tar.7z

    # xmlgraphics-commons is included within FOP
    # Batik is included within FOP
    [ ! -e fop-$FOP_VERSION-bin.zip ] && wget http://wwwftp.ciril.fr/pub/apache/xmlgraphics/fop/binaries/fop-$FOP_VERSION-bin.zip
}

####################
##### BUILDERS #####
####################

function build_lapack() {
    [ -d lapack-$LAPACK_VERSION ] && rm -fr lapack-$LAPACK_VERSION

    tar -xzf lapack-$LAPACK_VERSION.tgz
    mkdir lapack-$LAPACK_VERSION/BUILD
    cd lapack-$LAPACK_VERSION/BUILD
    cmake28 .. \
        -DBUILD_DEPRECATED:BOOL=ON \
        -DCMAKE_Fortran_COMPILER_NAMES=gfortran -DBUILD_SHARED_LIBS:BOOL=ON -DCMAKE_SKIP_RPATH:BOOL=ON \
        -DCMAKE_SHARED_LINKER_FLAGS='-Wl,--no-undefined'
    make blas lapack
    cd -

    rm -f $INSTALLDIR/lib/lib*atlas* $INSTALLDIR/lib/lib*blas* $INSTALLDIR/lib/lib*lapack*
    cp -a -t $INSTALLDIR/lib/ lapack-$LAPACK_VERSION/BUILD/lib/lib*.so*
}

function build_atlas() {
    [ -d ATLAS ] && rm -fr ATLAS/
    
    tar -xjf atlas$ATLAS_VERSION.tar.bz2
    patch -p0 <<EOF
--- ATLAS/CONFIG/src/config.c
+++ ATLAS/CONFIG/src/config.c
@@ -688,6 +688,8 @@ int ProbeNcpu(int verb, char *targarg, e
 
 int ProbePtrbits(int verb, char *targarg, enum OSTYPE OS, enum ASMDIA asmb)
 {
+   return sizeof(void*) * 8; /* building on a chroot might not detect the right arch */
+                             /* inline it there */
    int i, iret;
    char *ln;
 
@@ -711,6 +713,8 @@ int ProbePtrbits(int verb, char *targarg
 
 int ProbeCPUThrottle(int verb, char *targarg, enum OSTYPE OS, enum ASMDIA asmb)
 {
+   return 0; /* impossible to turn off cpu throttling => ignore */
+             /* this undermines performance of compiled library */
    int i, iret;
    char *ln;
    i = strlen(targarg) + 22 + 12;

EOF

    mkdir ATLAS/build
    cd ATLAS/build
    # target an SSE2 - 4 cores machine
    TARGET_MACHINE='-t 4'
    ../configure --shared $TARGET_MACHINE --with-netlib-lapack-tarfile=../../lapack-$LAPACK_VERSION.tgz
    make
    # rebuild a clean shared object for BLAS and LAPACK only
    ld $LDFLAGS -shared -o lib/libatlas.so.$ATLAS_VERSION --whole-archive lib/libptlapack.a lib/libptf77blas.a --no-whole-archive lib/libptcblas.a lib/libatlas.a -L/opt/rh/devtoolset-2/root/usr/lib/gcc/x86_64-redhat-linux/4.8.2 -lgfortran  -lc -lpthread -lm -lgcc
    cd -

    # atlas
    rm -f $INSTALLDIR/lib/lib*atlas* $INSTALLDIR/lib/lib*blas* $INSTALLDIR/lib/lib*lapack*
    cp -a ATLAS/build/lib/libatlas.so.$ATLAS_VERSION $INSTALLDIR/lib/libatlas.so.$ATLAS_VERSION
    ln -fs libatlas.so.$ATLAS_VERSION $INSTALLDIR/lib/libatlas.so.3
    ln -fs libatlas.so.$ATLAS_VERSION $INSTALLDIR/lib/libatlas.so
    # blas (as libblas)
    ln -fs libatlas.so.$ATLAS_VERSION $INSTALLDIR/lib/libblas.so.3
    ln -fs libatlas.so.$ATLAS_VERSION $INSTALLDIR/lib/libblas.so
    # lapack
    ln -fs libatlas.so.$ATLAS_VERSION $INSTALLDIR/lib/liblapack.so.3
    ln -fs libatlas.so.$ATLAS_VERSION $INSTALLDIR/lib/liblapack.so
}

function build_openblas() {
    [ -d OpenBLAS-$OPENBLAS_VERSION ] && rm -fr OpenBLAS-$OPENBLAS_VERSION

    tar -xzf OpenBLAS-$OPENBLAS_VERSION.tar.gz
    cd OpenBLAS-$OPENBLAS_VERSION
    make TARGET=NEHALEM
    make PREFIX=$INSTALLDIR install
    cd -

    clean_static
}

function build_ant() {
    [ -d $INSTALLDIR/../java/ant ] && rm -fr $INSTALLDIR/../java/ant
    [ -d $INSTALLDIR/../java/apache-ant-$ANT_VERSION ] && rm -fr $INSTALLDIR/../java/apache-ant-$ANT_VERSION

    cd $INSTALLDIR/../java/
    tar -xzf ../../apache-ant-$ANT_VERSION-bin.tar.gz
    ln -s apache-ant-$ANT_VERSION ant
    cd -
}

function build_arpack() {
    [ -d arpack-ng-$ARPACK_VERSION ] && rm -fr arpack-ng-$ARPACK_VERSION

    tar -xzf arpack-ng-$ARPACK_VERSION.tar.gz
    cd arpack-ng-$ARPACK_VERSION
    ./configure "$@" --prefix= \
        --with-blas="-L$INSTALLDIR/lib/ -lblas" \
        --with-lapack="-L$INSTALLDIR/lib/ -llapack -lblas"
    make -j
    make install DESTDIR=$INSTALLDIR
    cd -

    clean_static
}

function build_eigen() {
    [ -d eigen-eigen* ] && rm -fr eigen-eigen*

    tar -zxf eigen-$EIGEN_VERSION.tar.gz
    cd eigen-eigen*
    cp -R Eigen/ $INSTALLDIR/include/
    cd -
}


function build_hdf5() {
    [ -d hdf5-$HDF5_VERSION ] && rm -fr hdf5-$HDF5_VERSION

    tar -xzf hdf5-$HDF5_VERSION.tar.gz
    cd hdf5-$HDF5_VERSION
    sed -i -e 's|//int i1, i2;|/* int i1, i2; */|' tools/lib/h5diff.c
    ./configure "$@" --with-zlib=$INSTALLDIR --prefix=
    make -j
    make install DESTDIR=$INSTALLDIR
    cd -

    clean_static
}

function build_fftw() {
    [ -d fftw-$FFTW_VERSION ] && rm -fr fftw-$FFTW_VERSION

    tar -xzf fftw-$FFTW_VERSION.tar.gz
    cd fftw-$FFTW_VERSION
    ./configure "$@" --enable-shared --prefix=
    make -j
    make install DESTDIR=$INSTALLDIR
    cd -

    clean_static
}

function build_zlib() {
    [ -d zlib-$ZLIB_VERSION ] && rm -fr zlib-$ZLIB_VERSION

    tar -xzf zlib-$ZLIB_VERSION.tar.gz
    cd zlib-$ZLIB_VERSION
    ./configure "$@" --prefix=
    make -j
    make install DESTDIR=$INSTALLDIR
    cd -

    clean_static
}

function build_libpng() {
    [ -d libpng-$PNG_VERSION ] && rm -fr libpng-$PNG_VERSION

    tar -xzf libpng-$PNG_VERSION.tar.gz
    cd libpng-$PNG_VERSION
    ./configure "$@" --prefix= LDFLAGS="-L$INSTALLDIR/lib" CPPFLAGS="-I$INSTALLDIR/include"
    make -j LDFLAGS="-L$INSTALLDIR/lib" CPPFLAGS="-I$INSTALLDIR/include"
    make install DESTDIR=$INSTALLDIR
    cd -

    clean_static
}

function build_openssl() {
    [ -d openssl-$OPENSSL_VERSION ] && rm -fr openssl-$OPENSSL_VERSION

    tar -xzf openssl-$OPENSSL_VERSION.tar.gz
    cd openssl-$OPENSSL_VERSION
    ./config shared --openssldir=$INSTALLDIR
    make -j depend all
    make install
    chmod 644 $INSTALLDIR/lib/libcrypto.*
    chmod 644 $INSTALLDIR/lib/libssl.*
    cd -

    clean_static
}

function build_openssh() {
    [ -d openssh-$OPENSSH_VERSION ] && rm -fr openssh-$OPENSSH_VERSION

    tar -xzf openssh-$OPENSSH_VERSION.tar.gz
    cd openssh-$OPENSSH_VERSION
    ./configure --prefix=$INSTALLDIR
    make -j
    make install
    cd -

    clean_static
}


function build_tcl() {
    [ -d tcl$TCL_VERSION ] && rm -fr tcl$TCL_VERSION

    tar -xzf tcl$TCL_VERSION-src.tar.gz
    cd tcl$TCL_VERSION/unix
    ./configure "$@" --prefix=
    make -j
    make install DESTDIR=$INSTALLDIR
    chmod 644 $INSTALLDIR/lib/libtcl*.*
    cd -

    clean_static
}

function build_tk() {
    [ -d tk$TK_VERSION ] && rm -fr tk$TK_VERSION

    tar -xzf tk$TK_VERSION-src.tar.gz
    cd tk$TK_VERSION/unix
    ./configure "$@" --prefix=
    make -j
    make install DESTDIR=$INSTALLDIR
    chmod 644 $INSTALLDIR/lib/libtk*.*
    cd -

    clean_static
}

function build_matio() {
    [ -d matio-$MATIO_VERSION ] && rm -fr matio-$MATIO_VERSION

    tar -xzf matio-$MATIO_VERSION.tar.gz
    cd matio-$MATIO_VERSION
    ./configure "$@" --enable-shared --with-hdf5=$INSTALLDIR --with-zlib=$INSTALLDIR --prefix=
    make -j
    make install DESTDIR=$INSTALLDIR
    cd -

    clean_static
}

function build_pcre() {
    [ -d pcre-$PCRE_VERSION ] && rm -fr pcre-$PCRE_VERSION

    tar -xzf pcre-$PCRE_VERSION.tar.gz
    cd pcre-$PCRE_VERSION
    ./configure "$@" --enable-utf8 --enable-unicode-properties --prefix=
    make -j
    make install DESTDIR=$INSTALLDIR
    cd -
    sed -i -e 's|^\prefix=.*|\prefix=`pwd`'"/usr|" $INSTALLDIR/bin/pcre-config

    clean_static
}

function build_libxml2() {
    [ -d libxml2-$LIBXML2_VERSION ] && rm -fr libxml2-$LIBXML2_VERSION

    tar -xzf libxml2-$LIBXML2_VERSION.tar.gz
    cd libxml2-$LIBXML2_VERSION
    ./configure "$@" --without-python --with-zlib=$INSTALLDIR --prefix=
    make -j
    make install DESTDIR=$INSTALLDIR
    cd -
    sed -i -e 's|^\prefix=.*|\prefix=`pwd`'"/usr|" $INSTALLDIR/bin/xml2-config

    clean_static
}

function build_curl() {
    [ -d curl-$CURL_VERSION ] && rm -fr curl-$CURL_VERSION

    tar -zxf curl-$CURL_VERSION.tar.gz
    cd curl-$CURL_VERSION
    ./configure "$@" --disable-dict --disable-imap --disable-ldap --disable-ldaps --disable-pop3 --enable-proxy --disable-rtsp --disable-smtp \
        --disable-telnet --disable-tftp --without-libidn --without-ca-bundle --without-librtmp --without-libssh2 \
        --with-ssl=$INSTALLDIR --without-nss \
        --with-zlib=$INSTALLDIR \
        --prefix= \
        CFLAGS="-O2 -g -DCURL_WANTS_CA_BUNDLE_ENV" # Used in SCI/modules/fileio/etc/fileio.start
    make -j
    make install DESTDIR=$INSTALLDIR
    cd -
    sed -i -e 's|^\prefix=.*|\prefix=`pwd`'"/usr|" $INSTALLDIR/bin/curl-config

    clean_static
}

function build_ocaml() {
    [ -d ocaml-$OCAML_VERSION ] && rm -fr ocaml-$OCAML_VERSION

    tar -zxf ocaml-$OCAML_VERSION.tar.gz
    cd ocaml-$OCAML_VERSION
    ./configure "$@" -prefix $HOME/ocaml/
    make world bootstrap opt
    make install
    cd -
    echo "Do not forget to add $HOME/ocaml/bin/ to your PATH variable."
}

function build_suitesparse() {
    [ -d SuiteSparse ] && rm -fr SuiteSparse

    tar -zxf SuiteSparse-$SUITESPARSE_VERSION.tar.gz
    cd SuiteSparse
    sed -i -e 's|^\INSTALL_LIB = .*|\INSTALL_LIB = '"$INSTALLDIR"'\/lib\/|' SuiteSparse_config/SuiteSparse_config.mk
    sed -i -e 's|^\INSTALL_INCLUDE = .*|\INSTALL_INCLUDE = '"$INSTALLDIR"'\/include\/|' SuiteSparse_config/SuiteSparse_config.mk
    make -j library
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
    cd -

    # libcamd.so
    CAMD_VERSION=$(grep -m1 VERSION CAMD/Makefile | sed -e "s|\VERSION = ||")
    CAMD_MAJOR_VERSION=$(echo "$CAMD_VERSION" | awk -F \. {'print $1'})
    cd CAMD/Lib/
    gcc -shared -Wl,-soname,libcamd.so.${CAMD_MAJOR_VERSION} -o libcamd.so.${CAMD_VERSION} `ls *.o`
    rm -f $INSTALLDIR/lib/libcamd.so*
    cp libcamd.so.${CAMD_VERSION} $INSTALLDIR/lib/
    cd -

    # libcolamd.so
    COLAMD_VERSION=$(grep -m1 VERSION COLAMD/Makefile | sed -e "s|\VERSION = ||")
    COLAMD_MAJOR_VERSION=$(echo "$COLAMD_VERSION" | awk -F \. {'print $1'})
    cd COLAMD/Lib/
    gcc -shared -Wl,-soname,libcolamd.so.${COLAMD_MAJOR_VERSION} -o libcolamd.so.${COLAMD_VERSION} `ls *.o`
    rm -f $INSTALLDIR/lib/libcolamd.so*
    cp libcolamd.so.${COLAMD_VERSION} $INSTALLDIR/lib/
    cd -

    # libccolamd.so
    CCOLAMD_VERSION=$(grep -m1 VERSION CCOLAMD/Makefile | sed -e "s|\VERSION = ||")
    CCOLAMD_MAJOR_VERSION=$(echo "$CCOLAMD_VERSION" | awk -F \. {'print $1'})
    cd CCOLAMD/Lib/
    gcc -shared -Wl,-soname,libccolamd.so.${CCOLAMD_MAJOR_VERSION} -o libccolamd.so.${CCOLAMD_VERSION} `ls *.o`
    rm -f $INSTALLDIR/lib/libccolamd.so*
    cp libccolamd.so.${CCOLAMD_VERSION} $INSTALLDIR/lib/
    cd -

    # libcholmod.so
    CHOLMOD_VERSION=$(grep -m1 VERSION CHOLMOD/Makefile | sed -e "s|\VERSION = ||")
    CHOLMOD_MAJOR_VERSION=$(echo "$CHOLMOD_VERSION" | awk -F \. {'print $1'})
    cd CHOLMOD/Lib/
    gcc -shared -Wl,-soname,libcholmod.so.${CHOLMOD_MAJOR_VERSION} -o libcholmod.so.${CHOLMOD_VERSION} `ls *.o`
    rm -f $INSTALLDIR/lib/libcholmod.so*
    cp libcholmod.so.${CHOLMOD_VERSION} $INSTALLDIR/lib/
    cd -

    # libumfpack.so
    UMFPACK_VERSION=$(grep -m1 VERSION UMFPACK/Makefile | sed -e "s|\VERSION = ||")
    UMFPACK_MAJOR_VERSION=$(echo "$UMFPACK_VERSION" | awk -F \. {'print $1'})
    cd UMFPACK/Lib
    gcc -shared -Wl,-soname,libumfpack.so.${UMFPACK_MAJOR_VERSION} -o libumfpack.so.${UMFPACK_VERSION} `ls *.o` $INSTALLDIR/lib/libsuitesparseconfig.a \
        -L$INSTALLDIR/lib/ -lblas -llapack -lm -lcholmod -lcolamd -lccolamd -lcamd -lrt
    rm -f $INSTALLDIR/lib/libumfpack.so*
    cp libumfpack.so.${UMFPACK_VERSION} $INSTALLDIR/lib/
    cd -

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

    clean_static
}

function build_gluegen() {
    [ -d gluegen-v$JOGL_VERSION ] && rm -fr gluegen-v$JOGL_VERSION
    
    7za x gluegen-v$JOGL_VERSION.tar.7z
    tar -xf gluegen-v$JOGL_VERSION.tar
    rm gluegen-v$JOGL_VERSION.tar

    export ANT_HOME=$(pwd)/$SPECIFICDIR/java/ant
    export JAVA_HOME=$(pwd)/$SPECIFICDIR/java/jdk1.8.0_65
    cd gluegen-v$JOGL_VERSION/make
    ../../$SPECIFICDIR/java/ant/bin/ant
    cd -

    cp -a gluegen-v$JOGL_VERSION/build/obj/libgluegen-rt.so $INSTALLDIR/lib
    cp -a gluegen-v$JOGL_VERSION/build/gluegen-rt.jar $INSTALLDIR/share/java
 
    clean_static
}

function build_jogl() {
    [ -d jogl-v$JOGL_VERSION ] && rm -fr jogl-v$JOGL_VERSION

    7za x jogl-v$JOGL_VERSION.tar.7z
    tar -xf jogl-v$JOGL_VERSION.tar
    rm jogl-v$JOGL_VERSION.tar

    ln -fs gluegen-v$JOGL_VERSION gluegen
    export ANT_HOME=$(pwd)/$SPECIFICDIR/java/ant
    export JAVA_HOME=$(pwd)/$SPECIFICDIR/java/jdk1.8.0_65
    cd jogl-v$JOGL_VERSION/make
    ../../$SPECIFICDIR/java/ant/bin/ant
    cd -

    cp -a jogl-v$JOGL_VERSION/build/obj/libjogl.so $INSTALLDIR/lib
    cp -a jogl-v$JOGL_VERSION/build/jogl.jar $INSTALLDIR/share/java
}

function clean_static() {
        rm -f $INSTALLDIR/lib/*.la # Avoid message about moved library while compiling
        rm -f $INSTALLDIR/lib/*.a # No more needed
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
DEPENDENCY=$1
case $DEPENDENCY in

    "versions")
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
        exit 0;
        ;;

    "blas" | "lapack" | "openblas" | "atlas" | "ant" | "arpack" | "curl" | "eigen" | "fftw" | "hdf5" | "libxml2" | "matio" | "openssl" | "openssh" | "pcre" | "suitesparse" | "tcl" | "tk" | "zlib" | "libpng" | "gluegen" | "jogl" )
        build_$DEPENDENCY
        exit 0;
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
        if [ "$MACHINE" = "i686" ]; then
            USRDIR="/usr/lib"
            LIBDIR="/lib"
        elif [ "$MACHINE" = "x86_64" ]; then
            USRDIR="/usr/lib64"
            LIBDIR="/lib64"
        fi

        LIBTHIRDPARTYDIR=$INSTALLDIR/../lib/thirdparty
        
        # Provide OpenBLAS blas and lapack
        rm -f $LIBTHIRDPARTYDIR/libatlas.*
        rm -f $LIBTHIRDPARTYDIR/lib*blas.*
        rm -f $LIBTHIRDPARTYDIR/liblapack.*
        cp -d $INSTALLDIR/lib/libopenblas*.so* $LIBTHIRDPARTYDIR/
        cd $LIBTHIRDPARTYDIR
        ln -s libopenblas.so libblas.so
        ln -s libopenblas.so.0 libblas.so.3
        ln -s libopenblas.so liblapack.so
        ln -s libopenblas.so.0 liblapack.so.3
        cd -

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

        rm -f $LIBTHIRDPARTYDIR/libxml2.*
        cp -d $INSTALLDIR/lib/libxml2.* $LIBTHIRDPARTYDIR/


        # In case these libraries are not found on the system.
        #
        # The ".so" is not shipped on purpose for compilers support libraries,
        # the user should build on the reference system.
        # The mandatory libraries are the ones documented in the Linux Standard
        # Base 5.0 .
        [ ! -d $LIBTHIRDPARTYDIR/redist ] && mkdir $LIBTHIRDPARTYDIR/redist/
        # libgfortran.so.1 libgfortran.so.3
        rm -rf $LIBTHIRDPARTYDIR/libquadmath.*
        rm -f $LIBTHIRDPARTYDIR/libgfortran.*
        rm -f $LIBTHIRDPARTYDIR/redist/libquadmath.*
        rm -f $LIBTHIRDPARTYDIR/redist/libgfortran.*
        cp -d $USRDIR/libgfortran.so.1* $LIBTHIRDPARTYDIR/redist/
        cp -d $USRDIR/libgfortran.so.3* $LIBTHIRDPARTYDIR/redist/
        # libgomp.1.0
        rm -f $LIBTHIRDPARTYDIR/libgomp.*
        rm -f $LIBTHIRDPARTYDIR/redist/libgomp.*
        cp -d $USRDIR/libgomp.so.1.0.0 $LIBTHIRDPARTYDIR/redist/
        ln -s libgomp.so.1.0.0 $LIBTHIRDPARTYDIR/redist/libgomp.so.1.0
        ln -s libgomp.so.1.0.0 $LIBTHIRDPARTYDIR/redist/libgomp.so.1
        # libncurses.so.5
        rm -f $LIBTHIRDPARTYDIR/libncurses.*
        rm -f $LIBTHIRDPARTYDIR/redist/libncurses.*
        cp -d $USRDIR/libncurses.so.5.5 $LIBTHIRDPARTYDIR/redist/
        ln -s libncurses.so.5.5 $LIBTHIRDPARTYDIR/redist/libncurses.so.5
        ln -s libncurses.so.5.5 $LIBTHIRDPARTYDIR/redist/libncurses.so

	# CentOS 5 libz is too old, but libz should then be in redist
        rm -f $LIBTHIRDPARTYDIR/libz.*
        rm -f $LIBTHIRDPARTYDIR/redist/libz.*
	cp -d $INSTALLDIR/lib/libz.* $LIBTHIRDPARTYDIR/redist/

	# CentOS 5 libpng is too old, but libpng should then be in redist
        rm -f $LIBTHIRDPARTYDIR/libpng*
        rm -f $LIBTHIRDPARTYDIR/redist/libpng*
	cp -d $INSTALLDIR/lib/libpng* $LIBTHIRDPARTYDIR/redist/

        # Strip libraries (exporting the debuginfo to another file) to
        # reduce file size and thus startup time
        find $LIBTHIRDPARTYDIR -name '*.so*' -type f | while read file ;
        do
	    [[ $file == *.debug ]] && continue
            objcopy --only-keep-debug $file $file.debug
            objcopy --strip-debug $file
            objcopy --add-gnu-debuglink=$file.debug $file
        done

        exit 0;
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
        build_lapack
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
        build_openssh
        build_curl

        exit 0;
        ;;

        "ocaml")
        build_ocaml

        exit 0;
        ;;
    *)
        echo "Unknown dependency name $DEPENDENCY"
        exit 42
        ;;
esac;
