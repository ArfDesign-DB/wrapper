// Security countermeasure assertion macro shim.
`ifndef PRIM_ASSERT_SEC_CM_SVH
`define PRIM_ASSERT_SEC_CM_SVH

`define ASSERT_PRIM_COUNT_ERROR_TRIGGER_ALERT(__name, __err, __alert)
`define ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT(__name, __err, __alert)
`define ASSERT_PRIM_REG_WE_ONEHOT_ERROR_TRIGGER_ALERT(__name, __err, __alert)
`define ASSERT_PRIM_FSM_ERROR_TRIGGER_ALERT_IF(__name, __err, __alert, __enable)

`endif // PRIM_ASSERT_SEC_CM_SVH
