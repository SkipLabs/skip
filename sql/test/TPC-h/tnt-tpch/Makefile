SCALE_FACTOR ?= 1
RUNN ?= 3
MEM_SIZE ?= $(shell echo 5*1024^3 | bc)
TPCHD = tpch-dbgen
DBGEN = $(TPCHD)/dbgen
QGEN = $(TPCHD)/qgen
TABLES = customer lineitem nation orders partsupp part region supplier
TABLE_FILES = $(foreach table, $(TABLES), $(TPCHD)/$(table).tbl)
TARANTOOL ?= tarantool
SQLITE_DB = TPC-H.db
TNT_DB = 00000000000000000000.snap
NUMAOPTS ?=

all: | bench-sqlite bench-tnt report

# TPC-H binaries and seed data
$(TABLE_FILES): $(DBGEN)
	cd $(TPCHD) && ./dbgen -f -s $(SCALE_FACTOR)
	chmod +r $(TABLE_FILES)

$(DBGEN) $(QGEN): $(TPCHD)/Makefile
	$(MAKE) -C $(TPCHD) all

# **optional step** regenerate TPC-H queries
# NB! you don't want to run it everytime:
# queries were manually changed to make 
# them SQLite compatible
gen-queries: $(QGEN)
	@mkdir -p queries/ > /dev/null
	./gen_queries.sh	

# target for populate sqlite database
create_SQL_db : $(SQLITE_DB)

# SQLite: populate databases
$(SQLITE_DB): | $(TABLE_FILES) sqlite-ddl.sql
	./create_db.sh $(TABLES)

# target for populate Tarantool database
create_TNT_db : $(TNT_DB)

# Tarantool: populate database 
$(TNT_DB): | $(TABLE_FILES)
	$(TARANTOOL) create_table.lua -m $(MEM_SIZE)

# run benchmarks
bench-sqlite: create_SQL_db
	$(NUMAOPTS) ./bench_queries.sh 2>&1 | tee bench-sqlite.log

bench-tnt: create_TNT_db
	$(NUMAOPTS) $(TARANTOOL) execute_query.lua \
	-m $(MEM_SIZE) -n $(RUNN) 2>&1 | tee bench-tnt.log

report:
	perl ./report.pl bench-sqlite.log > bench-sqlite.csv
	grep '^Q' bench-tnt.log > bench-tnt.csv

# clean everything
clean: clean-tpch clean-sqlite clean-tnt

clean-tpch:
	$(MAKE) -C $(TPCHD) clean

clean-sqlite: clean-tpch
	rm -rf $(SQLITE_DB) $(TABLE_FILES)

clean-tnt:
	rm -f *.xlog *.snap

