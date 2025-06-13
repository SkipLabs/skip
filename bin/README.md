# Releasing Docker and NPM artifacts

The scripts in this directory are used to build docker images for local
development (`build_docker_images.sh`) and to build and release our Docker Hub
and NPM artifacts.

## Release Docker images

In order to update the images used in CI to the current state of your git
clone, you can run `release_docker_ci_images.sh`.

## Release NPM packages

We keep all **public** NPM packages (i.e. `@skipruntime/*`, `@skiplabs/skip`,
and `@skip-adapter/*`) at the same version so as to keep updates, documentation,
and version management simple.  (Note that the build script of the native addon
relies on this convention since it links to the skipruntime library with the same
version as the addon package, so whenever anything in the skipruntime library
changes, the addon package version must be bumped.)  To update from version
`$OLD` to version `$NEW`, perform the following steps:

1. Check out `main` and make sure your working copy is clean

2. Check that relevant changes since the previous release are included in
   `CHANGELOG.md`, and update section headers to group those changes under
   version `$NEW`.

3. Bump _all_ `./skipruntime-ts/**/package.json` version strings and
   inter-dependencies from `$OLD` to `$NEW`, e.g. by running `sed -i ''
   's/$OLD/$NEW/g' $(git grep -l $OLD skipruntime-ts/**/package.json)`.

4. Build and test with `make -C skipruntime-ts build test`.

5. Check that tests pass and changes to `package-lock.json` and
   `**/package.json` files look reasonable, then git-commit with a message like `NPM
   version $NEW`, git-tag with `v$NEW`, git-push, and open a PR.

6. When you're ready to publish, run `make publish-all` and provide proper NPM
   auth to publish the new package versions.

7. Update docker-compose `./examples` package dependencies to the now-released
   `$NEW` versions (e.g. with `sed -i '' 's/$OLD/$NEW/g' $(g grep -l $OLD
   examples/**/package.json)`), make any necessary changes to keep them
   building/running with the new versions, add those changes to your PR, and
   land it!

