#pragma once

#include "..\SignalEA_v1.types.mqh"

class IndicatorHub
{
private:
   string m_symbol;
   ENUM_TIMEFRAMES m_tf;

public:
   IndicatorHub(void) : m_symbol(""), m_tf(PERIOD_H1) {}

   bool Initialize(const string symbol, const ENUM_TIMEFRAMES tf);
   bool Refresh(void);
   bool GetSnapshot(SIndicatorSnapshot &outSnapshot) const;
   void Release(void);
};

bool IndicatorHub::Initialize(const string symbol, const ENUM_TIMEFRAMES tf)
{
   m_symbol = symbol;
   m_tf = tf;
   return true;
}

bool IndicatorHub::Refresh(void)
{
   return true;
}

bool IndicatorHub::GetSnapshot(SIndicatorSnapshot &outSnapshot) const
{
   outSnapshot.barTime = 0;
   outSnapshot.emaFast = 0.0;
   outSnapshot.emaSlow = 0.0;
   outSnapshot.atr = 0.0;
   outSnapshot.donchianHigh = 0.0;
   outSnapshot.donchianLow = 0.0;
   outSnapshot.isValid = false;
   return true;
}

void IndicatorHub::Release(void)
{
}
