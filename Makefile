SHELL := /bin/bash
.PHONY: all clean

all:
	mkdir -p ebin
	erlc +debug_info -o ebin -pa ebin src/*.erl
	erlc +debug_info -o ebin -pa examples src/*.erl

clean:
	rm -rf ebin

test-deps:
	git clone https://github.com/extend/cowboy.git test-deps/cowboy
	pushd test-deps/cowboy; git checkout 0.9.0; make; popd

test: test-deps all
	mkdir -p .ct_results
	ct_run -pa test-deps/cowboy/ebin test-deps/cowboy/deps/*/ebin ebin \
	-dir ct \
	-logdir ./.ct_results \
	-cover ct/websocket_client.coverspec
