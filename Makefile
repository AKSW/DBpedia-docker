DIR=$(shell pwd)

# Preparation procedures

# downloads dbpedia core, ontology and en folders
download:
	wget -r -nc -nH --cut-dirs=1 -np -l1 \
		-A '*.nt.bz2' -A '*.owl' -R '*unredirected*' \
		-P ./dbpedia \
		http://downloads.dbpedia.org/2015-10/core/
	wget -r -nc -nH --cut-dirs=1 -np -l1 \
		-A '*.ttl.bz2' -A '*.owl' -R '*unredirected*' \
		-P ./dbpedia \
		http://downloads.dbpedia.org/2015-10/core-i18n/en/
	wget -P ./dbpedia/classes http://downloads.dbpedia.org/2015-10/dbpedia_2015-10.owl

# unpacks downloaded files
unpack:
	for i in ./dbpedia/core/*.bz2 ; do echo $$i ; bzip2 -dk "$$i"; done
	for i in ./dbpedia/core-i18n/en/*.bz2 ; do echo $$i ; bzip2 -dk "$$i"; done

# moves unpacked files into separate folders for import
move:
	mkdir ./dbpedia/core-nt
	mkdir ./dbpedia/en-ttl
	mv ./dbpedia/core/*.nt ./dbpedia/core-nt/
	mv ./dbpedia/core-i18n/en/*.ttl ./dbpedia/en-ttl/

# executes download, unpack and move one after another
prepare: download unpack move

# creates new instance of virtuoso with 64G of RAM limit
virtuoso:
	docker run --name dbpedia \
		-e "NumberOfBuffers=$((64*85000))" \
		-v ${DIR}/db:/data \
		-v ${DIR}/virtuoso/virtuoso.ini:/data/virtuoso.ini \
		-v ${DIR}/dbpedia:/import \
		-d tenforce/virtuoso

# stops and removes virtuoso
stop-virtuoso:
	docker stop dbpedia && docker rm dbpedia

# starts importing the data into running instance of virtuoso
import:
	docker run --name dbpedia-import \
		-it \
		--rm \
		--link dbpedia \
		-v ${DIR}/dbpedia:/import \
		-v ${DIR}/virtuoso/import.sh:/import/import.sh \
		tenforce/virtuoso bash /import/import.sh
