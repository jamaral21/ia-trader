#pragma once

class Logger
{
private:
   int m_level;

public:
   Logger(void) : m_level(2) {}

   void SetLevel(const int level) { m_level = level; }

   void Info(const string msg) const
   {
      if(m_level >= 2)
         Print("[INFO] ", msg);
   }

   void Warn(const string msg) const
   {
      if(m_level >= 1)
         Print("[WARN] ", msg);
   }

   void Error(const string msg) const
   {
      Print("[ERROR] ", msg);
   }

   void Debug(const string msg) const
   {
      if(m_level >= 3)
         Print("[DEBUG] ", msg);
   }
};
