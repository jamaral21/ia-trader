#pragma once

#include "..\SignalEA_v1.types.mqh"

class StateStore
{
private:
   ENUM_EA_STATE m_state;
   datetime m_lastProcessedBar;
   ENUM_BREAKOUT_STATE m_breakoutState;

public:
   StateStore(void) : m_state(EA_STATE_BOOT), m_lastProcessedBar(0), m_breakoutState(BREAKOUT_READY) {}

   void SetEAState(const ENUM_EA_STATE s) { m_state = s; }
   ENUM_EA_STATE GetEAState(void) const { return m_state; }

   void SetLastProcessedBar(const datetime t) { m_lastProcessedBar = t; }
   datetime GetLastProcessedBar(void) const { return m_lastProcessedBar; }

   void LockBreakout(void) { m_breakoutState = BREAKOUT_LOCKED; }
   void UnlockBreakout(void) { m_breakoutState = BREAKOUT_READY; }
   bool IsBreakoutLocked(void) const { return (m_breakoutState == BREAKOUT_LOCKED); }
};
