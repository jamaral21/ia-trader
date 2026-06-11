#pragma once

#include "SignalEA_v1.inputs.mqh"
#include "SignalEA_v1.types.mqh"

class AppKernel;

extern bool g_isInitialized;
extern bool g_isTradingEnabled;
extern datetime g_lastProcessedH1BarTime;
extern datetime g_lastTickTime;
extern int g_lastErrorCode;
extern uint g_lastTradeRetcode;
extern ENUM_SIGNAL_TYPE g_lastSignal;

extern AppKernel *g_kernel;
