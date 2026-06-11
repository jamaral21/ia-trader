#pragma once

class MessageBus
{
public:
   bool Connect(void) { return true; }
   void Disconnect(void) {}
   bool Publish(const string topic, const string payload) { return false; }
   bool Subscribe(const string topic) { return false; }
};
