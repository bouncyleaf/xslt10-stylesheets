#-----------------------------------------------------------------
#  -*- makefile -*- snippet with VARIABLES FOR RELEASE BUILDS
#-----------------------------------------------------------------
# If you are doing normal (non-release) sandbox builds just for
# your own use, you can ignore all the variables below. They are
# used only when doing release builds.
#-----------------------------------------------------------------

# $Id$

CATALOGMANAGER=$(DOCBOOK_CVS)/releasetools/.CatalogManager.properties.example
INSTALL_SH=$(DOCBOOK_CVS)/releasetools/install.sh
MAKECATALOG=$(DOCBOOK_CVS)/releasetools/make-catalog.xsl

# stylesheet for generating HTML version of release notes
DOC-LINK-STYLE=$(DOCBOOK_CVS)/xsl/docsrc/doc-link-docbook.xsl

# MARKUP_XSL is a modified version of Jeni Tennison's "Markup
# Utility"
MARKUP_XSL=$(DOCBOOK_CVS)/contrib/tools/tennison/modified-markup.xsl

# stylesheet used in taking XML output from the cvs2cl(1) perl
# script, and using it to generate NEWS file(s) and releases notes
CVS2CL2DOCBOOK=$(DOCBOOK_CVS)/releasetools/cvs2cl2docbook.xsl

# stylesheet used for determining the latest cvs tag in cvs log
GET_LATEST_TAG=$(DOCBOOK_CVS)/releasetools/get-latest-tag.xsl

# stylesheet for stripping DB5 namespace
STRIP_NS=$(DOCBOOK_CVS)/xsl/common/stripns.xsl

# stylesheet for generating FO version of release notes
FO-STYLE=$(DOCBOOK_CVS)/xsl/fo/docbook.xsl

# stylesheet for generating PDF of release notes with dblatex
DBX-STYLE=$(DOCBOOK_CVS)/xsl/docsrc/dblatex-release-notes.xsl

# browser to use for making text version of release notes
# w3mmee is a fork of w3m; it provides a lot more options for
# charset handling; other possible values for BROWSER include
# "w3m" and "lynx" and "links" and "elinks"
BROWSER=w3mmee
BROWSER_OPTS=-dump

PDF_MAKER=dblatex

XEP = xep
XEP_FLAGS =

DBLATEX = dblatex
DBLATEX_FLAGS = -b pdftex

# file containing "What's New" info generated from CVS log
NEWSFILE=NEWS

LATEST_TAG=$(shell if [ -f LatestTag ];then cat LatestTag; fi)

# determine RELVER automatically by:
#
#   - figuring out if VERSION file exists
#   - checking to see if VERSION is an XSL stylesheet or not
#   - grabbing the version number from VERSION file based on
#     whether or not it is a stylesheet
#
RELVER := $(shell \
 if [ -f VERSION ]; then \
   if grep "<xsl:stylesheet" VERSION >/dev/null; then \
     grep "Version>.\+<" VERSION \
     | sed 's/^[^<]*<fm:Version>\(.\+\)<\/fm:Version>$$/\1/' \
     | tr -d "\n"; \
   else cat VERSION; \
   fi \
 fi \
)
ZIPVER=$(RELVER)

# the following are used to determine what version to compare to
# in order to create the WhatsNew file
NEXTVER=
DIFFVER=

# CVSCHECK is used to make sure your working directory is up to
# date with CVS. Note that we use a makefile conditional here
# because we want/need to check whether we're up to date only when
# the "newversion" target is called. Without the conditional, the
# right side of this variable assignment will get call every time
# make is run, regardless of the target. Which kind of tends to
# slow down things a bit...
ifeq ($@,newversion)
CVSCHECK = $(shell cvs -n update 2>&1 | grep -v ^cvs | cut -c3-)
endif

# remove dots from version number to create CVS tag
TAGVER := $(shell echo "V$(RELVER)" | sed "s/\.//g")

# if TMP is already defined in the environment, build uses that as
# location for temporary storage for files generated by "make
# zip"; otherwise it defaults to /tmp. To use a temp directory
# other than /tmp, run "make zip TMP=/foo" 
ifeq ($(TMP),)
TMP=/tmp
endif

# value of ZIP_EXCLUDES is a space-separated list of any file or
# directory names (regular expressions OK) that should be excluded
# from the *zip files for the release
ZIP_EXCLUDES = \
 /CVS$$ \
 /CVS/ \
 /debian \
 \.classes \
 ~$$ \
 \..*\.pyc \
 \\\#.* \
 \.\\\#.* \
 prj\.el \
 \.cvsignore \
 MANIFEST.build \
 Makefile$$ \
 Makefile[.] \
 LatestTag \
 README\.CVS \
 RELEASE-NOTES\.fo \
 \.make-catalog\.xsl

# list of executables that are included in all distributions
EXECUTABLES =

# specifies options to feed to "freshmeat-submit"
FMGO=-N
# SFRELID specifies Sourceforge release ID for current release.
# Before running "make freshmeat", you need to manually create the
# new release at Sourceforge (via the SF web interface), then copy
# down the release ID in the URI for the release
SFRELID=
# specifies which FTP app to use for upload to SF incoming
FTP=lftp
FTP_OPTS=-e
SCP=scp
SCP_OPTS=
SSH=ssh
SSH_OPTS=
SF_UPLOAD_HOST=upload.sf.net
SF_UPLOAD_DIR=incoming
PROJECT_HOST=docbook.sf.net
RELEASE_DIR=/home/groups/d/do/docbook/htdocs/release
PROJECT_USER:=`sed 's/^:.\+:\([^@]\+\)@.\+$$/\1/' CVS/Root`
TAR=tar
TARFLAGS=P
ZIP=zip
ZIPFLAGS=-q -rpD

XSLTPROC=xsltproc
XSLTPROC_OPTS=

XMLLINT=xmllint
XMLLINT_OPTS=
XINCLUDE=$(XMLLINT) $(XMLLINT_OPTS) --xinclude

CVS2CL=cvs2cl
CVS2CL_OPTS=

SED=sed
SED_OPTS=

