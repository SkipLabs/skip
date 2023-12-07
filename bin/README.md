# Releasing Docker and NPM artifacts

The scripts in this directory are used to build docker images for local
development (`build_docker_images.sh`) and to build and release our Docker Hub
and NPM artifacts.

## Release Docker images

In order to update `skiplabs/skdb-base` or `skiplabs/skdb-dev-server` to the
current state of your git clone, you can run `release_docker_skdb_base.sh` or
`release_docker_skdb_dev_server.sh` respectively. For the `dev-server`, you can
choose to release either or both of the `latest` and `quickstart` tags.

## Release NPM packages

1. Check out `master` and make sure your working copy is clean

2. Bump version numbers and/or dependencies for whichever packages you want to
   update, in `sql/npm.json`, `packages/dev/package.json`, and/or
   `packages/react/package.json`

3. Commit your changes with a message like `NPM versions: skdb@x.y.z,
   skdb-dev@a.b.c, skdb-react@1.2.3`, but don't push yet.

4. Run `release_npm_skdb.sh` to release the base `skdb` package.  Note that this
   script requires `skargo` and `sknpm`, so may need to run inside of a docker
   environment.  If so, make sure to run `npm login` first so that the CLI can
   authenticate.

5. If you're also updating `skdb-dev` or `skdb-react`, then `(cd packages/dev &&
   rm -rf node_modules && yarn install)` and/or `(cd packages/react && rm -rf
   node_modules && yarn install)` to update the `yarn.lock` files.  Then, run
   either or both of `release_npm_skdb_dev.sh` and `release_npm_skdb_react.sh`,
   and `git add packages/*/yarn.lock && git commit --amend --no-edit` to add the
   `yarn.lock` changes to your version-bump git commit.

6. `git push origin HEAD`
