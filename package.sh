#!/bin/bash

PKGNAME=draftwatermark
PKGCNT=("README.md")
TESTFILES=("test_draftwatermark-1" "test_draftwatermark-2" \
           "test_draftwatermark-3" "test_draftwatermark-4" \
           "test_draftwatermark-5")
TESTENGINES=("pdflatex")

pkg_version=$(pcregrep -o1 '\\fileversion\{(.*)}' $PKGNAME.dtx)
pkg_date=$(pcregrep -o1 '\\filedate\{(.*)}' $PKGNAME.dtx)
PKGVERS=$(echo $version | sed 's/\./-/')

check() {
    echo "Found package version $pkg_version @ $pkg_date"
    provided_info=$(pcregrep -Mo1 \
    			     '\\ProvidesPackage{'$PKGNAME'}[^\[]*\[(.*)\]' \
    			     $PKGNAME.dtx)
    provided_date=$(echo $provided_info | cut -d' ' -f1)
    provided_version=$(echo $provided_info | cut -d' ' -f2)
    if [ "$provided_version" != "$pkg_version" ] ; then
	echo Mismatched package version $provided_version in \\ProvidesPackage \
	     >&2
	exit 1
    fi
    if [ "$provided_date" != "$pkg_date" ] ; then
	echo Mismatched package date $provided_date in \\ProvidesPackage \
	     >&2
	exit 1
    fi
    mapfile -t changes_info \
	    < <(pcregrep -Mo \
    			 '\\changes{R'$pkg_version'}{[^{}]*}' $PKGNAME.dtx)
    if [ ${#changes_info[@]} -eq 0 ]; then
	echo Cannot find change info for package. >&2
    fi
}

build () {
    mkdir -p buildpkg/workdir
    cp "$PKGNAME".dtx "$PKGNAME".ins "${PKGCNT[@]}" buildpkg/workdir/
    cd buildpkg/workdir
    cat > docstrip.cfg <<EOF
\BaseDirectory{.}
\UseTDS
\askforoverwritefalse
EOF
    mkdir -p tex/latex/"$PKGNAME"
    mkdir -p doc/latex/"$PKGNAME"/examples
    tex "$PKGNAME".ins
    lualatex "$PKGNAME".dtx
    makeindex -s gind.ist "$PKGNAME"
    makeindex -s gglo.ist -o "$PKGNAME".gls "$PKGNAME".glo
    lualatex "$PKGNAME".dtx
    lualatex "$PKGNAME".dtx
    cp "$PKGNAME".pdf doc/latex/"$PKGNAME"/
    cd -
}

do_test() {
    mkdir -p buildpkg/testdir
    cp buildpkg/workdir/tex/latex/"$PKGNAME"/"$PKGNAME".sty buildpkg/testdir
    cp buildpkg/workdir/doc/latex/"$PKGNAME"/examples/* buildpkg/testdir
    cd buildpkg/testdir
    for name in "${TESTFILES[@]}"; do
        for engine in "${TESTENGINES[@]}" ; do
            $engine "$name"
        done
    done
    cd -
}

package() {
    mkdir -p buildpkg/"$PKGNAME"_"$PKGVERS"
    cp "$PKGNAME".dtx "$PKGNAME".ins "${PKGCNT[@]}" \
       buildpkg/"$PKGNAME"_"$PKGVERS"/
    cp buildpkg/workdir/"$PKGNAME".pdf buildpkg/"$PKGNAME"_"$PKGVERS"/
    cd buildpkg
    zip -r -9 "$PKGNAME"_"$PKGVERS".zip "$PKGNAME"_"$PKGVERS"
    cd -
}

clean() {
    cd buildpkg
    rm -fr ./workdir ./testdir ./"$PKGNAME"_"$PKGVERS" ./"$PKGNAME".tds.zip
    cd -
}

check
build
do_test
package
clean

