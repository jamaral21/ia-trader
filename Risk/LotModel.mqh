#pragma once

#include "..\SignalEA_v1.types.mqh"

class LotModel
{
public:
   // Intentionally not implemented in this phase.
   double CalculateLotSize(const SIndicatorSnapshot &ind, const SPositionSnapshot &pos);
};
