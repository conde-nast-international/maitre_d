/usr/bin/fpm:
	echo "error: fpm missing, see https://github.com/jordansissel/fpm" >&2
	exit 1

clean:
	rm -f ./maitred_*.deb || :
	rm -r var/ || :

dev: var/log/maitred
	fpm -s dir -t deb -n "maitred" --maintainer 'paulina.budzon@condenastint.com' --vendor 'condenastint' -v 0.2.0 -a all -C ./src --prefix / --config-files /etc/maitred.conf --depends git .

var/log/maitred:
	mkdir -p var/log/maitred

.PHONY: clean deb
