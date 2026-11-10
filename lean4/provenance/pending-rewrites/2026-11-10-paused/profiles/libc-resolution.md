# Exact libc resolution for current depth-6 samples

All **4,017 previously unresolved libc samples** are now resolved. The dominant operation is allocation zeroing, not copying. No benchmark was rerun and no installed package, runtime, compiler, or repository source was changed.

The original 20 elaboration windows retain 11,026 of 11,786 captured samples. The offline resolver reproduces both totals and the original 4,017-sample unresolved bucket exactly.

| Previously unresolved operation | Samples | % of all elaboration samples |
| --- | ---: | ---: |
| `__memset_zva64` | 3,803 | 34.4912% |
| `__memcpy_generic` | 189 | 1.7141% |
| `_int_malloc` | 16 | 0.1451% |
| `sysmalloc` | 6 | 0.0544% |
| `_int_free_create_chunk`, `_int_free`, `unlink_chunk.isra.0` | 3 | 0.0272% |
| Total resolved | 4,017 | 36.4321% |

The previously named `brk` bucket remains separate: 517 samples, 4.6889%. Total libc flat samples are 4,561; all have a matching symbol now. This does not resolve the separate 99-sample `[lean4-simp, no symbol]` bucket.

## Identity and reproducibility

Existing local debug-symbol directories/caches had no matching libc symbols. I downloaded **libc6-dbg:arm64 2.39-0ubuntu8.9** through the configured Ubuntu archive, then used `dpkg-deb -x` into this private directory. I did not install it. The following checks passed:

- Installed libc and extracted debug ELF Build ID: `27027b96e5b8c475fc327aa445bea1c71d37b4e2`.
- Installed libc matches the saved mapping path, device `00:3f`, and inode `67109724`.
- Its exact private byte copy has SHA-256 `0f1905dc27dbc6715875c70527bc8da846a10084c9c483e9d8ff76dce8d69d0e`.
- GNU debuglink filename and CRC32 `178e4d84` match the extracted debug ELF, independently of the Build ID.
- Downloaded package SHA-256 matches the configured APT package metadata.
- Sampled application Build ID remains `d59da747671dad2dd86a7798b50a9891d18f9ca0`.

`provenance.json` records full hashes for the libc copy, debug ELF, package, exact application, raw samples/maps/log, original report, and resolver. `resolved.json` includes every sampled libc ELF address, count, debug function/source location, formerly-unresolved count, and captured callers. Reproduce offline with:

```bash
cd /home/julienv/skip/lean4/build/agents/rewrite_semantics_lead/libc-resolution
python3 resolve.py
```

The resolver uses the exact original elaboration intervals, maps each PC through the ELF load segments, and checks symbol containment rather than assigning the nearest unrelated exported symbol. It never overwrites the original profiling artifacts.

## Allocation-zeroing evidence

Debug symbols put `__memset_zva64` at ELF range `[0xa2d80, 0xa2ea4)`. The largest single PC is `0xa2e80` with 1,312 samples: disassembly identifies the instruction as `dc zva, x3`. The range also contains the short and medium fill paths, so the function name alone is insufficient to assert that every sample is on the zero-only loop.

The captured AArch64 link register provides stronger evidence. For every memset sample, the resolver decodes the actual instruction at `LR - 4` in the frozen application:

- **3,796 samples (34.4277% of all samples)** have a direct `BL SKIP_Obstack_calloc`.
- The other 7 have a direct `BL 0x402de0`, identified by the ELF PLT disassembly as `memset@plt`.

The exact application disassembly at `SKIP_Obstack_calloc` sets `w1 = 0`, restores its caller's link register, and tail-jumps to `memset@plt`. This explains why the captured return address names the allocation caller while calloc is absent from the stack. It establishes zero-initialization for those 3,796 samples. It does **not** establish whether each allocated object is a translated frame, a persistent structure, or another array.

Largest captured return-address owners for the memset bucket:

| Caller symbol | Memset samples |
| --- | ---: |
| `sk.Map__growCapacity.1` | 192 |
| `sk.leanArrayWrite` | 155 |
| `...Meta_evalNat_visit_be1fb46d98` | 116 |
| `...isDefEqQuickOther_f3a8ea9bdf` | 109 |
| `sk.leanReplaceField` | 107 |
| `...isDefEqArgsFirstPass_spec_0_ad4075ddc6` | 103 |
| `sk.Map___ConcreteMetaImpl__mcreateFromItems.3` | 85 |
| `...infer_spec_1_spec_1_ac68cfa009` | 81 |
| `sk.leanApply` | 79 |
| `...Prim_Ref_get_ab668afddb` | 74 |

Exact call-site addresses and full names are in `resolved.json`. These are useful candidates for examining allocation size/purpose before choosing a rewrite. They are samples in the libc callee, not call counts or bytes allocated.

## Copying and allocation teardown remain distinct

The 189 memcpy samples have captured direct callers `SKIP_copy_with_pages` (99), `leanArrayWrite` (54), `SKIP_String_concat2` (26), `inferTypeImp` (6), `LeanExecution.checkpoint` (2), and `LeanReferenceTable.push/set` (1 each). This is the supported copying attribution; the larger memset bucket should not be added to it.

For 511 of the 517 brk samples, the nearest captured non-libc frame is `SKIP_destroy_Obstack_with_value`; the other 6 reach `sk_malloc`. These stacks support a relationship to region teardown/allocation, without proving a complete call chain or assigning all of that cost to a particular Lean routine.

## Limits

These are offline symbol resolutions of one diagnostic capture. SIGPROF sampling does not establish byte volume, exact allocation frequency, or the cost of a proposed optimization. Frame-pointer omissions, tail calls and short captured stacks limit deeper attribution. No Skip runtime/compiler change follows from this report; the actionable next step is to inspect the high-count maintained-code call sites and identify avoidable allocations there.

Saved disassembly: `memset-zva64-disassembly.txt`, `memset-plt-disassembly.txt`, and `obstack-calloc-disassembly.txt`. The stripped-libc disassembler displays an unrelated nearest exported label in the first file; the exact matching debug symbol range and per-PC `addr2line` results are the authoritative names.
