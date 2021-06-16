package: pythia
version: "%(tag_basename)s"
tag: v8243-alice1a
source: https://github.com/alisw/pythia8
requires:
  - lhapdf
  - HepMC
  - boost
build_requires:
  - alibuild-recipe-tools
env:
  PYTHIA8DATA: "$PYTHIA_ROOT/share/Pythia8/xmldoc"
  PYTHIA8: "$PYTHIA_ROOT"
---
#!/bin/bash -e
rsync -a $SOURCEDIR/ ./
case $ARCHITECTURE in
  osx*)
    # If we preferred system tools, we need to make sure we can pick them up.
    [[ ! $BOOST_ROOT ]] && BOOST_ROOT=`brew --prefix boost`
  ;;
esac

./configure --prefix=$INSTALLROOT \
            --enable-shared \
            ${HEPMC_ROOT:+--with-hepmc2="$HEPMC_ROOT"} \
            ${LHAPDF_ROOT:+--with-lhapdf6="$LHAPDF_ROOT"} \
            ${BOOST_ROOT:+--with-boost="$BOOST_ROOT"}

if [[ $ARCHITECTURE =~ "slc5.*" ]]; then
    ln -s LHAPDF5.h include/Pythia8Plugins/LHAPDF5.cc
    ln -s LHAPDF6.h include/Pythia8Plugins/LHAPDF6.cc
    sed -i -e 's#\$(CXX) -x c++ \$< -o \$@ -c -MD -w -I\$(LHAPDF\$\*_INCLUDE) \$(CXX_COMMON)#\$(CXX) -x c++ \$(<:.h=.cc) -o \$@ -c -MD -w -I\$(LHAPDF\$\*_INCLUDE) \$(CXX_COMMON)#' Makefile
fi

make ${JOBS+-j $JOBS}
make install
chmod a+x $INSTALLROOT/bin/pythia8-config

# Modulefile
MODULEDIR="$INSTALLROOT/etc/modulefiles"
mkdir -p "$MODULEDIR"
alibuild-generate-module --bin --lib --root-env --extra > "$MODULEDIR/$PKGNAME" <<EoF
# Our environment
setenv PYTHIA8DATA \$PKG_ROOT/share/Pythia8/xmldoc
setenv PYTHIA8 \$::env(BASEDIR)/$PKGNAME/\$version
prepend-path ROOT_INCLUDE_PATH \$PKG_ROOT/include
EoF
