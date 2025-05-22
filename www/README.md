# Skip Documentation Website

This website is built using [Docusaurus](https://docusaurus.io/) and hosts both our documentation and blog.

## API Documentation

The API documentation is generated using:
- [TypeDoc](https://typedoc.org/index.html) for API documentation generation
- [docusaurus-plugin-typedoc](https://typedoc-plugin-markdown.org/plugins/docusaurus) for Docusaurus integration

### Development Setup

The development/source docs site must be in the same repository as the source code due to relative paths in the Docusaurus configuration. This setup allows us to:
- Iterate on documentation in the source repository
- Choose when to publish documentation
- Keep documentation in sync with package releases

### Development Workflow

#### Standard Workflow
```bash
# From repository root INSIDE your Docker instance
make docs           # Initialize API documentation
```

```bash
# From repository rood OUTSIDE your Docker instance
make docs-run       # Run the docs site locally
# Visit http://localhost:3000/docs/api/core or http://localhost/blog

# After editing doc comments in the sources
make docs           # Regenerate API documentation
```

### Publishing Documentation

Before, commit your changes and send them for review
```bash
git add <your_files>
git commit -m '<some message>'
gh pr create # if you use the GitHub CLI
```

When reviewed and mereged, rebase and clean up your repository:
```bash
git pull --rebase
git clean -Xdn # -n for a dry-run and double-check what's to be cleaned out
git clean -Xdf # the actual cleaning
```


To publish documentation to the live site:
```bash
# From repository root INSIDE your Docker instance
make docs-publish
```

Note the the hash of your commit: 
```bash
git rev-parse --short HEAD # supposingly it is the last commit of the branch
```

This will suggest running:
```bash
# Test locally
make docs-serve

# Push to live site
cd www/docs_site/
git add -A
git commit -m 'update to <hash_of_your_commit>'
git push
cd -
```

> **Note**: If `make docs-publish` is run from a commit that is not (an ancestor of) `main`, the docs_site commit messages will contain incorrect commit hashes.

## Documentation Structure

- The markdown documentation under `www/docs` can be edited while the site is running at http://localhost:3000
- Changes to the `www/docs` file structure must be reflected in `www/sidebars.ts`
- The `docusaurus.config.ts` file is sensitive to the file system locations of source entry points and tsconfig files

## TypeDoc Tags

For a complete reference of TypeDoc tags, see the [official documentation](https://typedoc.org/guides/tags/).
