#pragma once

#include "..\SignalEA_v1.types.mqh"
#include "DonchianIndicator.mqh"

class IndicatorHub
{
private:
   string m_symbol;
   ENUM_TIMEFRAMES m_tf;
   int m_ema50H4Handle;
   int m_ema200H4Handle;
   int m_atr14H1Handle;
   int m_donchianPeriod;
   DonchianIndicator m_donchian;

   bool ReadHandleValueClosed(const int handle, const string indicatorName, double &outValue) const;
   bool ReadLastClosedBarTime(datetime &outBarTime) const;

public:
   IndicatorHub(void)
      : m_symbol(""),
        m_tf(PERIOD_H1),
        m_ema50H4Handle(INVALID_HANDLE),
        m_ema200H4Handle(INVALID_HANDLE),
        m_atr14H1Handle(INVALID_HANDLE),
        m_donchianPeriod(20)
   {}

   bool Initialize(const string symbol, const ENUM_TIMEFRAMES tf, const int donchianPeriod = 20);
   bool Refresh(void);
   bool BuildSnapshot(SIndicatorSnapshot &snapshot);
   bool GetSnapshot(SIndicatorSnapshot &outSnapshot) const;
   void Release(void);
};

bool IndicatorHub::Initialize(const string symbol, const ENUM_TIMEFRAMES tf, const int donchianPeriod)
{
   Release();

   m_symbol = symbol;
   m_tf = tf;
   m_donchianPeriod = donchianPeriod;

   if(m_donchianPeriod <= 0)
   {
      Print("[ERROR] Invalid Donchian period: ", m_donchianPeriod);
      return false;
   }

   m_ema50H4Handle = iMA(m_symbol, PERIOD_H4, 50, 0, MODE_EMA, PRICE_CLOSE);
   if(m_ema50H4Handle == INVALID_HANDLE)
   {
      Print("[ERROR] Failed to create EMA50 H4 handle.");
      Release();
      return false;
   }

   m_ema200H4Handle = iMA(m_symbol, PERIOD_H4, 200, 0, MODE_EMA, PRICE_CLOSE);
   if(m_ema200H4Handle == INVALID_HANDLE)
   {
      Print("[ERROR] Failed to create EMA200 H4 handle.");
      Release();
      return false;
   }

   m_atr14H1Handle = iATR(m_symbol, PERIOD_H1, 14);
   if(m_atr14H1Handle == INVALID_HANDLE)
   {
      Print("[ERROR] Failed to create ATR14 H1 handle.");
      Release();
      return false;
   }

   return true;
}

bool IndicatorHub::Refresh(void)
{
   if(m_ema50H4Handle == INVALID_HANDLE || m_ema200H4Handle == INVALID_HANDLE || m_atr14H1Handle == INVALID_HANDLE)
   {
      Print("[ERROR] IndicatorHub refresh called with invalid handles.");
      return false;
   }

   if(BarsCalculated(m_ema50H4Handle) < 2)
   {
      Print("[ERROR] EMA50 H4 not enough calculated bars.");
      return false;
   }

   if(BarsCalculated(m_ema200H4Handle) < 2)
   {
      Print("[ERROR] EMA200 H4 not enough calculated bars.");
      return false;
   }

   if(BarsCalculated(m_atr14H1Handle) < 2)
   {
      Print("[ERROR] ATR14 H1 not enough calculated bars.");
      return false;
   }

   return true;
}

bool IndicatorHub::BuildSnapshot(SIndicatorSnapshot &snapshot)
{
   snapshot.barTime = 0;
   snapshot.emaFast = 0.0;
   snapshot.emaSlow = 0.0;
   snapshot.atr = 0.0;
   snapshot.donchianHigh = 0.0;
   snapshot.donchianLow = 0.0;
   snapshot.isValid = false;

   if(!Refresh())
      return false;

   if(!ReadLastClosedBarTime(snapshot.barTime))
   {
      Print("[ERROR] Failed to read last closed H1 bar time.");
      return false;
   }

   if(!ReadHandleValueClosed(m_ema50H4Handle, "EMA50 H4", snapshot.emaFast))
      return false;

   if(!ReadHandleValueClosed(m_ema200H4Handle, "EMA200 H4", snapshot.emaSlow))
      return false;

   if(!ReadHandleValueClosed(m_atr14H1Handle, "ATR14 H1", snapshot.atr))
      return false;

   if(!m_donchian.GetHighestHighClosed(m_symbol, PERIOD_H1, m_donchianPeriod, snapshot.donchianHigh))
   {
      Print("[ERROR] Failed to calculate Donchian high.");
      return false;
   }

   if(!m_donchian.GetLowestLowClosed(m_symbol, PERIOD_H1, m_donchianPeriod, snapshot.donchianLow))
   {
      Print("[ERROR] Failed to calculate Donchian low.");
      return false;
   }

   snapshot.isValid = true;
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
   return false;
}

void IndicatorHub::Release(void)
{
   if(m_ema50H4Handle != INVALID_HANDLE)
   {
      IndicatorRelease(m_ema50H4Handle);
      m_ema50H4Handle = INVALID_HANDLE;
   }

   if(m_ema200H4Handle != INVALID_HANDLE)
   {
      IndicatorRelease(m_ema200H4Handle);
      m_ema200H4Handle = INVALID_HANDLE;
   }

   if(m_atr14H1Handle != INVALID_HANDLE)
   {
      IndicatorRelease(m_atr14H1Handle);
      m_atr14H1Handle = INVALID_HANDLE;
   }
}

bool IndicatorHub::ReadHandleValueClosed(const int handle, const string indicatorName, double &outValue) const
{
   outValue = 0.0;
   double values[];
   ArraySetAsSeries(values, true);

   // Read shift=1 to consume only the last closed candle value.
   int copied = CopyBuffer(handle, 0, 1, 1, values);
   if(copied < 1)
   {
      Print("[ERROR] CopyBuffer failed for ", indicatorName, ". copied=", copied);
      return false;
   }

   outValue = values[0];
   return true;
}

bool IndicatorHub::ReadLastClosedBarTime(datetime &outBarTime) const
{
   outBarTime = 0;
   datetime times[];
   ArraySetAsSeries(times, true);
   int copied = CopyTime(m_symbol, PERIOD_H1, 1, 1, times);
   if(copied < 1)
      return false;

   outBarTime = times[0];
   return true;
}
