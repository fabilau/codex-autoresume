.PHONY: check package

check:
	./scripts/check-repo.sh

package: check
	./scripts/package-release.sh
