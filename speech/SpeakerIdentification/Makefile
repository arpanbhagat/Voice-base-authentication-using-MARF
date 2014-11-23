# SpeakerIdentApp Build Makefile
# Use with GNU make.
#
# Serguei Mokhov
#
# COPYRIGHT (c) 2002-2005 The MARF Development Group
#
# $Header: /cvsroot/marf/apps/SpeakerIdentApp/Makefile,v 1.20 2005/06/04 19:36:58 mokhov Exp $
#

VERSION=0.3.0-devel-`date +%Y%m%d`

# Dirs of MARF modules
MARFDIR = ../../marf/distro
MARFJAR = marf.jar

# Lists of all *.java and *.class files
JAVAFILES = *.java
CLASSES = *.class
EXE = SpeakerIdentApp

#
# Java Settings
#

JAVAC = javac
JFLAGS = -g -verbose -deprecation -classpath ".:$(MARFJAR)" -extdirs ".:$(MARFJAR)" -sourcepath .
JVM = java

JAVADOCFLAGS = -verbose -use -version -author -classpath ".:$(MARFJAR)"

#
# Build
#

all: $(EXE).class
	@echo "SpeakerIdentApp build ok"

$(EXE).class: $(JAVAFILES)
	$(JAVAC) $(JFLAGS) $(EXE).java

#
# Run
#

run:
	@echo "'make run' is ambiguous. Use 'make train-run' or 'make ident-run' instead."

train-run: all
	time -p ./testing.sh --retrain > output.txt 2>&1 &
	echo "The Training and Testing Process has begun."

ident-run: all
	time -p ./testing.sh > output.txt 2>&1 &
	echo "The Testing Process has begun."

#
# Javadoc
#

javadoc-html: $(JAVAFILES)
	@echo "Compiling javadoc..."
	mkdir -p html
	javadoc $(JAVADOCFLAGS) -private -d html $(JAVAFILES)

#
# Distro
#

DISTROSRCFILES = \
	$(JAVAFILES) \
	testing.sh testing.bat \
	Makefile SpeakerIdentApp.jpx .project .classpath manifest.mf \
	speakers.txt \
	COPYRIGHT README coding.html ChangeLog

DISTROBINFILES = \
	testing.sh testing.bat \
	speakers.txt \
	README COPYRIGHT ChangeLog \
	SpeakerIdentApp.jar marf.jar

SAMPLEDIRS = testing-samples training-samples

DISTROFILES = SpeakerIdentApp-src-$(VERSION).tar.gz \
              SpeakerIdentApp-samples-$(VERSION).tar.gz \
              SpeakerIdentApp-bundle-$(VERSION).tar.gz \
              SpeakerIdentApp-bin-$(VERSION).tar.gz \
              SpeakerIdentApp-training-sets-$(VERSION).tar.gz

distro: $(DISTROFILES)
	@echo "Done bundling the application:"
	@rm -rf tarball.exclude html
	@ls -lhG *.gz

SpeakerIdentApp-src-$(VERSION).tar.gz: $(DISTROSRCFILES) $(SAMPLEDIRS) javadoc-html tarball.exclude
	@rm -f SpeakerIdentApp-src-*.tar.gz
	@echo "Sources tarball..."
	@tar --exclude-from=tarball.exclude \
		-cvhf SpeakerIdentApp-src-$(VERSION).tar \
		$(DISTROSRCFILES) $(SAMPLEDIRS) html
	@gzip --best SpeakerIdentApp-src-$(VERSION).tar

SpeakerIdentApp-samples-$(VERSION).tar.gz: $(SAMPLEDIRS) COPYRIGHT
	@rm -f SpeakerIdentApp-samples-*.tar.gz
	@echo "Samples-only tarball..."
	@tar --exclude CVS \
		-cvhf SpeakerIdentApp-samples-$(VERSION).tar \
		$(SAMPLEDIRS) COPYRIGHT
	@gzip --best SpeakerIdentApp-samples-$(VERSION).tar

SpeakerIdentApp-bin-$(VERSION).tar.gz: all $(DISTROBINFILES) $(SAMPLEDIRS) tarball.exclude
	@rm -f SpeakerIdentApp-bin-*.tar.gz
	@echo "Binary no-samples tarball..."
	@tar --exclude-from=tarball.exclude \
		-cvhf SpeakerIdentApp-bin-$(VERSION).tar \
		$(DISTROBINFILES) $(SAMPLEDIRS)
	@gzip --best SpeakerIdentApp-bin-$(VERSION).tar

SpeakerIdentApp-bundle-$(VERSION).tar.gz: all $(DISTROSRCFILES) $(SAMPLEDIRS) javadoc-html SpeakerIdentApp.jar marf.jar
	@rm -f SpeakerIdentApp-bundle-*.tar.gz
	@echo "Bundle tarball..."
	@tar --exclude CVS \
		-cvhf SpeakerIdentApp-bundle-$(VERSION).tar \
		$(DISTROSRCFILES) marf.jar SpeakerIdentApp.jar $(SAMPLEDIRS) html
	@gzip --best SpeakerIdentApp-bundle-$(VERSION).tar

SpeakerIdentApp-training-sets-$(VERSION).tar.gz: COPYRIGHT
	@rm -f SpeakerIdentApp-training-sets-*.tar.gz
	@echo "Training Sets..."
	@tar -cvhf SpeakerIdentApp-training-sets-$(VERSION).tar *.xml *.gzbin COPYRIGHT
	@gzip --best SpeakerIdentApp-training-sets-$(VERSION).tar

SpeakerIdentApp.jar: all
	jar cvmf manifest.mf SpeakerIdentApp.jar *.class

tarball.exclude:
	@(echo "*.wav"; echo "CVS") > tarball.exclude

COPYRIGHT: ../../marf/COPYRIGHT
	ln -sf ../../marf/COPYRIGHT COPYRIGHT

coding.html: ../../www/coding.html
	ln -sf ../../www/coding.html coding.html

#
# Clean Up
#

clean:
	rm -f $(CLASSES) *~

maintainer-clean: clean
	rm -f *.stats *log training.set output.txt *.diff *.bin *.xml *.gzbin \
		stats.txt stats-date.tex best-score.tex coding.html COPYRIGHT
	rm -f training-samples/*.txt training-samples/*.ppm testing-samples/*.txt testing-samples/*.ppm

# EOF
