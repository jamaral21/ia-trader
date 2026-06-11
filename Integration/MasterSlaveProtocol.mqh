#pragma once

#include "..\SignalEA_v1.types.mqh"

class MasterSlaveProtocol
{
public:
   bool EncodeTradePlan(const STradeRequestPlan &plan, string &outPayload) const
   {
      outPayload = "";
      return false;
   }

   bool DecodeTradePlan(const string payload, STradeRequestPlan &outPlan) const
   {
      outPlan.action = TRADE_ACTION_NONE;
      outPlan.volume = 0.0;
      outPlan.sl = 0.0;
      outPlan.tp = 0.0;
      outPlan.comment = "";
      return false;
   }
};
