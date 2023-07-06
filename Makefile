FILENAME=main

DEFAULTS_FILE=resources/pandoc/defaults.yaml
BUILDDIR=build
WEASYPRINT_OPTIONS=
PYTHON=.env/bin/python

ALL_RESOURCE_FILES=$(shell find resources -type f| sed 's/ /\\ /g')
HTMLDIR=$(BUILDDIR)


all: $(FILENAME).pdf

$(FILENAME).pdf: $(BUILDDIR)/$(FILENAME).pdf
	cp $< $@

%/resources: resources | $(BUILDDIR)
	cd $*;  ln -s ../resources .

$(BUILDDIR)/%.pdf: $(BUILDDIR)/%.html $(ALL_RESOURCE_FILES) | $(BUILDDIR)/resources
	mkdir -p "$(shell dirname "$@")"
	$(PYTHON) -m weasyprint $(WEASYPRINT_OPTIONS) "$<" "$@"


$(BUILDDIR)/%.html: %.md $(ALL_RESOURCE_FILES)
	mkdir -p "$(shell dirname "$@")"
	pandoc "$<" \
	--defaults $(DEFAULTS_FILE) \
	--output="$@"


serve: $(HTML_TARGETS) | $(BUILDDIR)/resources
	cd $(HTMLDIR);python -m http.server

clean:
	rm -rf $(BUILDDIR)
