#pragma once

#include "..\SignalEA_v1.types.mqh"

class SignalEngine
{
public:
   SSignalDecision Evaluate(const SIndicatorSnapshot &ind, const SPositionSnapshot &pos);
};

SSignalDecision SignalEngine::Evaluate(const SIndicatorSnapshot &ind, const SPositionSnapshot &pos)
{
   SSignalDecision decision;
   decision.signal = SIGNAL_NONE;
   decision.confidence = 0.0;
   decision.reasonCode = "ARCH_PLACEHOLDER";
   decision.canTrade = false;
   return decision;
}
