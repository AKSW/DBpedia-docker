isql-v -H dbpedia PROMPT=OFF VERBOSE=OFF BANNER=OFF <<-EOF
    ld_dir_all('/import/classes', '*.*', 'http://dbpedia.org/resource/classes#');
    SELECT 'importing this file / these files:';
    SELECT ll_file FROM DB.DBA.LOAD_LIST WHERE ll_state = 0;
    SELECT 'starting import', CURRENT_TIMESTAMP();
    rdf_loader_run();
    checkpoint;
    commit work;
    checkpoint;
    SELECT 'import finished', CURRENT_TIMESTAMP();
    SELECT 'graph http://dbpedia.org/resource/classes# now contains n triples:';
    sparql SELECT COUNT(*) as ?c { GRAPH <http://dbpedia.org/resource/classes#> {?s ?p ?o.} };
EOF

isql-v -H dbpedia PROMPT=OFF VERBOSE=OFF BANNER=OFF <<-EOF
    ld_dir_all('/import/core-nt', '*.*', 'http://dbpedia.org');
    SELECT 'importing this file / these files:';
    SELECT ll_file FROM DB.DBA.LOAD_LIST WHERE ll_state = 0;
    SELECT 'starting import', CURRENT_TIMESTAMP();
    rdf_loader_run();
    checkpoint;
    commit work;
    checkpoint;
    SELECT 'import finished', CURRENT_TIMESTAMP();
    SELECT 'graph http://dbpedia.org now contains n triples:';
    sparql SELECT COUNT(*) as ?c { GRAPH <http://dbpedia.org> {?s ?p ?o.} };
EOF

isql-v -H dbpedia PROMPT=OFF VERBOSE=OFF BANNER=OFF <<-EOF
    ld_dir_all('/import/en-ttl', '*.*', 'http://dbpedia.org');
    SELECT 'importing this file / these files:';
    SELECT ll_file FROM DB.DBA.LOAD_LIST WHERE ll_state = 0;
    SELECT 'starting import', CURRENT_TIMESTAMP();
    rdf_loader_run();
    checkpoint;
    commit work;
    checkpoint;
    SELECT 'import finished', CURRENT_TIMESTAMP();
    SELECT 'graph http://dbpedia.org now contains n triples:';
    sparql SELECT COUNT(*) as ?c { GRAPH <http://dbpedia.org> {?s ?p ?o.} };
EOF
