# Releasing Docker and NPM artifacts

The scripts in this directory are used to build docker images for local
development and to build and release our Docker Hub and NPM artifacts.

## Build Docker images

The unified `docker_build.sh` script handles both local builds and releases:

```
docker_build.sh [--push] [--prod] [IMAGE...]
```

- **Local build** (default): `docker_build.sh` builds all images for the native architecture
- **Production build**: `docker_build.sh --prod` forces `linux/amd64`
- **Release to Docker Hub**: `docker_build.sh --push IMAGE...` builds multi-arch and pushes

Convenience wrappers are provided for common workflows:

- `build_docker_images.sh` — local build of all images
- `build_prod_skdb_images.sh` — local production build (`--prod`)
- `release_docker_ci_images.sh` — push CI images to Docker Hub
- `release_docker_skdb.sh` — push skdb image
- `release_docker_skdb_dev_server.sh` — interactive push of dev server

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

4. Build and test with `make -C skipruntime-ts test`.

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

8. Release the Skip runtime binaries, as below.

## Release Skip runtime binaries

The `@skipruntime/native` node addon dynamically links to a native library
containing the Skip runtime. The versions of the NPM package and binary
release must match. Therefore whenever NPM packages are released the binary
runtime release must be as well. The installation scripts download the
binary runtime library from a github release tagged with `vM.N.O` where
`M.N.O` is the version of the NPM packages.

The release procedure for the runtime library binary is:

1. Run `bin/build_runtime.sh` from a clean repo with HEAD at the commit that
   was/will be used for version `M.N.O` of the NPM packages. This leaves
   `libskipruntime.so-<OS>-<ARCH>` files in the `build` directory.

2. Visit https://github.com/skiplabs/skip/releases/new

3. Click "Choose a tag"

4. Enter `vM.N.O` as the tag name

5. Click "Create new tag...on publish"

6. Enter a release title and description

7. Attach `build/libskipruntime.so-linux-arm64` and `build/libskipruntime.so-linux-amd64`

8. Click "Publish release"

9. Test the new release by running `cd skipruntime-ts/tests/native_addon/ ; ./run.sh`
