#pragma once

#include "..\SignalEA_v1.types.mqh"

class RiskPolicy
{
public:
   bool CanOpen(const SSignalDecision &decision, const SPositionSnapshot &pos) const
   {
      return decision.canTrade && !pos.hasPosition;
   }
};
