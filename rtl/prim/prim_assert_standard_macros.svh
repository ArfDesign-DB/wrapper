// Lightweight standard assertion macro shim for this standalone wrapper tree.
// Full OpenTitan assertion implementations are not required by this repo's
// smoke tests; use the dummy definitions unless a downstream flow overrides
// these includes with a full assertion library.
`ifndef PRIM_ASSERT_STANDARD_MACROS_SVH
`define PRIM_ASSERT_STANDARD_MACROS_SVH
`include "prim_assert_dummy_macros.svh"
`endif // PRIM_ASSERT_STANDARD_MACROS_SVH
