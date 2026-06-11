#pragma once

#include "MessageBus.mqh"
#include "MasterSlaveProtocol.mqh"

class ReplicationService
{
private:
   MessageBus m_bus;
   MasterSlaveProtocol m_protocol;

public:
   bool Start(void) { return m_bus.Connect(); }
   void Stop(void) { m_bus.Disconnect(); }
};
