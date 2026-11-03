# Canonical read paths: process RSS high-water marks

These values come from the original wrapper records; no measurement was repeated. The one-second process-tree sampler can miss entire short compiler invocations. Linux wait4 reports a process/descendant RSS high-water mark even for those invocations. These maxima are not simultaneous summed RSS and cannot be added across processes. Compiler-invocation values can include native compiler descendants. See the [original timing/retention table](canonical-paths-matched-screen.md) for distinct sampled-tree and retained-state measurements.

| Case | Policy | Median process high-water GB | Maximum process high-water GB |
| --- | --- | ---: | ---: |
| cold | control | 18.927 | 18.927 |
| cold | canonical | 16.714 | 16.714 |
| noop | control | — | — |
| noop | canonical | — | — |
| literal | control | 1.520 | 1.612 |
| literal | canonical | 1.866 | 1.943 |
| control-flow | control | 3.477 | 5.615 |
| control-flow | canonical | 3.634 | 5.726 |
| method-body | control | 1.465 | 1.538 |
| method-body | canonical | 1.657 | 1.716 |
| generic | control | 4.051 | 4.186 |
| generic | canonical | 4.191 | 4.269 |
| unused | control | 0.928 | 0.946 |
| unused | canonical | 1.046 | 1.061 |
| history-historical | control | 15.880 | 15.880 |
| history-historical | canonical | 13.307 | 13.307 |
| history-baseline | control | 15.286 | 15.286 |
| history-baseline | canonical | 12.928 | 12.928 |
