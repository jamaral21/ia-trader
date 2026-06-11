#pragma once

enum ENUM_EA_STATE
{
   EA_STATE_BOOT = 0,
   EA_STATE_READY,
   EA_STATE_RUNNING,
   EA_STATE_DEGRADED,
   EA_STATE_STOPPING,
   EA_STATE_STOPPED
};

enum ENUM_SIGNAL_TYPE
{
   SIGNAL_NONE = 0,
   SIGNAL_LONG,
   SIGNAL_SHORT,
   SIGNAL_EXIT_LONG,
   SIGNAL_EXIT_SHORT
};

enum ENUM_TRADE_ACTION
{
   TRADE_ACTION_NONE = 0,
   TRADE_ACTION_OPEN_LONG,
   TRADE_ACTION_OPEN_SHORT,
   TRADE_ACTION_CLOSE,
   TRADE_ACTION_MODIFY_SLTP
};

enum ENUM_MODULE_STATUS
{
   MODULE_OK = 0,
   MODULE_WARN,
   MODULE_ERROR
};

enum ENUM_ERROR_SEVERITY
{
   ERR_SEV_INFO = 0,
   ERR_SEV_RETRYABLE,
   ERR_SEV_FATAL
};

enum ENUM_BREAKOUT_STATE
{
   BREAKOUT_READY = 0,
   BREAKOUT_LOCKED
};

struct SIndicatorSnapshot
{
   datetime barTime;
   double emaFast;
   double emaSlow;
   double atr;
   double donchianHigh;
   double donchianLow;
   bool isValid;
};

struct SSignalDecision
{
   ENUM_SIGNAL_TYPE signal;
   double confidence;
   string reasonCode;
   bool canTrade;
};

struct SPositionSnapshot
{
   bool hasPosition;
   long ticket;
   ENUM_POSITION_TYPE type;
   double volume;
   double priceOpen;
   double sl;
   double tp;
   double profit;
};

struct STradeRequestPlan
{
   ENUM_TRADE_ACTION action;
   double volume;
   double sl;
   double tp;
   string comment;
};

struct SModuleHealth
{
   ENUM_MODULE_STATUS status;
   int errorCode;
   string message;
};
