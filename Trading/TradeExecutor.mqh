#pragma once

#include <Trade/Trade.mqh>
#include "..\SignalEA_v1.types.mqh"

class TradeExecutor
{
private:
   CTrade m_trade;

public:
   bool ExecutePlan(const STradeRequestPlan &plan);
   bool ClosePosition(const long ticket);
   bool ModifyPosition(const long ticket, const double sl, const double tp);

   // Intentionally not implemented in this phase.
   bool OpenLong(const STradeRequestPlan &plan);

   // Intentionally not implemented in this phase.
   bool OpenShort(const STradeRequestPlan &plan);
};

bool TradeExecutor::ExecutePlan(const STradeRequestPlan &plan)
{
   switch(plan.action)
   {
      case TRADE_ACTION_OPEN_LONG:
         return false;
      case TRADE_ACTION_OPEN_SHORT:
         return false;
      case TRADE_ACTION_CLOSE:
         return true;
      case TRADE_ACTION_MODIFY_SLTP:
         return true;
      default:
         break;
   }
   return false;
}

bool TradeExecutor::ClosePosition(const long ticket)
{
   return true;
}

bool TradeExecutor::ModifyPosition(const long ticket, const double sl, const double tp)
{
   return true;
}
